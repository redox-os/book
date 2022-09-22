Running Redox on real hardware
==============================

As of the latest release (0.8.0), Redox can now be installed on a partition on certain hard drives and internal SSDs, including some vintage systems. USB drives are not yet supported during runtime, although they can be used for installation and *livedisk* boot. Check the release notes for additional details on supported hardware. Systems with unsupported drives can still use the *livedisk* method described below. Ensure you backup your data before trying Redox on your hardware.

Hardware support is limited at the moment, so your milage may vary. USB HID drivers are a work in progress but are not currently included, so a USB keyboard or mouse will not work. There is a PS/2 driver, which works with the keyboards and touchpads in many laptops. For networking, the rtl8168d and e1000d ethernet controllers are currently supported.

The current ISO image uses a bootloader to load the filesystem into memory (*livedisk*) and emulates one. You can use the system in this mode without installing. Although its use of memory is inefficient, it is fully functional and does not require changes to your drive. Despite the awkward way it works, the ISO image is a great way to try out Redox on real hardware (in an emulator, a virtual hard drive is better). You can obtain an ISO image either by downloading the [latest release](https://gitlab.redox-os.org/redox-os/redox/tags), or by building one with `make live` from the [Redox source tree](https://gitlab.redox-os.org/redox-os/redox). Copy the ISO image to USB using the "clone" method with your preferred USB writer. You can also use the ISO image on a CD.

Once the ISO image boots, log in as user `user` with no password. The password for `root` is `password`. Feel free to try out the system. You can get a list of commands by typing `ls /bin` in a Terminal window.

You can install Redox to a partition by opening a Terminal window and typing `sudo redox_install_tui`. If Redox recognizes your drive, it will prompt you to select a partition to install on. Choose carefully, as it will erase all the data on that partition. Note that if your drive is not recognized, it may offer you the option to install on `disk/live` (the in-memory *livedisk*). Don't do this, as it will crash Redox. Enter the number of the partition. You will be prompted for a `redoxfs password`. This is for a secure filesystem. Leave the password empty and press enter if a secure filesystem is not required. Once the installation completes, power the system off, remove the USB and you are ready to start using Redox!

Redox isn't currently going to replace your existing OS, but it's a fun thing to try; boot Redox on your computer, and see what works.
