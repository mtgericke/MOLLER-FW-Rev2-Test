#ifndef DISCOVERY_UDP_LINUX_H
#define DISCOVERY_UDP_LINUX_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include "discovery.h"

#define DISCOVERY_UDP_PORT 4200
#define DISCOVERY_MIN_DELAY 5

#ifndef DISCOVERY_MAX_BEACONS
#define DISCOVERY_MAX_BEACONS 253
#endif

typedef struct tDiscoveryContextLinux {
    tDiscoveryContext ctx;
    int sockfd;
} tDiscoveryContextLinux;

typedef struct tDiscoveryListItem {
    uint32_t ip;
    tDiscoveryBeaconInfo info;
} tDiscoveryListItem;

typedef struct tDiscoveryList {
    struct tDiscoveryListItem device;
    struct tDiscoveryList* next;
} tDiscoveryList;

typedef struct {
    int sockfd;
    tDiscoveryList* responses;
    tDiscoveryList* latest_response;
    uint32_t num_responses;
    tDiscoveryListItem last_rx_device;
} tDiscoveryServerContext;

void discovery_client_init(tDiscoveryContextLinux* ctx, in_addr_t ip, uint64_t devID, uint64_t logicalID, const char* hwRev, const char* fwRev, const char* vendor, const char* product);
int discovery_client_update(tDiscoveryContextLinux* ctx, uint64_t uptime);

void discovery_server_init(tDiscoveryServerContext* ctx, in_addr_t ip);
void discovery_server_shutdown(tDiscoveryServerContext* ctx);
void discovery_server_update(tDiscoveryServerContext* ctx);
void discovery_server_send_request(tDiscoveryServerContext* ctx, uint64_t devID, uint64_t logicalID, const char* hwRev, const char* fwRev, const char* vendor, const char* product);
const tDiscoveryListItem* discovery_server_get_next(tDiscoveryServerContext* ctx);
uint32_t discovery_server_get_num_responses(tDiscoveryServerContext* ctx);

void discovery_print_beacon(const tDiscoveryBeaconInfo* info);

#ifdef __cplusplus
}
#endif

#endif // DISCOVERY_UDP_LINUX_H