
#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>

#include <zmq.h>

#include "moller.h"
#include "external/tinode_regs.h"

static void regmap_init(void);
static void regmap_close(void);

static int tinode_regmap_fd;
static volatile uint32_t *tinode_regmap;

void* tinode_thread(void *vargp) {

	regmap_init();

    if(tinode_regmap) {
        tinode_regmap[TINODE_REG_VME_RESET_INT] = 0x00000020;
        tinode_regmap[TINODE_REG_FIBER_EN]      = 0x000005FF;
        tinode_regmap[TINODE_REG_CLOCK_SRC]     = 0x00000002;
        tinode_regmap[TINODE_REG_VME_RESET_INT] = 0x00000100;
        tinode_regmap[TINODE_REG_VME_RESET_INT] = 0x00000200;
        tinode_regmap[TINODE_REG_VME_RESET_INT] = 0x00001800;
        tinode_regmap[TINODE_REG_SYNC_SRC_EN]   = 0x00000002;
        tinode_regmap[TINODE_REG_VME_RESET_INT] = 0x00000200;
        tinode_regmap[TINODE_REG_TRIG_DELAY_WIDTH] = 0x0F0000F0;
        tinode_regmap[TINODE_REG_TRIG_PRESCALE] = 0x00000000;
        tinode_regmap[TINODE_REG_BLOCK_TH]      = 0x00000001;

        // Go
        tinode_regmap[TINODE_REG_TRIG_SRC_EN] = 0x00000012;

        // Stop
        // tinode_regmap[TINODE_REG_TRIG_SRC_EN] = 	0x00000000
    }

	regmap_close();

	pthread_exit(NULL);
}

static void regmap_init(void) {
	tinode_regmap_fd = open("/dev/mem", O_RDWR | O_SYNC);
 	if (tinode_regmap_fd == -1) {
    	printf("TINODE /dev/mem access error\n");
    	return;
  	}

	tinode_regmap = (uint32_t*)mmap(NULL, TINODE_RANGE_BYTES, PROT_READ|PROT_WRITE, MAP_SHARED, tinode_regmap_fd, TINODE_DEFAULT_BASEADDR);
	if(!tinode_regmap) {
		printf("Failed to map TINODE registers\n");
		return;
	}
}

static void regmap_close(void) {
	if(tinode_regmap) {
		munmap((void*)tinode_regmap, TINODE_RANGE_BYTES);
	}

	if(tinode_regmap_fd >= 0) {
		close(tinode_regmap_fd);
	}
}
