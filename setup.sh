#!/bin/sh
apt-get update
apt-get install less locales ssh sudo vim -y
apt-get install u-boot-rockchip flash-kernel -y
adduser firefly --uid 9997 --disabled-password --gecos 'Default User,,,'
echo firefly:firefly | chpasswd
adduser firefly sudo
