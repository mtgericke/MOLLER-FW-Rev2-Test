#ifndef ADOPTION_UDP_LINUX_H
#define ADOPTION_UDP_LINUX_H

#ifdef __cplusplus /* If this is a C++ compiler, use C linkage */
extern "C" {
#endif

#include <stdint.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include "adoption.h"

#define ADOPTION_UDP_PORT 4200
#define ADOPTION_MIN_DELAY 5

#ifndef ADOPTION_MAX_BEACONS
#define ADOPTION_MAX_BEACONS 253
#endif

typedef struct tAdoptionContextLinux {
    tAdoptionContext ctx;
    int sockfd;
} tAdoptionContextLinux;

typedef struct tAdoptionListItem {
    uint32_t ip;
    tAdoptionBeaconInfo info;
} tAdoptionListItem;

typedef struct tAdoptionList {
    struct tAdoptionListItem device;
    struct tAdoptionList* next;
} tAdoptionList;

typedef struct {
    int sockfd;
    tAdoptionList* responses;
    tAdoptionList* latest_response;
    uint32_t num_responses;
    tAdoptionListItem last_rx_device;
} tAdoptionServerContext;

void adoption_client_init(tAdoptionContextLinux* ctx, in_addr_t ip, uint64_t devID, uint64_t logicalID, const char* hwRev, const char* fwRev, const char* vendor, const char* product);
void adoption_client_update(tAdoptionContextLinux* ctx, uint64_t uptime);

void adoption_server_init(tAdoptionServerContext* ctx, in_addr_t ip);
void adoption_server_shutdown(tAdoptionServerContext* ctx);
void adoption_server_update(tAdoptionServerContext* ctx);
void adoption_server_send_request(tAdoptionServerContext* ctx, uint64_t devID, uint64_t logicalID, const char* hwRev, const char* fwRev, const char* vendor, const char* product);
const tAdoptionListItem* adoption_server_get_next(tAdoptionServerContext* ctx);
uint32_t adoption_server_get_num_responses(tAdoptionServerContext* ctx);

void adoption_print_beacon(const tAdoptionBeaconInfo* info);

#ifdef __cplusplus /* If this is a C++ compiler, end C linkage */
}
#endif

#endif // ADOPTION_UDP_LINUX_H