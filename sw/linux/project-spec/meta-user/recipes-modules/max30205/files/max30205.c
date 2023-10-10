// SPDX-License-Identifier: GPL-2.0-or-later
/*
 * Copyright (C) 2022 Bryerton Shaw <bryerton@triumf.ca>
 */

/*
	Device tree example

	temp1@4b {
		compatible = "triumf,max30205";
		reg = <0x4b>;
		config = <0x0>; <-- change this to <0x20> for extended temp range
		t_hyst = <0x4B00>;
		t_os = <0x5000>;
	};
*/

/*
	// Reading sensor example
	#include <stdint.h>
	#include <stdio.h>

	...

	int ic;
	int32_t temp_raw = 0;
	float temp;

	ic = open("/sys/bus/i2c/devices/0-004b/temp", O_RDONLY);
	if(ic >= 0) {
		read(ic, &temp_raw, sizeof(temp_raw));
		close(ic);
	}
	// Convert from milliCelsius to Celsius
	temp = (float)temp_raw / 1000;

	...
*/

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/device.h>
#include <linux/capability.h>
#include <linux/jiffies.h>
#include <linux/i2c.h>
#include <linux/mutex.h>

#define DEVICE_NAME "max30205"
#define DEVICE_SIZE 4

/* Each client has this additional data */
struct max30205_data {
	struct mutex update_lock;
	u8 config;
	u16 t_os;
	u16 t_hys;
};

static ssize_t max30205_read(struct file *filp, struct kobject *kobj,
			   struct bin_attribute *bin_attr,
			   char *buf, loff_t off, size_t count) {

	struct i2c_client *client = kobj_to_i2c_client(kobj);
	struct max30205_data *data = i2c_get_clientdata(client);

	s16 word;
	s32 temp;

  	if(count == 4) {
    	mutex_lock(&data->update_lock);
    	word = i2c_smbus_read_word_swapped(client, 0);
    	mutex_unlock(&data->update_lock);

		// convert temperature to milliCelsius
		// is the device is set to extended temperature format?
		if(data->config & 0x20) {
			temp = ((temp * 39062) + 640000000) / 10000;
		} else {
			temp = (word * 39063) / 10000;
		}

    	memcpy(buf, &temp, sizeof(temp));

    	return count;
  	} else {
    	return 0;
  	}
}

static const struct bin_attribute max30205_attr = {
	.attr = {
		.name = "temp",
		.mode = S_IRUGO,
	},
	.size = DEVICE_SIZE,
	.read = max30205_read,
};

static int max30205_probe(struct i2c_client *client,
			const struct i2c_device_id *id) {

	struct i2c_adapter *adapter = client->adapter;
	struct max30205_data *data;
  	u16 t_hyst;
  	u16 t_os;
  	int err;

  	// devm_kzalloc() memory is automatically de-allocated for us when device is disconnected
	data = devm_kzalloc(&client->dev, sizeof(struct max30205_data),
			    GFP_KERNEL);
	if (!data) {
	  return -ENOMEM;
  	}

	i2c_set_clientdata(client, data);
	mutex_init(&data->update_lock);

	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WRITE_WORD_DATA)) {
		mutex_lock(&data->update_lock);

		err = device_property_read_u8(&client->dev, "config", &data->config);
		if(err) { data->config = 0; }
		i2c_smbus_write_byte_data(client, 0x01, data->config);

		err = device_property_read_u16(&client->dev, "t_hyst", &t_hyst);
		if(err) { t_hyst = 0x4B00; }
		i2c_smbus_write_word_data(client, 0x02, t_hyst);

		err = device_property_read_u16(&client->dev, "t_os", &t_os);
		if(err) { t_os = 0x5000; }
		i2c_smbus_write_word_data(client, 0x03, t_os);

		mutex_unlock(&data->update_lock);
	}

	/* create the sysfs temp file */
	return sysfs_create_bin_file(&client->dev.kobj, &max30205_attr);
}

static int max30205_remove(struct i2c_client *client) {
	sysfs_remove_bin_file(&client->dev.kobj, &max30205_attr);

	return 0;
}

static const struct i2c_device_id max30205_id[] = {
	{ DEVICE_NAME, 0 },
	{ }
};

static struct i2c_driver max30205_driver = {
	.driver = {
		.name	= DEVICE_NAME,
	},
	.probe		= max30205_probe,
	.remove		= max30205_remove,
	.id_table	= max30205_id,
};

module_i2c_driver(max30205_driver);

MODULE_AUTHOR("Bryerton Shaw <bryerton@triumf.ca>");
MODULE_DESCRIPTION("MAX30205 Human Body Temperature Sensor driver");
MODULE_LICENSE("GPL");