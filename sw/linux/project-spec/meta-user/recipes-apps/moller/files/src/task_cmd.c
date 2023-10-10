#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>

#include <zmq.h>

#include "moller.h"
#include "external/moller_regs.h"

static void regmap_init(void);
static void regmap_close(void);
static void adc_init(void);
static void data_init(void);
static uint32_t find_mid_of_longest_run(uint32_t* channel_errors);

static int moller_regmap_fd;
static volatile uint32_t *moller_regmap;

void* cmd_thread(void *vargp) {
 	void* context;
	void* command;
	uint32_t cmd_msg[256];
	uint32_t addr;
	uint32_t data;
	int cmd_len;

	zmq_msg_t msg;

	context = vargp;

    command = zmq_socket (context, ZMQ_REP);
    if(zmq_bind (command, "tcp://*:5555") != 0) {
        printf("Failed to Bind ZMQ to port 5555");
        return 0;
    }

	regmap_init();

	if(moller_regmap) {

		// Start the ADC
		adc_init();

		// Start the streamer
		data_init();

		while(1) {
			cmd_len = zmq_recv(command, &cmd_msg, sizeof(cmd_msg), ZMQ_NOBLOCK);
			if(cmd_len >= 0) {
				// currently just a simple read/write
				if(cmd_len == 12) {
					switch(cmd_msg[0]) {
					case 'w':
						addr = cmd_msg[1];
						data = cmd_msg[2];

						if(addr >= (MOLLER_RANGE_BYTES/4)) {
							cmd_msg[0] = 'e';
							cmd_len = 4;
						} else {
							moller_regmap[addr] = data;
							cmd_msg[0] = 'r';
							cmd_msg[1] = moller_regmap[addr];
							cmd_len = 8;
						}
						break;

					case 'r':
						addr = cmd_msg[1];

						if(addr < (MOLLER_RANGE_BYTES/4)) {
							cmd_msg[0] = 'r';
							cmd_msg[1] = moller_regmap[addr];
							cmd_len = 8;
						} else {
							cmd_msg[0] = 'e';
							cmd_len = 4;
						}
						break;

					default:
						cmd_msg[0] = 'e';
						cmd_len = 4;
						break;
					}
				} else {
					cmd_msg[0] = 'e';
					cmd_len = 4;
				}

				zmq_send(command, cmd_msg, cmd_len, 0);
			}

			sched_yield();
		}

		regmap_close();
	}

	pthread_exit(NULL);
}

static void data_init(void) {
	moller_regmap[(STREAM_CTRL_OFFSET/4)] = 0x80002000;
}

static void regmap_init(void) {

	moller_regmap_fd = open("/dev/mem", O_RDWR | O_SYNC);
 	if (moller_regmap_fd == -1) {
    	printf("Moller /dev/mem access error\n");
    	return;
  	}

	moller_regmap = (uint32_t*)mmap(NULL, MOLLER_RANGE_BYTES, PROT_READ|PROT_WRITE, MAP_SHARED, moller_regmap_fd, MOLLER_DEFAULT_BASEADDR);
	if(!moller_regmap) {
		printf("Failed to map moller registers\n");
		return;
	}
}


static void regmap_close(void) {
	if(moller_regmap) {
		munmap((void*)moller_regmap, MOLLER_RANGE_BYTES);
	}

	if(moller_regmap_fd >= 0) {
		close(moller_regmap_fd);
	}
}

static void adc_init(void) {
	uint32_t error_counters[16][512];

	for(uint32_t n=0; n<512; n++) {
		// Update delay for all channels
		for(uint32_t ch=0; ch<16; ch++) {
			moller_regmap[(ADC_DELAY_IN_OFFSET/4) + ch] = n;
		}


		// Reset counters and go/stay in test mode
		moller_regmap[ADC_CTRL_OFFSET/4] = 0xE0000000;
		usleep(100);
		moller_regmap[ADC_CTRL_OFFSET/4] = 0xC0000000;

		// Let the counters run for a bit
		usleep(10000);

		// Get counter values for each channel and store results
		for(uint32_t ch=0; ch<16; ch++) {
			error_counters[ch][n] = moller_regmap[(ADC_TEST_DATA_OFFSET/4)+ch];
		}
	}

	// Calculate best position and set delay for each channel
	for(uint32_t ch=0; ch<16; ch++) {
		moller_regmap[(ADC_DELAY_IN_OFFSET/4) + ch] = find_mid_of_longest_run(error_counters[ch]);
	}

	// Reset counters and leave test mode
	moller_regmap[ADC_CTRL_OFFSET/4] = 0xA0000000;
	usleep(100);
	moller_regmap[ADC_CTRL_OFFSET/4] = 0x80000000;
}

static uint32_t find_mid_of_longest_run(uint32_t* channel_errors) {
    uint32_t cur = 0;
    uint32_t run = 0;
    uint32_t pos = 0;
    uint32_t max_pos = 0;
    uint32_t max_run = 0;

	// Since the IDELAY only covers 511 taps, at about 2.5ps per tap for 1250ps total
	for(uint32_t cur = 0; cur < 512; cur++) {

		// Test to see if we had any errors
        if(channel_errors[cur] == 0) {
			// Test for start of 'good' run of values (no error start point)
            if(run == 0) {
                pos = cur;
			}
            run++;
		} else {
			// Encountered an error, if the run of good values till now was better than the last, update
            if(max_run < run) {
                max_pos = pos;
                max_run = run;
			}
            run = 0;
		}
	}

	// Final check, needed if last good run never ended before array did
	if(max_run < run) {
		max_run = run;
		max_pos = pos;
	}

	// Returns mid-point of best run
    return max_pos + (max_run / 2);
}