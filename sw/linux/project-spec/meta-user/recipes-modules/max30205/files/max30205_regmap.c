// SPDX-License-Identifier: GPL-2.0
/*
 * max30205.c - Maxim MAX30205 human body temperature sensor
 *
 * Driver for the Maxim MAX30205 human body temperature sensor
 */
#include <linux/delay.h>
#include <linux/err.h>
#include <linux/gpio/consumer.h>
#include <linux/i2c.h>
#include <linux/iopoll.h>
#include <linux/kernel.h>
#include <linux/limits.h>
#include <linux/module.h>
#include <linux/math64.h>
#include <linux/of.h>
#include <linux/regmap.h>

#include <linux/iio/iio.h>
#include <linux/iio/sysfs.h>

#define DEVICE_NAME "max30205"
#define DEVICE_COMPAT "triumf,max30205"

#define MAX30205_PROP_CONFIG "config"
#define MAX30205_PROP_T_HYS "t_hys"
#define MAX30205_PROP_T_OS "t_os"

/* Default device values */
#define MAX30205_DEFAULT_CONFIG 0x00
#define MAX30205_DEFAULT_T_HSY 0x4B00
#define MAX30205_DEFAULT_T_OS 0x5000

/* LSB to Celsius conversion */
#define MAX30205_LSB_VALUE 0.00390625f

/* temperature register address - volatile */
#define MAX30205_REG_TEMP 0x0

/* Config register address - volatile */
#define MAX30205_REG_CONFIG 0x1

/* T_hysteresis register address - volatile */
#define MAX30205_REG_T_HYS 0x2

/* T_oneshot register address - volatile */
#define MAX30205_REG_T_OS 0x3

enum {
    MAX30205_ATTR_ONE_SHOT,
    MAX30205_ATTR_TIMEOUTn,
    MAX30205_ATTR_DATA_FORMAT,
    MAX30205_ATTR_FAULT_QUEUE,
    MAX30205_ATTR_OS_POLARITY,
    MAX30205_ATTR_OS_COMPARATOR_INT,
    MAX30205_ATTR_SHUTDOWN,
    MAX30205_ATTR_T_HYS,
    MAX30205_ATTR_T_OS,
};

struct max30205_reg_cfg {
    struct reg_field one_shot;
    struct reg_field timeout_n;
    struct reg_field data_format;
    struct reg_field fault_queue;
    struct reg_field os_polarity;
    struct reg_field os_comparator_int;
    struct reg_field shutdown;
};

struct max30205_reg_cfg max30205_config_layout = {
    .one_shot =	REG_FIELD(MAX30205_REG_CONFIG, 7, 7),
    .timeout_n = REG_FIELD(MAX30205_REG_CONFIG, 6, 6),
    .data_format = REG_FIELD(MAX30205_REG_CONFIG, 5, 5),
    .fault_queue = REG_FIELD(MAX30205_REG_CONFIG, 3, 4),
    .os_polarity = REG_FIELD(MAX30205_REG_CONFIG, 2, 2),
    .os_comparator_int = REG_FIELD(MAX30205_REG_CONFIG, 1, 1),
    .shutdown = REG_FIELD(MAX30205_REG_CONFIG, 0, 0),
};

struct max30205_data {
	struct i2c_client *client;
	struct mutex lock;
	struct regmap *regmap;
    struct regmap_field *reg_field_cfg_os;
    struct regmap_field *reg_field_cfg_timeout_n;
    struct regmap_field *reg_field_cfg_data_format;
    struct regmap_field *reg_field_cfg_fault_queue;
    struct regmap_field *reg_field_cfg_os_polarity;
    struct regmap_field *reg_field_cfg_os_comparator_int;
    struct regmap_field *reg_field_cfg_shutdown;
    u8 config;
};

static const struct regmap_range max30205_volatile_reg_range[] = {
    regmap_reg_range(MAX30205_REG_TEMP, MAX30205_REG_T_OS)
};

static const struct regmap_access_table max30205_volatile_regs_tbl = {
	.yes_ranges = max30205_volatile_reg_range,
	.n_yes_ranges = ARRAY_SIZE(max30205_volatile_reg_range),
};

static const struct regmap_range max30205_read_reg_range[] = {
	regmap_reg_range(MAX30205_REG_TEMP, MAX30205_REG_T_OS),
};

static const struct regmap_access_table max30205_readable_regs_tbl = {
	.yes_ranges = max30205_read_reg_range,
	.n_yes_ranges = ARRAY_SIZE(max30205_read_reg_range),
};

static const struct regmap_range max30205_no_write_reg_range[] = {
	regmap_reg_range(MAX30205_REG_TEMP, MAX30205_REG_TEMP)
};

static const struct regmap_access_table max30205_writeable_regs_tbl = {
	.no_ranges = max30205_no_write_reg_range,
	.n_no_ranges = ARRAY_SIZE(max30205_no_write_reg_range),
};

static const struct regmap_config max30205_regmap = {
	.reg_bits = 16,
	.val_bits = 16,

	.volatile_table = &max30205_volatile_regs_tbl,
	.rd_table = &max30205_readable_regs_tbl,
	.wr_table = &max30205_writeable_regs_tbl,

	.use_single_read = true,
	.use_single_write = true,
	.reg_format_endian = REGMAP_ENDIAN_BIG,
	.val_format_endian = REGMAP_ENDIAN_BIG,
	.cache_type = REGCACHE_NONE,
};

static IIO_DEVICE_ATTR(one_shot, S_IWUSR | S_IRUSR,
			max30205_show,
			max30205_store,
			MAX30205_ATTR_ONE_SHOT);


static IIO_DEVICE_ATTR(timeout_n, S_IWUSR | S_IRUSR,
			max30205_show,
			max30205_store,
			MAX30205_ATTR_TIMEOUTn);

static IIO_DEVICE_ATTR(data_format, S_IWUSR | S_IRUSR,
			max30205_show,
			max30205_store,
			MAX30205_ATTR_DATA_FORMAT);

static IIO_DEVICE_ATTR(fault_queue, S_IWUSR | S_IRUSR,
			max30205_show,
			max30205_store,
			MAX30205_ATTR_FAULT_QUEUE);

static IIO_DEVICE_ATTR(os_polarity, S_IWUSR | S_IRUSR,
			max30205_show,
			max30205_store,
			MAX30205_ATTR_OS_POLARITY);

static IIO_DEVICE_ATTR(os_comparator_int, S_IWUSR | S_IRUSR,
			max30205_show,
			max30205_store,
			MAX30205_ATTR_OS_COMPARATOR_INT);

static IIO_DEVICE_ATTR(shutdown, S_IWUSR | S_IRUSR,
			max30205_show,
			max30205_store,
			MAX30205_ATTR_SHUTDOWN);

static IIO_DEVICE_ATTR(t_hys, S_IWUSR | S_IRUSR,
			max30205_show,
			max30205_store,
			MAX30205_ATTR_T_HYS);

static IIO_DEVICE_ATTR(t_os, S_IWUSR | S_IRUSR,
			max30205_show,
			max30205_store,
			MAX30205_ATTR_T_OS);

static struct attribute *max30205_attributes[] = {
    &iio_dev_attr_one_shot.dev_attr.attr,
    &iio_dev_attr_timeout_n.dev_attr.attr,
    &iio_dev_attr_data_format.dev_attr.attr,
    &iio_dev_attr_fault_queue.dev_attr.attr,
    &iio_dev_attr_os_polarity.dev_attr.attr,
    &iio_dev_attr_os_comparator_int.dev_attr.attr,
    &iio_dev_attr_shutdown.dev_attr.attr,
	&iio_dev_attr_t_hys.dev_attr.attr,
	&iio_dev_attr_t_os.dev_attr.attr,
	NULL,
};

static const struct attribute_group max30205_attribute_group = {
	.attrs = max30205_attributes,
};

static ssize_t max30205_store(struct device *dev,
				struct device_attribute *attr,
				const char *buf, size_t len)
{
	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
	struct max30205_data *data = iio_priv(indio_dev);
	bool state;
	int ret;

	ret = strtobool(buf, &state);
	if (ret < 0)
		return ret;

	if (!state)
		return 0;

	mutex_lock(&indio_dev->mlock);
	switch ((u32)this_attr->address) {
		case MAX30205_ATTR_DATA_FORMAT:
			break;
		case MAX30205_ATTR_FAULT_QUEUE:
			break;
		case MAX30205_ATTR_ONE_SHOT:
			break;
		case MAX30205_ATTR_OS_COMPARATOR_INT:
			break;
		case MAX30205_ATTR_OS_POLARITY:
			break;
		case MAX30205_ATTR_SHUTDOWN:
			break;
		case MAX30205_ATTR_T_HYS:
			break;
		case MAX30205_ATTR_T_OS:
			break;
		case MAX30205_ATTR_TIMEOUTn:
			break;
		default:
			ret = -ENODEV;
			break;
	}
	mutex_unlock(&indio_dev->mlock);

	return ret ? ret : len;
}

static ssize_t max30205_show(struct device *dev,
			struct device_attribute *attr,
			char *buf)
{
	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
	struct max30205_data *data = iio_priv(indio_dev);
	int ret;

	mutex_lock(&data->lock);
	switch ((u32)this_attr->address) {
		case MAX30205_ATTR_DATA_FORMAT:
			break;
		case MAX30205_ATTR_FAULT_QUEUE:
			break;
		case MAX30205_ATTR_ONE_SHOT:
			break;
		case MAX30205_ATTR_OS_COMPARATOR_INT:
			break;
		case MAX30205_ATTR_OS_POLARITY:
			break;
		case MAX30205_ATTR_SHUTDOWN:
			break;
		case MAX30205_ATTR_T_HYS:
			break;
		case MAX30205_ATTR_T_OS:
			break;
		case MAX30205_ATTR_TIMEOUTn:
			break;
		default:
			ret = -ENODEV;
			break;
	}
	mutex_unlock(&data->lock);

	return ret;
}

static int max30205_get_temp(struct max30205_data *data,
				     int *ambient_raw)
{
	int ret;

	mutex_lock(&data->lock);
	ret = regmap_read(data->regmap, MAX30205_REG_TEMP, ambient_raw);
	mutex_unlock(&data->lock);

	return ret;
}


static int max30205_read_raw(struct iio_dev *indio_dev,
			     struct iio_chan_spec const *channel, int *val,
			     int *val2, long mask)
{
	struct max30205_data *data = iio_priv(indio_dev);
	int ret;

	switch (mask) {
	case IIO_CHAN_INFO_RAW:
		switch (channel->channel2) {
		case IIO_MOD_TEMP_AMBIENT:
			ret = max30205_get_temp(data, val);
			if (ret < 0)
				return ret;
			return IIO_VAL_INT;
		default:
			return -EINVAL;
		}
	case IIO_CHAN_INFO_OFFSET:
		if (data->config == 1000) {
			*val = 1;
			*val2 = 0;
		} else {
			*val = 0;
			*val2 = data->emissivity * 1000;
		}
		return IIO_VAL_INT_PLUS_MICRO;
	case IIO_CHAN_INFO_SCALE:
		*val = 0; // 0.00390625;
		return IIO_VAL_INT;
	default:
		return -EINVAL;
	}
}

static int max30205_write_raw(struct iio_dev *indio_dev,
			      struct iio_chan_spec const *channel, int val,
			      int val2, long mask)
{
	struct max30205_data *data = iio_priv(indio_dev);

	switch (mask) {
	default:
		return -EINVAL;
	}
}

static const struct iio_chan_spec max30205_channels[] = {
	{
		.type = IIO_TEMP,
		.modified = 1,
		.channel2 = IIO_MOD_TEMP_AMBIENT,
		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
			BIT(IIO_CHAN_INFO_OFFSET) | BIT(IIO_CHAN_INFO_SCALE),
	},
};

static const struct iio_info max30205_info = {
	.read_raw = max30205_read_raw,
	.write_raw = max30205_write_raw,
    .attrs = &max30205_attribute_group,
};

static int max30205_probe(struct i2c_client *client,
			  const struct i2c_device_id *id)
{
	struct iio_dev *indio_dev;
	struct max30205_data *max30205;
	struct regmap *regmap;
	int ret;
    u16 t;

	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*max30205));
	if (!indio_dev) {
		dev_err(&client->dev, "Failed to allocate device\n");
		return -ENOMEM;
	}

	regmap = devm_regmap_init_i2c(client, &max30205_regmap);
	if (IS_ERR(regmap)) {
		ret = PTR_ERR(regmap);
		dev_err(&client->dev, "Failed to allocate regmap: %d\n", ret);
		return ret;
	}

	max30205 = iio_priv(indio_dev);
	i2c_set_clientdata(client, indio_dev);
	max30205->client = client;
	max30205->regmap = regmap;

    max30205->reg_field_cfg_os = devm_regmap_field_alloc(&client->dev, regmap,
					       &max30205_config_layout.one_shot);

    max30205->reg_field_cfg_timeout_n = devm_regmap_field_alloc(&client->dev, regmap,
					       &max30205_config_layout.timeout_n);

    max30205->reg_field_cfg_data_format = devm_regmap_field_alloc(&client->dev, regmap,
					       &max30205_config_layout.data_format);

    max30205->reg_field_cfg_fault_queue = devm_regmap_field_alloc(&client->dev, regmap,
					       &max30205_config_layout.fault_queue);

    max30205->reg_field_cfg_os_polarity = devm_regmap_field_alloc(&client->dev, regmap,
					       &max30205_config_layout.os_polarity);

    max30205->reg_field_cfg_os_comparator_int = devm_regmap_field_alloc(&client->dev, regmap,
					       &max30205_config_layout.os_comparator_int);

    max30205->reg_field_cfg_shutdown = devm_regmap_field_alloc(&client->dev, regmap,
					       &max30205_config_layout.shutdown);

	mutex_init(&max30205->lock);
	indio_dev->name = id->name;
	indio_dev->modes = INDIO_DIRECT_MODE;
	indio_dev->info = &max30205_info;
	indio_dev->channels = max30205_channels;
	indio_dev->num_channels = ARRAY_SIZE(max30205_channels);

    /* Read in kernel module parameters */
    if(device_property_present(&client->dev, MAX30205_PROP_CONFIG)) {
        ret = device_property_read_u8(&client->dev, MAX30205_PROP_CONFIG, &max30205->config);
        if(ret) {
            max30205->config = MAX30205_DEFAULT_CONFIG;
        }
        /* regmap will write 16-bits to 8-bit config reg, so make MSB = LSB */
        regmap_write(max30205->regmap, MAX30205_REG_CONFIG, (max30205->config << 8) | max30205->config);
    }

    if(device_property_present(&client->dev, MAX30205_PROP_T_HYS)) {
        ret = device_property_read_u8(&client->dev, MAX30205_PROP_T_HYS, &t);
        if(ret) {
            t = MAX30205_DEFAULT_T_HSY;
        }
        regmap_write(max30205->regmap, MAX30205_REG_T_HYS, t);
    }

    if(device_property_present(&client->dev, MAX30205_PROP_T_OS)) {
        ret = device_property_read_u8(&client->dev, MAX30205_PROP_T_OS, &t);
        if(ret) {
            t = MAX30205_DEFAULT_T_OS;
        }
        regmap_write(max30205->regmap, MAX30205_REG_T_OS, t);
    }

	return iio_device_register(indio_dev);
}

static int max30205_remove(struct i2c_client *client) {
	struct iio_dev *indio_dev = i2c_get_clientdata(client);
	struct max30205 *data = iio_priv(indio_dev);

	iio_device_unregister(indio_dev);

	return 0;
}

static const struct i2c_device_id max30205_id[] = {
	{ DEVICE_NAME, 0 },
	{ }
};
MODULE_DEVICE_TABLE(i2c, max30205_id);

static const struct of_device_id max30205_of_match[] = {
	{ .compatible = DEVICE_COMPAT },
	{ }
};
MODULE_DEVICE_TABLE(of, max30205_of_match);

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
MODULE_DESCRIPTION("Maxim MAX30205 human body temperature sensor driver");
MODULE_LICENSE("GPL");
