#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "discovery.h"
#include "discovery_udp_linux.h"

static tDiscoveryContext ctx;

static int send_udp_msg(int socket, struct sockaddr* addr, const uint8_t* msg, uint16_t len);

void discovery_client_init(tDiscoveryContextLinux* ctx, in_addr_t ip, uint64_t devID, uint64_t logicalID, const char* hwRev, const char* fwRev, const char* vendor, const char* product) {
    int enable;
    int ret;
    struct sockaddr_in baddr;
    struct sockaddr_in servaddr;

    if(!ctx)  {
        return;
    }

    // Creating socket file descriptor
    ctx->sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if(ctx->sockfd < 0 ) {
        printf("Failed to create socket\n");
        return;
    }

    // Filling server information
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(DISCOVERY_UDP_PORT);
    servaddr.sin_addr.s_addr = ip;

    enable = 1;
    ret = setsockopt(ctx->sockfd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(enable));
    if(ret != 0) {
        printf("Failed to make socket REUSEABLE\n");
        return;
    }

    // Enable broadcast
    enable = 1;
    ret = setsockopt(ctx->sockfd, SOL_SOCKET, SO_BROADCAST, &enable, sizeof(enable));
    if(ret != 0) {
        printf("Failed to make socket broadcastable\n");
        return;
    }

    // Bind to socket
    ret = bind(ctx->sockfd, (struct sockaddr*)&servaddr, sizeof(servaddr));
    if(ret != 0) {
        printf("Failed to bind socket\n");
        return;
    }

    // Setup broadcast address
    memset(&baddr, 0, sizeof(baddr));
    baddr.sin_family = AF_INET;
    baddr.sin_port = htons(DISCOVERY_UDP_PORT);
    baddr.sin_addr.s_addr = htonl(INADDR_BROADCAST);

    // Send out broadcast
    send_udp_msg(ctx->sockfd, (struct sockaddr*)&baddr, discovery_create_beacon(&ctx->ctx, devID, logicalID, hwRev, fwRev, vendor, product), DISCOVERY_BEACON_LEN);
}

int discovery_client_update(tDiscoveryContextLinux* ctx, uint64_t uptime) {
    int ret;
    uint8_t msg_request[DISCOVERY_BEACON_LEN];
    const uint8_t* msg_response;
    struct sockaddr_in from;
    socklen_t from_len;


    if(!ctx) {
        return 0;
    }

    // check for requests
    from_len = sizeof(from);
    ret = recvfrom(ctx->sockfd, msg_request, DISCOVERY_BEACON_LEN, MSG_DONTWAIT, (struct sockaddr*)&from, &from_len);
    if(ret == DISCOVERY_BEACON_LEN) {
        msg_response = discovery_process_request(&ctx->ctx, msg_request, DISCOVERY_BEACON_LEN, uptime);
        if(msg_response) {
            send_udp_msg(ctx->sockfd, (struct sockaddr*)&from, msg_response, DISCOVERY_BEACON_LEN);
            return 1;
        }
    }

    return 0;
}

void discovery_server_init(tDiscoveryServerContext* ctx, in_addr_t ip) {
    int enable;
    int ret;
    struct sockaddr_in servaddr;

    if(!ctx) {
        return;
    }

    ctx->num_responses = 0;
    ctx->responses = 0;
    ctx->latest_response = 0;

    // Creating socket file descriptor
    ctx->sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if(ctx->sockfd < 0 ) {
        printf("Failed to create socket\n");
        return;
    }

    // Filling server information
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(DISCOVERY_UDP_PORT);
    servaddr.sin_addr.s_addr = ip;

    enable = 1;
    ret = setsockopt(ctx->sockfd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(enable));
    if(ret != 0) {
        printf("Failed to make socket REUSEABLE\n");
        return;
    }

    // Enable broadcast
    enable = 1;
    ret = setsockopt(ctx->sockfd, SOL_SOCKET, SO_BROADCAST, &enable, sizeof(enable));
    if(ret != 0) {
        printf("Failed to make socket broadcastable\n");
        return;
    }

    // Bind to socket
    ret = bind(ctx->sockfd, (struct sockaddr*)&servaddr, sizeof(servaddr));
    if(ret != 0) {
        printf("Failed to bind socket\n");
        return;
    }
}

void discovery_server_shutdown(tDiscoveryServerContext* ctx) {
    tDiscoveryList* next;

    if(!ctx) {
        return;
    }

    while(ctx->responses) {
        next = ctx->responses->next;
        free(ctx->responses);
        ctx->responses = next;
    }

    if(ctx->sockfd)  {
        shutdown(ctx->sockfd, SHUT_RDWR);
        close(ctx->sockfd);
    }
}

void discovery_server_update(tDiscoveryServerContext* ctx) {
    int ret;
    uint8_t msg[DISCOVERY_BEACON_LEN];
    struct sockaddr_in from;
    socklen_t from_len;
    tDiscoveryBeaconInfo info;
    tDiscoveryList* next;

    if(!ctx) {
        return;
    }

    if(ctx->num_responses < DISCOVERY_MAX_BEACONS) {

        // check for beacons
        from_len = sizeof(from);
        ret = recvfrom(ctx->sockfd, msg, DISCOVERY_BEACON_LEN, MSG_DONTWAIT, (struct sockaddr*)&from, &from_len);
        if(ret == DISCOVERY_BEACON_LEN) {
            if(discovery_convert_mem_to_beacon(&info, msg, DISCOVERY_BEACON_LEN)) {
                if(!info.isRequest) {
                    next = (tDiscoveryList*)malloc(sizeof(tDiscoveryList));
                    if(next) {
                        next->device.ip = from.sin_addr.s_addr;
                        memcpy(&next->device.info, &info, sizeof(tDiscoveryBeaconInfo));
                        next->next = 0;
                        if(ctx->latest_response) {
                            ctx->latest_response->next = next;
                        } else {
                            ctx->responses = next;
                        }
                        ctx->latest_response = next;
                        ctx->num_responses++;
                    }
                }
            }
        }
    }
}

void discovery_server_send_request(tDiscoveryServerContext* ctx, uint64_t devID, uint64_t logicalID, const char* hwRev, const char* fwRev, const char* vendor, const char* product) {
    struct sockaddr_in baddr;
    tDiscoveryContext beacon;

    if(!ctx) {
        return;
    }

    // Setup broadcast address
    memset(&baddr, 0, sizeof(baddr));
    baddr.sin_family = AF_INET;
    baddr.sin_port = htons(DISCOVERY_UDP_PORT);
    baddr.sin_addr.s_addr = htonl(INADDR_BROADCAST);

    // Send out broadcast
    send_udp_msg(ctx->sockfd, (struct sockaddr*)&baddr, discovery_create_beacon(&beacon, devID, logicalID, hwRev, fwRev, vendor, product), DISCOVERY_BEACON_LEN);
}

const tDiscoveryListItem* discovery_server_get_next(tDiscoveryServerContext* ctx) {
    if(!ctx) {
        return 0;
    }

    if(ctx->responses) {
        memcpy(&ctx->last_rx_device, &ctx->responses->device, sizeof(tDiscoveryListItem));
        ctx->responses = ctx->responses->next;
        ctx->num_responses--;
        return &ctx->last_rx_device;
    }

    return 0;
}

uint32_t discovery_server_get_num_responses(tDiscoveryServerContext* ctx) {
    if(!ctx) {
        return 0;
    }

    return ctx->num_responses;
}

void discovery_print_beacon(const tDiscoveryBeaconInfo* info) {
    if(!info) {
        return;
    }

    printf("Device: %lu, Logical: %lu, hwRev: %s, fwRev: %s, vendor: %s, product: %s, uptime: %lu\n", info->deviceID, info->logicalID, info->hardwareRevision, info->firmwareRevision, info->vendorName, info->productName, info->uptime);
}

static int send_udp_msg(int socket, struct sockaddr* addr, const uint8_t* msg, uint16_t len) {
    if(sendto(socket, msg, len, MSG_DONTWAIT, (struct sockaddr*)addr, sizeof(struct sockaddr_in)) == len) {
        return 1;
    }

    return 0;
}