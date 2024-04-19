#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/sysinfo.h>
#include <string.h>
#include <ifaddrs.h>
#include <netdb.h>
#include <linux/if_link.h>

#include "moller.h"
#include "lib/discovery/discovery.h"
#include "lib/discovery/discovery_udp_linux.h"

static void eeprom_get_values(uint64_t* logicalID, uint64_t* devID);
static int is_ip_assigned(const char* intf_name);

void* discovery_thread(void *vargp) {
    tDiscoveryContextLinux ctx;
	struct sysinfo s_info;
    int error;
	uint64_t devID;
	uint64_t logicalID;

	eeprom_get_values(&logicalID, &devID);

	// Wait until ethernet is up before continuing
	while(!is_ip_assigned("eth0") || !is_ip_assigned("eth1")) {
		sleep(1);
	}

    discovery_client_init(&ctx, INADDR_ANY, devID, logicalID, DISCOVERY_HW_REV, DISCOVERY_FW_REV, DISCOVERY_VENDOR, DISCOVERY_PRODUCT);

    while(1) {
    	error = sysinfo(&s_info);
    	if(error == 0) {
    	    if(discovery_client_update(&ctx, s_info.uptime)) {
				sleep(10);
			}
		}
		sleep(1);
    }

    pthread_exit(NULL);
}


static void eeprom_get_values(uint64_t* logicalID, uint64_t* devID) {
	int eeprom;

	eeprom = open(MOLLER_EEPROM_DEV, O_RDONLY);
	if(eeprom >= 0) {
		if(logicalID) {
			if(read(eeprom, logicalID, sizeof(uint64_t)) != sizeof(uint64_t)) {
				printf("EEPROM: Failed to read all bytes for logical ID\n");
				close(eeprom);
				return;
			}
		}

		if(devID) {
			// Device ID is 8-byte (64-bit) ID stored in factory set ROM section (0xF8)
			if(lseek(eeprom, 0xF8, SEEK_SET) < 0) {
				printf("EEPROM: lseek failed\n");
				close(eeprom);
				return;
			}

			if(read(eeprom, devID, sizeof(uint64_t)) != sizeof(uint64_t)) {
				printf("EEPROM: Failed to read all bytes for device ID\n");
				close(eeprom);
				return;
			}
		}

		close(eeprom);
	} else {
		printf("Failed to open " MOLLER_EEPROM_DEV " for reading\n");
	}
}

static int is_ip_assigned(const char* intf_name) {
	struct ifaddrs *ifaddr;
	int family;
	int s;
	char host[NI_MAXHOST];

	if (getifaddrs(&ifaddr) == -1) {
		return 0;
	}

	for (struct ifaddrs *ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next) {
		if (ifa->ifa_addr == NULL)
			continue;

		// If we find the structure we are looking for, return immediately
		if((strcmp(ifa->ifa_name, intf_name) == 0) && (ifa->ifa_addr->sa_family == AF_INET)) {
			freeifaddrs(ifaddr);
			return 1;
		}
	}

	freeifaddrs(ifaddr);

	return 0;
}
