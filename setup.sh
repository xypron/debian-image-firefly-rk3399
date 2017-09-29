#!/bin/sh
apt-get update
apt-get install less locales ssh sudo vim -y
apt-get install u-boot-rockchip flash-kernel -y
cd /tmp
wget http://ftp.us.debian.org/debian/pool/main/l/linux/linux-image-4.13.0-trunk-arm64_4.13.2-1~exp1_arm64.deb
dpkg -i linux-image-4.13.0-trunk-arm64_4.13.2-1~exp1_arm64.deb
adduser firefly --uid 9997 --disabled-password --gecos 'Default User,,,'
echo firefly:firefly | chpasswd
adduser firefly sudo
