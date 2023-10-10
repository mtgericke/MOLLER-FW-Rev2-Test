#include <zmq.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <sys/time.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <pthread.h>
#include <byteswap.h>
#include <linux/kernel.h>
#include <sys/sysinfo.h>
#include <gpiod.h>

#include "moller.h"
#include "moller_regs.h"

static struct gpiod_chip *chip;
static struct gpiod_line *adc_cvnt_sel;
// static struct gpiod_line *tach1;
// static struct gpiod_line *tach2;
// static struct gpiod_line *tach3;

static void gpio_init(void);
static void gpio_init_pin(int base, int pin, int dir);
static void gpio_write_pin(int base, int pin, int value);

int main(int argc, char *argv[]) {
	void* context;

    pthread_t thread_dma_id;
    pthread_t thread_cmd_id;
	pthread_t thread_sens_id;
	pthread_t thread_dcvr_id;
	pthread_t thread_tinode_id;

	gpio_init();

    context = zmq_ctx_new();
	zmq_ctx_set(context, ZMQ_IO_THREADS, 4);

    pthread_create(&thread_dma_id, NULL, dma_thread, context);
    pthread_create(&thread_cmd_id, NULL, cmd_thread, context);
	pthread_create(&thread_sens_id, NULL, sensor_thread, context);
	pthread_create(&thread_dcvr_id, NULL, discovery_thread, context);
	pthread_create(&thread_tinode_id, NULL, tinode_thread, context);

	while(1) {
		sched_yield();
	};

	// We never get here...
    zmq_ctx_destroy (context);

	return EXIT_SUCCESS;
}

static void gpio_init(void) {
	struct gpiod_chip *chip;
	struct gpiod_line *adc_cvnt_sel;
	chip = gpiod_chip_open_by_name(MIO_GPIO_CHIP);
	adc_cvnt_sel = gpiod_chip_get_line(chip, MIO_PIN_ADC_CNVT_SEL);
	gpiod_line_request_output(adc_cvnt_sel, GPIOD_CONSUMER_NAME, 0);
}
