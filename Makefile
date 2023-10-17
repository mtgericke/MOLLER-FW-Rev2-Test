SHELL := /bin/sh
PETALINUX := petalinux-v2020.2-final-installer.run
VIVADO := Xilinx_Unified_2020.2_1118_1232.tar.gz
VIVADO_VER := 2020.2
VIVADO_CONFIG := install_config.txt
LICENSE_DIR := ~/.Xilinx
SDCARD_ZIP := moller.zip
SDCARD_DEV := /dev/FAKE
SDCARD_BOOT_LABEL := BOOT
SDCARD_ROOTFS_LABEL := PETALINUX
USB_UART := /dev/ttyACM0
DEVICE_IP := 192.168.1.229
SSH_KEY := .ssh/moller_root
SSH_OPTIONS := -i ${SSH_KEY} -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedAlgorithms=+ssh-rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null

# Optional file that can be used to run scripts or change variables (such as SDCARD_DEV) per developer
-include env.mk

.PHONY: all help docker hdl interactive gui project petalinux petalinux-config petalinux-config-kernel petalinux-config-rootfs petalinux-update petalinux-clean sim-adc sim-adc-gui petalinux-boot petalinux-rootfs sdcard-copy

default: help

help: ## List available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = "(:)|(## )"}; {printf "\033[36m%-30s\033[0m %s\n", $$2, $$4}'

all: hdl petalinux

clean: ## Clean
	@rm -f hdl/*.jou
	@rm -f hdl/*.log
	@rm -f hdl/*.pb
	@rm -f hdl/*.wdb
	@rm -f hdl/*.zip
	@rm -f hdl/*.txt
	@rm -rf hdl/.cache
	@rm -rf hdl/.Xil
	@rm -rf hdl/src/bd/Mercury_XU1/ip
	@rm -rf hdl/src/bd/Mercury_XU1/ipshared
	@rm -rf hdl/.cache
	@rm -rf hdl/xsim.dir
	@rm -rf hdl/.Xil
	@rm -rf hdl/xsim.dir
	@rm -rf hdl/output/*.dcp
	@rm -rf hdl/output/*.rpt
	@rm -rf hdl/output/*.v
	@rm -rf hdl/output/*.xdc
	@rm -rf hdl/vivado/moller.cache
	@rm -rf hdl/vivado/moller.hw
	@rm -rf hdl/vivado/moller.ip_user_files
	@rm -rf hdl/vivado/moller.runs
	@rm -rf hdl/vivado/moller.sim

# For timing sim use: -L simprims_ver
# For func/behavioral sim use: -L unisims_ver

sim-trainer-gui: ## Simulate ADC deserializer
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/hdl; \
		xelab -nolog -prj sim/adc_trainer/adc_trainer.prj -L simprims_ver -debug typical -s sim_trainer xil_defaultlib.tb_adc_trainer xil_defaultlib.glbl;  \
		xsim sim_trainer -nolog --gui -wdb sim_trainer.wdb -t sim/adc_trainer/adc_trainer.tcl"


sim-adc: ## Simulate ADC deserializer
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/hdl; \
		./sim/adc/adc_verification_test.sh \
	"
sim-adc-gui: ## Simulate ADC deserializer
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/hdl; \
		xelab -nolog -prj sim/adc/adc.prj -L simprims_ver -debug typical -s sim_adc xil_defaultlib.tb_adc xil_defaultlib.glbl;  \
		xsim sim_adc -nolog --gui -wdb sim_adc.wdb -t sim/adc/adc.tcl"

sim-capture-gui: ## Simulate Capture
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/hdl; \
		xelab -nolog -prj sim/capture/capture.prj -L simprims_ver -debug typical -s sim_capture xil_defaultlib.tb_capture xil_defaultlib.glbl;  \
		xsim sim_capture -nolog --gui -wdb sim_capture.wdb -t sim/capture/capture.tcl"

sim-packetizer-gui: ## Simulate packetizer
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/hdl; \
		xelab -nolog -prj sim/packetizer/packetizer.prj -L simprims_ver -debug typical -s sim_packetizer xil_defaultlib.tb_packetizer xil_defaultlib.glbl;  \
		xsim sim_packetizer -nolog --gui -wdb sim_packetizer.wdb -t sim/packetizer/packetizer.tcl"

docker: ## Build docker image
	mkdir -p ~/.Xilinx
	docker build \
	-t xilinx:${VIVADO_VER} \
	--build-arg petalinux_install_file=${PETALINUX} \
	--build-arg vivado_install_file=${VIVADO} \
	--build-arg vivado_install_config=${VIVADO_CONFIG} \
	docker

interactive: ## Interactive mode inside docker image
	docker run --rm --env="DISPLAY" --net=host \
	--privileged \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${PWD}/sw:/home/xil/sw:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-it xilinx:${VIVADO_VER} bash -l

interactive-root: ## Interactive mode inside docker image
	docker run --rm --env="DISPLAY" --net=host \
	--privileged --user root \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${PWD}/sw:/home/xil/sw:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-it xilinx:${VIVADO_VER} bash -l

project: ## Create Vivado Project
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/hdl; vivado -mode batch -source scripts/create_project.tcl"

hdl: ## Vivado Batch Build
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	--privileged \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/hdl; vivado -mode batch -source scripts/build.tcl"

gui: ## Vivado GUI
	docker run --rm --env="DISPLAY" --net=host \
	 --ipc host --privileged \
	--user "$$(id -u):$$(id -g)" \
	-v /dev:/dev \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/hdl; vivado vivado/moller.xpr;"

petalinux: petalinux-update petalinux-rootfs petalinux-boot

petalinux-rootfs: ## Build petalinux rootfs
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${PWD}/sw:/home/xil/sw:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/sw/linux; petalinux-build"

petalinux-update: ## Update hardware descriptor
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${PWD}/sw:/home/xil/sw:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/sw/linux; \
	petalinux-config --get-hw-description=../../hdl/export --silentconfig"

petalinux-config: ## Change Petalinux configuration
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${PWD}/sw:/home/xil/sw:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" -it xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/sw/linux; \
	petalinux-config --get-hw-description=../../hdl/export"

petalinux-config-kernel: ## Change Petalinux Kernel configuration
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${PWD}/sw:/home/xil/sw:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" -it xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/sw/linux; \
	petalinux-config -c kernel; petalinux-build -c kernel -x finish"

petalinux-config-rootfs: ## Change Petalinux RootFS configuration
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${PWD}/sw:/home/xil/sw:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" -it xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/sw/linux; \
	petalinux-config -c rootfs"

petalinux-clean: ## Clean petalinux
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${PWD}/sw:/home/xil/sw:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/sw/linux; petalinux-build -f -x mrproper"

petalinux-boot: ## Make Petalinux boot package
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${PWD}/sw:/home/xil/sw:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/sw/linux; petalinux-package --boot --format BIN \
	--fsbl images/linux/zynqmp_fsbl.elf \
	--u-boot images/linux/u-boot.elf \
	--pmufw images/linux/pmufw.elf \
	--fpga ../../hdl/output/system.bit \
	--bif-attribute init --bif-attribute-value project-spec/configs/regs.init --force"

petalinux-qemu: ## Run Petalinux in QEMU
	docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	--privileged \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${PWD}/sw:/home/xil/sw:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" -it xilinx:${VIVADO_VER} \
	bash -l -c 'cd /home/xil/sw/linux; petalinux-boot --qemu --kernel'

petalinux-jtag: ## Load Petalinux via JTAG
	@docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	--privileged \
	-p 69:69/udp \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${PWD}/sw:/home/xil/sw:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" -it xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/sw/linux; petalinux-boot --jtag --kernel --fpga --bitstream ../../hdl/output/system.bit"

petalinux-app: ## Build petalinux app only
	@docker run --rm --net=host --env="DISPLAY" \
	--user "$$(id -u):$$(id -g)" \
	--privileged \
	-p 69:69/udp \
	-v ${PWD}/hdl:/home/xil/hdl:rw \
	-v ${PWD}/sw:/home/xil/sw:rw \
	-v ${LICENSE_DIR}:/home/xil/.Xilinx:rw \
	-v ${PWD}/sw/linux/tftpboot:/tftpboot:rw \
	-v "$$HOME/.Xauthority:/home/xil/.Xauthority:rw" -it xilinx:${VIVADO_VER} \
	bash -l -c "cd /home/xil/sw/linux; petalinux-build -c moller"

sdcard-copy: ## Copy Petalinux to sdcard
	cp sw/linux/images/linux/BOOT.BIN sw/linux/images/linux/boot.scr sw/linux/images/linux/Image sw/linux/images/linux/rootfs.cpio.gz.u-boot /media/${USER}/${SDCARD_BOOT_LABEL}
	sync
	sudo umount /media/${USER}/${SDCARD_BOOT_LABEL}
	sudo umount /media/${USER}/${SDCARD_ROOTFS_LABEL}

create-zip: ## Make a zip of the required files
	cd sw/linux/images/linux/; \
	cp ../../../scripts/moller_dump.py .; \
	cp ../../../scripts/moller_ctrl.py .; \
	cp ../../../scripts/moller_viewer.py .; \
	zip ../../../../moller_$(shell date +%Y%m%d).zip BOOT.BIN boot.scr Image rootfs.cpio.gz.u-boot moller_dump.py moller_ctrl.py moller_viewer.py; rm moller_*.py

unzip-to-sdcard:
	unzip -p ${SDCARD_ZIP} BOOT.BIN >/media/${USER}/${SDCARD_BOOT_LABEL}/BOOT.BIN
	unzip -p ${SDCARD_ZIP} boot.scr >/media/${USER}/${SDCARD_BOOT_LABEL}/boot.scr
	unzip -p ${SDCARD_ZIP} Image >/media/${USER}/${SDCARD_BOOT_LABEL}/Image
	unzip -p ${SDCARD_ZIP} rootfs.cpio.gz.u-boot >/media/${USER}/${SDCARD_BOOT_LABEL}/rootfs.cpio.gz.u-boot
	sudo sync

sdcard-format: ## Format SDCard image for petalinux
	sudo parted ${SDCARD_DEV} --script -- mklabel msdos
	sudo parted ${SDCARD_DEV} --script -- mkpart primary fat32 1MiB 257MiB
	sudo parted ${SDCARD_DEV} --script -- mkpart primary ext4 257MiB 100%
	sudo partprobe ${SDCARD_DEV}
	sudo sync
	sudo mkfs.vfat -F32 ${SDCARD_DEV}1
	sudo fatlabel ${SDCARD_DEV}1 ${SDCARD_BOOT_LABEL}
	sudo mkfs.ext4 -L ${SDCARD_ROOTFS_LABEL} ${SDCARD_DEV}2
	sudo sync

# ssh-update-sdcard: ## Copy files via SSH/SCP and reboot device
# 	@scp ${SSH_OPTIONS} sw/linux/images/linux/BOOT.BIN sw/linux/images/linux/boot.scr sw/linux/images/linux/Image sw/linux/images/linux/rootfs.cpio.gz.u-boot root@${DEVICE_IP}:/media/sd-mmcblk1p1/
# 	@ssh ${SSH_OPTIONS} -t root@${DEVICE_IP} 'sync;'

ssh-update-sdcard: ## Copy files via SSH/SCP and reboot device
	@scp ${SSH_OPTIONS} sw/linux/images/linux/rootfs.cpio.gz.u-boot root@${DEVICE_IP}:/media/sd-mmcblk1p1/
	@ssh ${SSH_OPTIONS} -t root@${DEVICE_IP} 'sync;'


ssh-update-emmc:
	@scp ${SSH_OPTIONS} sw/linux/images/linux/BOOT.BIN sw/linux/images/linux/boot.scr sw/linux/images/linux/Image sw/linux/images/linux/rootfs.cpio.gz.u-boot root@${DEVICE_IP}:/media/sd-mmcblk0p1/
	@ssh ${SSH_OPTIONS} -t root@${DEVICE_IP} 'sync'

ssh-update-rootfs:
	@scp ${SSH_OPTIONS}  sw/linux/images/linux/rootfs.cpio.gz.u-boot root@${DEVICE_IP}:/media/sd-mmcblk1p1/
	@ssh ${SSH_OPTIONS} -t root@${DEVICE_IP} 'sync'


ssh-reboot:
	@ssh ${SSH_OPTIONS} -t root@${DEVICE_IP} '/sbin/shutdown -r now'

terminal: ## Open terminal to device
	@echo "Press CTRL+A,CTRL+X to quit"
	@sleep 0.5
	@picocom -q -b 115200 $(USB_UART)

#	sudo rm -rf /media/${USER}/${SDCARD_ROOTFS_LABEL}/*
#	sudo tar -xvf sw/linux/images/linux/rootfs.tar.gz -C /media/${USER}/${SDCARD_ROOTFS_LABEL}


# unzip -p ${SDCARD_ZIP} rootfs.tar.gz | sudo tar -C /media/${USER}/${SDCARD_ROOTFS_LABEL} -zxvf -


# @scp ${SSH_OPTIONS} sw/linux/images/linux/rootfs.tar.gz root@${DEVICE_IP}:/
# @ssh ${SSH_OPTIONS} -t root@${DEVICE_IP} 'rm -rf /media/sd-mmcblk0p2/*; tar -xvf /rootfs.tar.gz -C /media/sd-mmcblk0p2; rm /rootfs.tar.gz; sync'

# 	@scp ${SSH_OPTIONS} sw/linux/images/linux/BOOT.BIN root@${DEVICE_IP}:/media/sd-mmcblk1p1/
# 	@scp ${SSH_OPTIONS} sw/linux/images/linux/Image sw/linux/images/linux/rootfs.cpio.gz.u-boot root@${DEVICE_IP}:/media/sd-mmcblk1p1/boot
# 	@scp ${SSH_OPTIONS} sw/linux/project-spec/configs/extlinux.conf root@${DEVICE_IP}:/media/sd-mmcblk1p1/boot/extlinux/

#	@ssh ${SSH_OPTIONS} -t root@${DEVICE_IP} '/etc/init.d/moller-service stop'
#	@mkdir -p linux_image
#	@tar -xvf sw/linux/images/linux/rootfs.tar.gz -C linux_image/
#	@scp ${SSH_OPTIONS} linux_image/usr/bin/moller root@${DEVICE_IP}:/media/sd-mmcblk1p2/usr/bin/moller
#	@scp ${SSH_OPTIONS} linux_image/etc/init.d/moller-service root@${DEVICE_IP}:/media/sd-mmcblk1p2/etc/init.d/moller-service
#	@rm -rf linux_image
