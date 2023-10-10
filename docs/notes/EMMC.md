# Configuring petalinux for eMMC boot

## Prequisites

- Able to boot from SDcard

## Required rootfs settings

```
   CONFIG_e2fsprogs=y
   CONFIG_e2fsprogs-mke2fs=y
   CONFIG_e2fsprogs-e2fsck=y
   CONFIG_tar=y
   CONFIG_dosfstools=y
```

You can set these via

> petalinux-config -c rootfs

## Setting up the partitions

Boot up the petalinux distribution on the SDcard, once logged in type the following:

> fdisk /dev/mmcblk0

At the prompts, hit the following to create a new primary partition and make it 64MB in size

> n p <default> +64M

Change the type of the partition to 'c' (win95 LBA)

> t c

Create the second primary partition and accept the size defaults to make it take the rest of the eMMC
> n p 2 <default> <default>

Change the type of the partition to '83' (linux)

> t 2 83

Write the partition table to disk

> w

Fdisk should write the partition table and close, if it has not, hit 'q'

Reboot.

Format the two new partitions

> mkfs.vfat /dev/mmcblk0p1

> mkfs.ext4 /dev/mmcblk0p2

Reboot. On the next boot petalinux will see and auto-mount the new partitions under /media

## Update petalinux to build for the eMMC

Run

> petalinux-config

Set the "Image Packaging Configuration" Device node of SD device to `/dev/mmcblk0p2`

Save and exit.

Rebuild petalinux.

## Installation of eMMC data

1. Copy the boot files and rootfs file you are using to the SDcard

1. Boot the device via the SDcard

1.  Copy the boot files and rootfs to the eMMC partitions as appropriate. Match the file and directory structure you use on your SDcard.

1. Set the boot sel pins for the eMMC.

1. Power cycle.

## Things of note

* U-boot may need to be set to store environment variables on the eMMC instead of the SDcard, see your u-boot configuration

