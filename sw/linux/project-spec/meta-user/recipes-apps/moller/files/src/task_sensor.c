#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <fcntl.h>
#include <sched.h>
#include "moller.h"

static float read_temp(int n);
static float read_iio_sensor(const char* str_raw, const char* str_scale, const char* str_offset, float factor);

void* sensor_thread(void *vargp) {
	printf("Starting Sensor Thread\n");
	while(1) {

        sched_yield();
	}

	pthread_exit(NULL);
}

static float read_temp(int n) {
	int temp_sense;
	int32_t temp_raw;
	float temp;

	switch(n) {
		case 0: // enclustra
			temp_sense = open("/sys/bus/i2c/devices/0-0049/temp", O_RDONLY);
			break;
		case 1: // power
			temp_sense = open("/sys/bus/i2c/devices/0-004a/temp", O_RDONLY);
			break;
		case 2: // board
			temp_sense = open("/sys/bus/i2c/devices/0-004b/temp", O_RDONLY);
			break;
		default:
			temp_sense = -1;
			break;
	}

	if(temp_sense >= 0) {
		read(temp_sense, &temp_raw, sizeof(temp_raw));
		close(temp_sense);
	} else {
		temp_raw = 0;
	}

	// convert from milliCelsius to celsius
	temp = (float)temp_raw / 1000;

	return temp;
}

static float read_iio_sensor(const char* str_raw, const char* str_scale, const char* str_offset, float factor) {
    FILE *in_file;

	int64_t raw;
	int64_t offset;
	float scale;

	if(str_raw) {
		in_file = fopen(str_raw, "r");
		fscanf(in_file,"%ld", &raw);
		fclose(in_file);
	} else {
		raw = 0;
	}

	if(str_scale) {
		in_file = fopen(str_scale, "r");
		fscanf(in_file,"%f", &scale);
		fclose(in_file);
	} else {
		scale = 1.0f;
	}

	if(str_offset) {
		in_file = fopen(str_offset, "r");
		fscanf(in_file,"%ld", &offset);
		fclose(in_file);
	} else  {
		offset = 0;
	}

	return ((raw + offset) * scale) * factor;
}

    /*

	struct timeval start, stop;
    double secs;

	gettimeofday(&start, NULL);

		gettimeofday(&stop, NULL);
		secs = (double)(stop.tv_usec - start.tv_usec) / 1000000 + (double)(stop.tv_sec - start.tv_sec);
		if(secs >= UPDATE_RATE) {
			sndbuf[0] = (stop.tv_usec - start.tv_usec) + ((stop.tv_sec - start.tv_sec) * 1000000); // time in usec
			sndbuf[1] = num_pkts;
			sndbuf[2] = num_bytes;
			sndbuf[3] = num_errors;
			sndbuf[4] = num_valid;
			sndbuf[5] = num_timeouts;
			sndbuf[6] = num_samples;

			double value;
			value = read_temp(0); // enclustra
			memcpy(&sndbuf[7], &value, sizeof(value));

			value = read_temp(1); // power
			memcpy(&sndbuf[8], &value, sizeof(value));

			value = read_temp(2); // board
			memcpy(&sndbuf[9], &value, sizeof(value));

			value = read_fpga_temp("in_temp0_ps_temp");
			memcpy(&sndbuf[10], &value, sizeof(value));

			value = read_fpga_temp("in_temp1_remote_temp");
			memcpy(&sndbuf[11], &value, sizeof(value));

			value = read_fpga_temp("in_temp2_pl_temp");
			memcpy(&sndbuf[12], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage0_vcc_pspll0");
			memcpy(&sndbuf[13], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage1_vcc_psbatt");
			memcpy(&sndbuf[14], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage2_vccint");
			memcpy(&sndbuf[15], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage3_vccbram");
			memcpy(&sndbuf[16], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage4_vccaux");
			memcpy(&sndbuf[17], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage5_vcc_psddrpll");
			memcpy(&sndbuf[18], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage6_vccpsintfpddr");
			memcpy(&sndbuf[19], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage7_vccpsintlp");
			memcpy(&sndbuf[20], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage8_vccpsintfp");
			memcpy(&sndbuf[21], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage9_vccpsaux");
			memcpy(&sndbuf[22], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage10_vccpsddr");
			memcpy(&sndbuf[23], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage11_vccpsio3");
			memcpy(&sndbuf[24], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage12_vccpsio0");
			memcpy(&sndbuf[25], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage13_vccpsio1");
			memcpy(&sndbuf[26], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage14_vccpsio2");
			memcpy(&sndbuf[27], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage15_psmgtravcc");
			memcpy(&sndbuf[28], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage16_psmgtravtt");
			memcpy(&sndbuf[29], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage17_vccams");
			memcpy(&sndbuf[30], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage18_vccint");
			memcpy(&sndbuf[31], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage19_vccaux");
			memcpy(&sndbuf[32], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage20_vccvrefp");
			memcpy(&sndbuf[33], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage21_vccvrefn");
			memcpy(&sndbuf[34], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage22_vccbram");
			memcpy(&sndbuf[35], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage23_vccplintlp");
			memcpy(&sndbuf[36], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage24_vccplintfp");
			memcpy(&sndbuf[37], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage25_vccplaux");
			memcpy(&sndbuf[38], &value, sizeof(value));

			value = read_fpga_voltage("in_voltage26_vccams");
			memcpy(&sndbuf[39], &value, sizeof(value));
        }
            */
