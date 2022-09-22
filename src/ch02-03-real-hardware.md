Running Redox on real hardware
==============================

Currently, Redox only natively supports booting from a hard disk with no partition table. Therefore, the current ISO image uses a bootloader to load the filesystem into memory and emulates one. This is inefficent and requires a somewhat large amount of memory, which will be fixed once proper support for various things (such as a USB mass storage driver) are implemented.

Despite the awkward way it works, the ISO image is the recomended way to try out Redox on real hardware (in an emulator, a virtual hard drive is better). You can obtain an ISO image either by downloading the [latest release](https://gitlab.redox-os.org/redox-os/redox/tags), or by building one with `make iso` from the [Redox source tree](https://gitlab.redox-os.org/redox-os/redox).

You can create a bootable CD or USB drive from the ISO as with other bootable disk images.

Hardware support is limited at the moment, so your milage may vary. There is no USB HID driver, so a USB keyboard or mouse will not work. There is a PS/2 driver, which works with the keyboards and touchpads in many laptops. For networking, the rtl8168d and e1000d ethernet controllers are currently supported.

Redox isn't currently going to replace your existing OS, but it's a fun thing to try; boot Redox on your computer, and see what works.
