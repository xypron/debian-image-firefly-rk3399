all:
	make unmount
	make prepare
	make mount
	make debootstrap
	make mount2
	make copy
	make flash
	make unmount
	make compress

prepare:
	sudo rm -f image image.*
	sudo dd if=/dev/zero of=image bs=1024 seek=3145727 count=1
	sudo sfdisk image < partioning
	sudo losetup -o  16777216 --sizelimit 117440512 /dev/loop1 image
	sudo losetup -o 134217728 --sizelimit 402653184 /dev/loop2 image
	sudo losetup -o 536870912 /dev/loop3 image
	sudo mkfs.vfat -n EFI  -i 214f0ace /dev/loop1
	sudo mkfs.ext2 -L boot -U 09e086a3-c41f-48d4-af58-e63b56979d8f /dev/loop2
	sudo mkfs.ext4 -L root -U c6716f99-a409-4bf0-80e0-4a789a6c49b6 /dev/loop3
	sudo losetup -d /dev/loop3 || true
	sudo losetup -d /dev/loop2 || true
	sudo losetup -d /dev/loop1 || true

mount:
	sudo losetup -o  16777216 --sizelimit 117440512 /dev/loop1 image
	sudo losetup -o 134217728 --sizelimit 402653184 /dev/loop2 image
	sudo losetup -o 536870912 /dev/loop3 image
	sudo mkdir -p mnt
	sudo mount /dev/loop3 mnt

debootstrap:
	sudo debootstrap --arch arm64 buster mnt http://ftp.de.debian.org/debian/

mount2:
	sudo mkdir -p mnt/EFI
	sudo mount /dev/loop1 mnt/EFI || true
	sudo mkdir -p mnt/boot
	sudo mount /dev/loop2 mnt/boot || true

copy:
	sudo cp modules mnt/etc/modules
	sudo cp eth0 mnt/etc/network/interfaces.d/
	sudo cp fstab mnt/etc/
	sudo cp flash-kernel mnt/etc/default/
	sudo mkdir -p mnt/etc/flash-kernel/ubootenv.d/
	sudo cp fdtfile mnt/etc/flash-kernel/ubootenv.d/
	sudo mkdir -p mnt/proc/device-tree/
	sudo cp model mnt/proc/device-tree/
	sudo cp setup.sh mnt
	sudo chroot mnt ./setup.sh
	sudo rm mnt/setup.sh

flash:
	mkimage -n rk3399 -T rksd -d \
	  mnt/usr/lib/u-boot/firefly-rk3399/u-boot-spl.bin out
	sudo dd if=out of=image seek=64 conv=notrunc
	rm out
	sudo dd if=mnt/usr/lib/u-boot/firefly-rk3399/u-boot.img \
	  of=image seek=512 conv=notrunc

unmount:
	sync
	sudo umount mnt/sys || true
	sudo umount mnt/proc || true
	sudo umount mnt/boot || true
	sudo umount mnt/EFI || true
	sudo umount mnt || true
	sudo losetup -d /dev/loop3 || true
	sudo losetup -d /dev/loop2 || true
	sudo losetup -d /dev/loop1 || true

compress:
	sha512sum image > image.sha512
	fakeroot xz -9 -k image
