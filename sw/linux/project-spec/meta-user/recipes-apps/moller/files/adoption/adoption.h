#ifndef _ADOPTION_H_
#define _ADOPTION_H_

#ifdef __cplusplus /* If this is a C++ compiler, use C linkage */
extern "C" {
#endif

#include <stdint.h>

#ifndef ADOPTION_MIN_DELAY
#define ADOPTION_MIN_DELAY 5
#endif

#define ADOPTION_VERSION        "01"
#define ADOPTION_BEACON_STR     "BEACON" ADOPTION_VERSION
#define ADOPTION_REQUEST_STR    "RQUEST" ADOPTION_VERSION
#define ADOPTION_VENDOR_LEN 64
#define ADOPTION_PRODUCT_LEN 96
#define ADOPTION_HW_REV_LEN 32
#define ADOPTION_FW_REV_LEN 32

#define ADOPTION_DONT_CARE 0xFFFFFFFFFFFFFFFF

#define ADOPTION_BEACON_LEN (8 + 8 + 8 + 8 + ADOPTION_HW_REV_LEN + ADOPTION_FW_REV_LEN + ADOPTION_VENDOR_LEN +ADOPTION_PRODUCT_LEN)

typedef struct tAdoptionBeaconInfo {
    uint8_t isRequest;
    uint64_t uptime;
    uint64_t deviceID;
    uint64_t logicalID;
    char hardwareRevision[ADOPTION_HW_REV_LEN+1];
    char firmwareRevision[ADOPTION_FW_REV_LEN+1];
    char vendorName[ADOPTION_VENDOR_LEN+1];
    char productName[ADOPTION_PRODUCT_LEN+1];
} tAdoptionBeaconInfo;

typedef struct tAdoptionContext {
    uint8_t msg[ADOPTION_BEACON_LEN];
    uint64_t last_uptime;
} tAdoptionContext;

const uint8_t* adoption_create_beacon(tAdoptionContext* ctx, uint64_t devID, uint64_t logicalID, const char*  hwRev, const char*  fwRev, const char* vendor, const char* product);
const uint8_t* adoption_create_request(uint8_t* buff, uint32_t buffLen, uint64_t devID, uint64_t logicalID, const char*  hwRev, const char*  fwRev, const char* vendor, const char* product);
const uint8_t* adoption_process_request(tAdoptionContext* ctx, const uint8_t* rx, uint32_t rx_len, uint64_t uptime);

tAdoptionBeaconInfo* adoption_convert_mem_to_beacon(tAdoptionBeaconInfo* beacon, const uint8_t* buffer, uint32_t buff_len);

#ifdef __cplusplus /* If this is a C++ compiler, end C linkage */
}
#endif

#endif // _ADOPTION_H_