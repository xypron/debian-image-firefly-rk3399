#!/bin/sh
apt-get update
apt-get install less locales ssh sudo vim ca-certificates -y
apt-get install u-boot-rockchip flash-kernel -y
apt-get install linux-image-arm64 -y
adduser firefly --uid 9997 --disabled-password --gecos 'Default User,,,'
echo firefly:firefly | chpasswd
adduser firefly sudo
