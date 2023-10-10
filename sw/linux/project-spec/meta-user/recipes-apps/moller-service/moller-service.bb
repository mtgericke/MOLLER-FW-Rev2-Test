#
# This file is the moller-service recipe.
#

SUMMARY = "moller-service startup script"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://moller-service"

S = "${WORKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "moller-service"
INITSCRIPT_PARAMS = "start 99 S ."

do_install() {
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${S}/moller-service ${D}${sysconfdir}/init.d/moller-service
}
