# Moller 16-Channel Integrating ADC

## Mercury SOM Used

ME-XU1-6CG-1E-D11E-G1-R4.1

## Prequisites

* Ubuntu 20.04 LTS (Tested)
* Vivado 2020.2
* PetaLinux SDK 2020.2

## Project Layout

* /docs - Project documentation and notes
* /hdl - Hardware description files and related TCL scripts
* /sw - Linux and applications
  * /scripts - python and C scripts for interacting with the ADC
  * /linux - Petalinux project
    * /project-spec/meta-user/recipes-apps - Application(s) base directory
      * moller - Custom moller application
      * moller-service - Service to control moller application (start/stop)
      * zeromq - ZeroMQ library
      * lz4 - LZ4 library, not currently in use
      * peekpoke - Xilinx default test app, to be uninstalled
      * gpio-demo - Xilinx default test app, to be uninstalled
      * user-setup - Installs authorized_keys file for SSH
    * /project-spec/meta-user/recipes-bsp - Device-tree and u-boot configuration
      * device-tree/files - Location of custom device-tree configurations for Enclustra + Moller
    * /project-spec/meta-user/recipes-modules - Kernel Modules
      * dma-proxy - DMA proxy driver
      * max30205 - Temperature driver

## Setup

Use of docker is recommended for consistent build environment

1. Download petalinux 2020.2 (petalinux-v2020.2-final-installer.run) and place it in `docker` directory\
1. Download Vivado 2020.2 (Xilinx_Unified_2020.2_1118_1232.tar.gz) and place it in `docker` directory
1. Run `make docker` in the base directory. Note: this requires a large amount of space available!
1. Optional: Create a `env.mk` file in the base directory, insert `SDCARD_DEV := /dev/sdX` where `X` is the path to your SDcard when inserted. This will be used when formatting/copying generated files.

Note: The docker image will look for a Xilinx license in `~/.Xilinx`

## Compilation

### HDL

From the base directory, run `make hdl`

If editing the block design is required run `make gui`

### Petalinux

From the base directory, run `make petalinux`

## SDcard

### Formatting

To format an SDcard for use run `make sdcard-format`

### Copying

To copy the built files to the SDcard use `make sdcard-copy`

## Other

### Setting Module ID in EEPROM

Each Moller module should be assigned a unique ID for easy identification, as the MAC addresses stored on the Enclustra modules are... stored on the Enclustra modules. Should the Enclustra module be replaced or failed, we need to identify the board itself.

The steps are as follows, run from the linux distribution running on the board.

```
> i2cset -y -f 0 0x51 0x0 <module id in decimal>
> i2cset -y -f 0 0x51 0x1 0
> i2cset -y -f 0 0x51 0x2 0
> i2cset -y -f 0 0x51 0x3 0
> i2cset -y -f 0 0x51 0x4 0
> i2cset -y -f 0 0x51 0x5 0
> i2cset -y -f 0 0x51 0x6 0
> i2cset -y -f 0 0x51 0x7 0
```