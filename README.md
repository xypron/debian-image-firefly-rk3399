Build Debian SD card image for the Firefly-RK3399
=================================================

This project provides files to generate a Debian SD card image
for the Firefly-RK3399 on an arm64 system.

The following command installs the dependencies:

    sudo apt-get install debootstrap dosfstools fakeroot xz-utils

To create the SD card image execute

    make

A new image is created with four partions:

- EFI partition
- boot partition
- root partition
- empty partition protecting u-boot

Debootstrap is used to install a base system.

A sudo user *firefly* with password *firefly* is provided.

The created image file is called *image*.

To copy the image to an SD card use

    sudo if=image of=/dev/sdX bs=16M

Replace /dev/sdX by the actual device.
**Beware of overwriting your harddisk by specifying the wrong device.**
