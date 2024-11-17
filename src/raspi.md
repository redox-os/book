# Raspberry Pi

## Build and run device-specific images

Most ARM motherboards do not use the default image for booting, which requires us to do some extra steps with building images.

## Raspberry Pi 3 Model B+

It is easy to port Raspberry Pi 3 Model B+ (raspi3b+) since the bootloader of Raspberry Pi family uses the similar filesystem (FAT32) for booting.


In order to build a RasPi3B+ image:

- Add `BOARD?=raspi3bp` and `CONFIG_NAME?=minimal`to `.config`
- Run `make all`
- Download the firmware

```sh
cd ~/tryredox
```

```sh
git clone https://gitlab.redox-os.org/Ivan/redox_firmware.git
```

### Run in QEMU

Assume that we are using the `server-minimal` configuration and built the image successfully, run:

- Add two additional dtb files to EFI system partition:

```
DISK=build/aarch64/server-minimal/harddrive.img
MOUNT_DIR=/mnt/efi_boot
DTB_DIR=$MOUNT_DIR/dtb/broadcom
WORKPLACE=/home/redox/tryredox
DTS=$WORKPLACE/redox_firmware/platform/raspberry_pi/rpi3/bcm2837-rpi-3-b-plus.dts
```

```sh
mkdir -p $MOUNT_DIR
```

```sh
mount -o loop,offset=$((2048*512)) $DISK $MOUNT_DIR
```

```sh
mkdir -p $DTB_DIR
```

```sh
dtc -I dts -O dtb $DTS > $DTB_DIR/bcm2837-rpi-3-b.dtb
```

```sh
cp $DTB_DIR/bcm2837-rpi-3-b.dtb $DTB_DIR/bcm2837-rpi-3-b-plus.dtb
```

```sh
sync
```

```sh
umount $MOUNT_DIR
```

- Run `make qemu_raspi live=no`

### Booting from USB

Assume that we are using the `server-minimal` configuration and access serial console using GPIOs 14 and 15 (pins 8 and 10 on the 40-pin header). Do the following:

- Run `make live`
- Download the firmware from [official repository](https://github.com/raspberrypi/firmware/tree/master/boot)

```sh
cd ~/tryredox
```

```sh
git clone --depth=1 https://github.com/raspberrypi/firmware.git
```

- Copy all required firmware to EFI system partition

```
DISK=build/aarch64/server-minimal/livedisk.iso
MOUNT_DIR=/mnt/efi_boot
DTB_DIR=$MOUNT_DIR/dtb/broadcom
WORKPLACE=/home/redox/tryredox
DTS=$WORKPLACE/redox_firmware/platform/raspberry_pi/rpi3/bcm2837-rpi-3-b-plus.dts
UBOOT=$WORKPLACE/redox_firmware/platform/raspberry_pi/rpi3/u-boot-rpi-3-b-plus.bin
CONFIG_TXT=$WORKPLACE/redox_firmware/platform/raspberry_pi/rpi3/config.txt
FW_DIR=$WORKPLACE/firmware/boot
```

```sh
mkdir -p $MOUNT_DIR
```

```sh
mount -o loop,offset=$((2048*512)) $DISK $MOUNT_DIR
```

```sh
cp -rf $FW_DIR/* $MOUNT_DIR
```

```sh
mkdir -p $DTB_DIR
```

```sh
dtc -I dts -O dtb $DTS > $DTB_DIR/bcm2837-rpi-3-b.dtb
```

```sh
cp $DTB_DIR/bcm2837-rpi-3-b.dtb $DTB_DIR/bcm2837-rpi-3-b-plus.dtb
```

```sh
cp $UBOOT $MOUNT_DIR/u-boot.bin
```

```sh
cp $CONFIG_TXT $MOUNT_DIR
```

```sh
sync
```

```sh
umount $MOUNT_DIR
```

- Run:

```sh
dd if=build/aarch64/server-minimal/livedisk.iso of=/dev/sdX
```

(`/dev/sdX` is your USB device.)

### Booting from SD Card

This process is similar to that of "Booting from USB", but has some differences:

- Use `harddrive.img` instead of `livedisk.iso`
- After `dd` command, try to make the EFI system partition of the SD card become a hybrid MBR. See [this post](https://www.eisfunke.com/posts/2023/uefi-boot-on-raspberry-pi-3.html) for more details

```
root@dev-pc:/home/ivan/code/os/redox# gdisk /dev/sdc
GPT fdisk (gdisk) version 1.0.8

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.

Command (? for help): r

Recovery/transformation command (? for help): p
Disk /dev/sdc: 61067264 sectors, 29.1 GiB
Model: MassStorageClass
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): B37FD04D-B67D-48AA-900B-884F0E3B2EAD
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 524254
Partitions will be aligned on 2-sector boundaries
Total free space is 2015 sectors (1007.5 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1              34            2047   1007.0 KiB  EF02  BIOS
   2            2048          264191   128.0 MiB   EF00  EFI
   3          264192          522239   126.0 MiB   8300  REDOX

Recovery/transformation command (? for help): h

WARNING! Hybrid MBRs are flaky and dangerous! If you decide not to use one,
just hit the Enter key at the below prompt and your MBR partition table will
be untouched.

Type from one to three GPT partition numbers, separated by spaces, to be
added to the hybrid MBR, in sequence: 2
Place EFI GPT (0xEE) partition first in MBR (good for GRUB)? (Y/N): n

Creating entry for GPT partition #2 (MBR partition #1)
Enter an MBR hex code (default EF): 0c
Set the bootable flag? (Y/N): n

Unused partition space(s) found. Use one to protect more partitions? (Y/N): n

Recovery/transformation command (? for help): o

Disk size is 61067264 sectors (29.1 GiB)
MBR disk identifier: 0x00000000
MBR partitions:

Number  Boot  Start Sector   End Sector   Status      Code
   1                  2048       264191   primary     0x0C
   2                     1         2047   primary     0xEE

Recovery/transformation command (? for help): w
Warning! Secondary header is placed too early on the disk! Do you want to
correct this problem? (Y/N): y
Have moved second header and partition table to correct location.

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): y
OK; writing new GUID partition table (GPT) to /dev/sdc.
The operation has completed successfully.
root@dev-pc:/home/ivan/code/os/redox#
```
