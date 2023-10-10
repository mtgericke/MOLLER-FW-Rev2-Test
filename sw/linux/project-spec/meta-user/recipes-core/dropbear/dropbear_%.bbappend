#
# This file appends the dropbox core recipe.
#

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
  file://dropbear.custom \
  file://dropbear_rsa_host_key \
  "
# Add the following to SRC_URI to hard-code the host key
#   file://dropbear_rsa_host_key

FILES_${PN} += "${sysconfdir}/dropbear/dropbear_rsa_host_key"

do_install_append() {
  install -m 0644 ${WORKDIR}/dropbear.custom ${D}${sysconfdir}/default/dropbear
  install -m 0400 ${WORKDIR}/dropbear_rsa_host_key ${D}${sysconfdir}/dropbear/dropbear_rsa_host_key
}