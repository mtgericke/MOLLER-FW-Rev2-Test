#ifndef _DISCOVERY_H_
#define _DISCOVERY_H_

#ifdef __cplusplus /* If this is a C++ compiler, use C linkage */
extern "C" {
#endif

#include <stdint.h>

#ifndef DISCOVERY_MIN_DELAY
#define DISCOVERY_MIN_DELAY 5
#endif

#define DISCOVERY_VERSION        "01"
#define DISCOVERY_BEACON_STR     "BEACON" DISCOVERY_VERSION
#define DISCOVERY_REQUEST_STR    "RQUEST" DISCOVERY_VERSION
#define DISCOVERY_VENDOR_LEN 64
#define DISCOVERY_PRODUCT_LEN 96
#define DISCOVERY_HW_REV_LEN 32
#define DISCOVERY_FW_REV_LEN 32

#define DISCOVERY_DONT_CARE 0xFFFFFFFFFFFFFFFF

#define DISCOVERY_BEACON_LEN (8 + 8 + 8 + 8 + DISCOVERY_HW_REV_LEN + DISCOVERY_FW_REV_LEN + DISCOVERY_VENDOR_LEN +DISCOVERY_PRODUCT_LEN)

typedef struct tDiscoveryBeaconInfo {
    uint8_t isRequest;
    uint64_t uptime;
    uint64_t deviceID;
    uint64_t logicalID;
    char hardwareRevision[DISCOVERY_HW_REV_LEN+1];
    char firmwareRevision[DISCOVERY_FW_REV_LEN+1];
    char vendorName[DISCOVERY_VENDOR_LEN+1];
    char productName[DISCOVERY_PRODUCT_LEN+1];
} tDiscoveryBeaconInfo;

typedef struct tDiscoveryContext {
    uint8_t msg[DISCOVERY_BEACON_LEN];
    uint64_t last_uptime;
} tDiscoveryContext;

const uint8_t* discovery_create_beacon(tDiscoveryContext* ctx, uint64_t devID, uint64_t logicalID, const char*  hwRev, const char*  fwRev, const char* vendor, const char* product);
const uint8_t* discovery_create_request(uint8_t* buff, uint32_t buffLen, uint64_t devID, uint64_t logicalID, const char*  hwRev, const char*  fwRev, const char* vendor, const char* product);
const uint8_t* discovery_process_request(tDiscoveryContext* ctx, const uint8_t* rx, uint32_t rx_len, uint64_t uptime);

tDiscoveryBeaconInfo* discovery_convert_mem_to_beacon(tDiscoveryBeaconInfo* beacon, const uint8_t* buffer, uint32_t buff_len);

#ifdef __cplusplus /* If this is a C++ compiler, end C linkage */
}
#endif

#endif // _DISCOVERY_H_