# Running Redox on real hardware

Since version 0.8.0, Redox can now be installed on a partition on certain hard drives and internal SSDs, including some vintage systems. USB drives are not yet supported during runtime, although they can be used for installation and *livedisk* boot. Check the release notes for additional details on supported hardware. Systems with unsupported drives can still use the *livedisk* method described below. Ensure you backup your data before trying Redox on your hardware.

Hardware support is limited at the moment, so your milage may vary. USB HID drivers are a work in progress but are not currently included, so a USB keyboard or mouse will not work. There is a PS/2 driver, which works with the keyboards and touchpads in many (but not all) laptops. For networking, the rtl8168d and e1000d ethernet controllers are currently supported.

On some computers, hardware incompatibilities, e.g. disk driver issues, can slow Redox performance. This is not reflective of Redox in general, so if you find that Redox is slow on your computer, please try it on a different model for a better experience.

The current ISO image uses a bootloader to load the filesystem into memory (*livedisk*) and emulates a hard drive. You can use the system in this mode without installing. Although its use of memory is inefficient, it is fully functional and does not require changes to your drive. The ISO image is a great way to try out Redox on real hardware. 

### Creating a bootable USB drive or CD

You can obtain a *livedisk* ISO image either by downloading the [latest build](https://static.redox-os.org/img/), or by [building one](./ch02-05-building-redox.md). The demo ISO is recommended for most laptops. After downloading completes, check the SHA sum:
```sh
sha256sum $HOME/Downloads/redox_demo_x86_64*_livedisk.iso
```

Copy the ISO image to a USB drive using the "clone" method with your preferred USB writer. You can also use the ISO image on a CD/DVD (ensure the ISO will fit on your disk).

### Booting the system

Once the ISO image boots, the system will display the **Orbital** GUI. Log in as user `user` with no password. The password for `root` is `password`.

See [Trying Out Redox](./ch02-04-trying-out-redox.md) for things to try.

To switch between **Orbital** and the console, use the following keys:
- F1: Display the console log messages
- F2: Open a text-only terminal
- F3: Return to the **Orbital** GUI

If you want to be able to boot Redox from your HDD or SSD, follow the [Installation](./ch02-03-installing.md) instructions.

Redox isn't currently going to replace your existing OS, but it's a fun thing to try; boot Redox on your computer, and see what works.
