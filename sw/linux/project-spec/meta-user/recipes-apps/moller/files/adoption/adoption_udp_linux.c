#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "adoption.h"
#include "adoption_udp_linux.h"

static tAdoptionContext ctx;

static int send_udp_msg(int socket, struct sockaddr* addr, const uint8_t* msg, uint16_t len);

void adoption_client_init(tAdoptionContextLinux* ctx, in_addr_t ip, uint64_t devID, uint64_t logicalID, const char* hwRev, const char* fwRev, const char* vendor, const char* product) {
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
    servaddr.sin_port = htons(ADOPTION_UDP_PORT);
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
    baddr.sin_port = htons(ADOPTION_UDP_PORT);
    baddr.sin_addr.s_addr = htonl(INADDR_BROADCAST);

    // Send out broadcast
    send_udp_msg(ctx->sockfd, (struct sockaddr*)&baddr, adoption_create_beacon(&ctx->ctx, devID, logicalID, hwRev, fwRev, vendor, product), ADOPTION_BEACON_LEN);
}

void adoption_client_update(tAdoptionContextLinux* ctx, uint64_t uptime) {
    int ret;
    uint8_t msg_request[ADOPTION_BEACON_LEN];
    const uint8_t* msg_response;
    struct sockaddr_in from;
    socklen_t from_len;


    if(!ctx) {
        return;
    }

    // check for requests
    from_len = sizeof(from);
    ret = recvfrom(ctx->sockfd, msg_request, ADOPTION_BEACON_LEN, MSG_DONTWAIT, (struct sockaddr*)&from, &from_len);
    if(ret == ADOPTION_BEACON_LEN) {
        msg_response = adoption_process_request(&ctx->ctx, msg_request, ADOPTION_BEACON_LEN, uptime);
        if(msg_response) {
            send_udp_msg(ctx->sockfd, (struct sockaddr*)&from, msg_response, ADOPTION_BEACON_LEN);
        }
    }
}

void adoption_server_init(tAdoptionServerContext* ctx, in_addr_t ip) {
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
    servaddr.sin_port = htons(ADOPTION_UDP_PORT);
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

void adoption_server_shutdown(tAdoptionServerContext* ctx) {
    tAdoptionList* next;

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

void adoption_server_update(tAdoptionServerContext* ctx) {
    int ret;
    uint8_t msg[ADOPTION_BEACON_LEN];
    struct sockaddr_in from;
    socklen_t from_len;
    tAdoptionBeaconInfo info;
    tAdoptionList* next;

    if(!ctx) {
        return;
    }

    if(ctx->num_responses < ADOPTION_MAX_BEACONS) {

        // check for beacons
        from_len = sizeof(from);
        ret = recvfrom(ctx->sockfd, msg, ADOPTION_BEACON_LEN, MSG_DONTWAIT, (struct sockaddr*)&from, &from_len);
        if(ret == ADOPTION_BEACON_LEN) {
            if(adoption_convert_mem_to_beacon(&info, msg, ADOPTION_BEACON_LEN)) {
                if(!info.isRequest) {
                    next = (tAdoptionList*)malloc(sizeof(tAdoptionList));
                    if(next) {
                        next->device.ip = from.sin_addr.s_addr;
                        memcpy(&next->device.info, &info, sizeof(tAdoptionBeaconInfo));
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

void adoption_server_send_request(tAdoptionServerContext* ctx, uint64_t devID, uint64_t logicalID, const char* hwRev, const char* fwRev, const char* vendor, const char* product) {
    struct sockaddr_in baddr;
    tAdoptionContext beacon;

    if(!ctx) {
        return;
    }

    // Setup broadcast address
    memset(&baddr, 0, sizeof(baddr));
    baddr.sin_family = AF_INET;
    baddr.sin_port = htons(ADOPTION_UDP_PORT);
    baddr.sin_addr.s_addr = htonl(INADDR_BROADCAST);

    // Send out broadcast
    send_udp_msg(ctx->sockfd, (struct sockaddr*)&baddr, adoption_create_beacon(&beacon, devID, logicalID, hwRev, fwRev, vendor, product), ADOPTION_BEACON_LEN);
}

const tAdoptionListItem* adoption_server_get_next(tAdoptionServerContext* ctx) {
    if(!ctx) {
        return 0;
    }

    if(ctx->responses) {
        memcpy(&ctx->last_rx_device, &ctx->responses->device, sizeof(tAdoptionListItem));
        ctx->responses = ctx->responses->next;
        ctx->num_responses--;
        return &ctx->last_rx_device;
    }

    return 0;
}

uint32_t adoption_server_get_num_responses(tAdoptionServerContext* ctx) {
    if(!ctx) {
        return 0;
    }

    return ctx->num_responses;
}

void adoption_print_beacon(const tAdoptionBeaconInfo* info) {
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