#
# This file is the user-setup recipe.
#

SUMMARY = "User files"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://root/authorized_keys \
		  "

S = "${WORKDIR}"

root_homedir = "/home/root"

FILES_${PN} += "${root_homedir}/.ssh/authorized_keys"

do_install() {
	install -d ${D}${root_homedir}/.ssh
	install -m 0400 ${S}/root/authorized_keys ${D}${root_homedir}/.ssh/authorized_keys
}
