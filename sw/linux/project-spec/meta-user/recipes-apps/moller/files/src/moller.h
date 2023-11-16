#ifndef MOLLER_H_
#define MOLLER_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <pthread.h>

#define DISCOVERY_VENDOR "TRIUMF"
#define DISCOVERY_PRODUCT "MOLLER 16-Channel Integrating ADC"
#define DISCOVERY_HW_REV "0"
#define DISCOVERY_FW_REV "0.9.1"

#define MOLLER_EEPROM_DEV "/sys/bus/i2c/devices/0-0051/eeprom"

#define GPIOD_CONSUMER_NAME "moller"
#define MIO_GPIO_CHIP "gpiochip0"

void* cmd_thread(void *vargp);
void* dma_thread(void *vargp);
void* sensor_thread(void *vargp);
void* discovery_thread(void *vargp);
void* tinode_thread(void *vargp);

#ifdef __cplusplus
}
#endif

#endif // MOLLER_H_