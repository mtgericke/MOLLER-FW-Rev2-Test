FROM ubuntu:18.04

ARG petalinux_install_file
ARG vivado_install_file
ARG vivado_install_config

# Install packages required for Xilinx
RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get -y install apt-utils dialog locales && apt-get -y install tzdata
RUN locale-gen en_US.UTF-8
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
  iproute2 \
  gcc \
  g++ \
  net-tools \
  ncurses-dev \
  libncurses5 \
  zlib1g:i386 \
  libssl-dev \
  libcanberra-gtk-module \
  libcanberra-gtk3-module \
  libcanberra-gtk-module:i386 \
  mesa-utils \
  libgl1-mesa-glx \
  flex \
  bison \
  libselinux1 \
  lib32z1 \
  xterm \
  autoconf \
  libtool \
  libnss3 \
  texinfo \
  zlib1g-dev \
  gcc-multilib \
  build-essential \
  screen \
  pax \
  udev \
  gawk \
  sudo \
  xvfb \
  xxd \
  bc \
  python3 \
  python3-pexpect \
  python3-pip \
  python3-git \
  python3-jinja2 \
  xz-utils \
  debianutils \
  iputils-ping \
  libegl1-mesa \
  libsdl1.2-dev \
  pylint3 \
  cpio \
  lib32stdc++6 \
  libgtk2.0-0:i386 \
  libfontconfig1:i386 \
  libx11-6:i386 \
  libxext6:i386 \
  libxrender1:i386 \
  libsm6:i386 \
  libqtgui4:i386 \
  libncurses5-dev \
  make \
  tftpd-hpa \
  tftp-hpa \
  gnupg \
  tofrodos \
  wget \
  xinetd \
  diffstat \
  chrpath \
  socat \
  xterm \
  autoconf \
  libtool \
  tar \
  unzip \
  texinfo \
  libbz2-1.0 \
  zlib1g-dev \
  gcc-multilib \
  build-essential \
  zlib1g:i386 \
  screen \
  dialog \
  rsync \
  pax \
  gzip

RUN ln -s /home/xil/sw/linux/tftpboot /tftpboot

RUN printf "\
TFTP_USERNAME=\"xil\"\n\
TFTP_DIRECTORY=\"/tftpboot\"\n\
TFTP_ADDRESS=\":69\"\n\
TFTP_OPTIONS=\"--secure --create\"\n" > /etc/default/tftpd-hpa

# Expose the TFTPD server port
# EXPOSE 69/udp

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# Add xil user and give a default pass
RUN useradd -m xil -s /bin/bash -U -G sudo
RUN echo "xil:xil" | chpasswd

# So we can sudo in our scripts without a password, normally this is a terrible idea...
RUN echo "xil ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Fix rtlwrap terminfo warning
RUN rm -rf /usr/share/terminfo
RUN ln -s /lib/terminfo /usr/share/terminfo

# Set up a non-root user
USER xil
WORKDIR /home/xil

# RUN echo "sudo /etc/init.d/tftpd-hpa start" >> /home/xil/.profile
RUN echo "export TERM=xterm" >> /home/xil/.profile
RUN echo '. "$HOME/tools/xilinx/Vivado/2020.2/settings64.sh"' >> /home/xil/.profile
RUN echo '. "$HOME/tools/petalinux/settings.sh"' >> /home/xil/.profile
RUN touch ~/.sudo_as_admin_successful

RUN mkdir /home/xil/tools

# Install petalinux
COPY --chown=xil:xil $petalinux_install_file /home/xil/
RUN chmod +x /home/xil/$petalinux_install_file
RUN SKIP_LICENSE=y /home/xil/$petalinux_install_file -d /home/xil/tools/petalinux --platform "arm aarch64" --log /home/xil/petalinux_install.log

# Install vivado
COPY --chown=xil:xil $vivado_install_config /home/xil/install_config.txt
ADD --chown=xil:xil $vivado_install_file /home/xil/vivado
RUN /home/xil/vivado/$(echo "$vivado_install_file" | sed -e "s/.tar.gz//")/xsetup --batch Install --location /home/xil/tools/xilinx/ --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA --config /home/xil/install_config.txt

USER root

# Install Xilinx USB cable drivers
RUN cd /home/xil/tools/xilinx/Vivado/2020.2/data/xicom/cable_drivers/lin64/install_script/install_drivers; ./install_drivers

# Cleanup install
RUN rm /home/xil/$petalinux_install_file
RUN rm -rf /home/xil/vivado

USER xil
RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your Name"

SHELL ["/bin/bash", "-c"]
