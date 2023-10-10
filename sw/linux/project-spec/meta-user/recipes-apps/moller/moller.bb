#
# This file is the moller recipe.
#

SUMMARY = "Moller application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
	file://src/moller.c \
	file://src/moller.h \
	file://src/task_cmd.c \
	file://src/task_discovery.c \
	file://src/task_dma.c \
	file://src/task_sensor.c \
	file://src/task_tinode.c \
	file://src/external/moller_regs.h \
	file://src/external/tinode_regs.h \
	file://src/external/dma-proxy.h \
	file://src/lib/discovery/discovery.c \
	file://src/lib/discovery/discovery.h \
	file://src/lib/discovery/discovery_udp_linux.c \
	file://src/lib/discovery/discovery_udp_linux.h \
    file://CMakeLists.txt"

DEPENDS += "zeromq lz4 libgpiod"

S = "${WORKDIR}"

inherit cmake

do_install() {
	install -d ${D}${bindir}
	install -m 0755 moller ${D}${bindir}
}

FILES_${PN} += "${sysconfdir}/*"
