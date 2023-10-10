
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <pthread.h>
#include <time.h>
#include <sys/time.h>
#include <stdint.h>
#include <signal.h>
#include <sched.h>
#include <time.h>
#include <errno.h>
#include <sys/param.h>

#include <stdio.h>
#include <zmq.h>
#include <unistd.h>
#include <string.h>
#include <sys/mman.h>
#include <sched.h>
#include "external/dma-proxy.h"
#include "moller.h"

void* dma_thread(void *vargp) {

   	void *context;
	void* pub;

	struct channel_buffer *rx_proxy_interface_p;
	int rx_proxy_fd, i;
	int buffer_index;
	uint64_t header;
	uint8_t header_id;
	uint32_t header_len;
	uint32_t header_num;
	uint64_t num_pkts;
	uint64_t num_bytes;
	uint64_t num_errors;
	uint64_t num_valid;
	uint64_t num_timeouts;
	uint64_t num_samples;
	int compressed_size;

	context = vargp;

	pub = zmq_socket(context, ZMQ_PUB);
	zmq_setsockopt(pub, ZMQ_SNDHWM, "", 32768);
	zmq_setsockopt(pub, ZMQ_SNDBUF, "", 32768);
	if(zmq_bind(pub, "tcp://*:5556") != 0) {
        printf("Failed to bind ZMQ to port 5556\n");
        pthread_exit(NULL);
    }

	// Open the DMA proxy device for the transmit and receive channels
	rx_proxy_fd = open("/dev/dma_proxy_rx", O_RDWR);
	if (rx_proxy_fd < 1) {
		printf("Unable to open DMA proxy device file\n");
		pthread_exit(NULL);
	}

	// Map the transmit and receive channels memory into user space so it's accessible
	rx_proxy_interface_p = (struct channel_buffer *)mmap(NULL, sizeof(struct channel_buffer),
									PROT_READ | PROT_WRITE, MAP_SHARED, rx_proxy_fd, 0);

	if (rx_proxy_interface_p == MAP_FAILED) {
		printf("Failed to mmap dma proxy\n");
		pthread_exit(NULL);
	}

	num_pkts = 0;
	num_bytes = 0;
	num_errors = 0;
	num_valid = 0;
	num_timeouts = 0;
	num_samples = 0;

	while(1) {
		// Perform a receive DMA transfer and after it finishes check the status
		rx_proxy_interface_p->length = BUFFER_SIZE;

		buffer_index = 0;
		ioctl(rx_proxy_fd, XFER, &buffer_index);
		switch(rx_proxy_interface_p->status) {
			case PROXY_NO_ERROR:
				num_pkts++;
				// First 64-bit word is header, use that to determine what to do with the data packet
				header = *(uint64_t*)&rx_proxy_interface_p->buffer[0];
				if(header != 0) {
					// Copy rest of packet
					header_id = header >> 56;
					header_len = header & 0x000000000000FFFF;
					header_num = (header >> 16) & 0x00000000FFFFFFFF;
					if(header_len < (BUFFER_SIZE/8)) {
						num_bytes += 8+(header_len*8);
						num_valid++;

						switch(header_id) {
							case 0xAA:
								zmq_send(pub, "AVG", 3, ZMQ_SNDMORE);
								zmq_send (pub, rx_proxy_interface_p->buffer, 8+(header_len*8), 0);
								break;

							case 0xDD:
								zmq_send(pub, "ADC", 3, ZMQ_SNDMORE);
								zmq_send (pub, (const char*)rx_proxy_interface_p->buffer, 8+(header_len*8), 0);
								num_samples += (header_len-1); // don't count timestamp word
								break;
							default: break;
						}

					} else {
						printf("Max words exceeded! Header: %.016lX (id: %u len: %u)\n", header, header_id, header_len);
						num_errors++;
					}
				}
				break;
			case PROXY_TIMEOUT:
				num_timeouts++;
				// printf("Proxy rx transfer timeout\n");
				break;
			case PROXY_BUSY:
				num_errors++;
				// printf("Proxy rx transfer busy\n");
				break;
			case PROXY_ERROR:
				num_errors++;
				// printf("Proxy rx transfer error\n");
				break;
			default:
				break;
		}

		sched_yield();
	}

	zmq_close(pub);

	// Unmap the proxy channel interface memory and close the device files before leaving
	munmap(rx_proxy_interface_p, sizeof(struct channel_buffer));

	close(rx_proxy_fd);

	pthread_exit(NULL);
}
