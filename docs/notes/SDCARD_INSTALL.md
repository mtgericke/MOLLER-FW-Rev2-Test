# SDCard

## Formatting

```
	sudo parted ${SDCARD_DEV} --script -- mklabel msdos
	sudo parted ${SDCARD_DEV} --script -- mkpart primary fat32 1MiB 257MiB
	sudo parted ${SDCARD_DEV} --script -- mkpart primary ext4 257MiB 100%
	sudo partprobe ${SDCARD_DEV}
	sudo sync
	sudo mkfs.vfat -F32 ${SDCARD_DEV}1
	sudo fatlabel ${SDCARD_DEV}1 BOOT
	sudo mkfs.ext4 -L PETALINUX ${SDCARD_DEV}2
	sudo sync
```

## Updating an SDCard

If there is a rootfs.tar.gz file, then we use the old method, otherwise choose new

### Old Method

1. Run `cp BOOT.bin boot.scr Image /<sdcard mount>/BOOT`
1. Run `tar -xvf rootfs.tar.gz -C /<sdcard mount>/PETALINUX`

### New method

1. Run `cp BOOT.bin boot.scr Image rootfs.cpio.gz.u-boot /<sdcard mount>/BOOT`