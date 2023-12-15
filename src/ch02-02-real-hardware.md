# Running Redox on real hardware

- [Creating a bootable USB drive](#creating-a-bootable-usb-drive)
    - [Linux Instructions](#linux-instructions)
    - [Windows Instructions](#windows-instructions)
- [Booting the system](#booting-the-system)

Since version 0.8.0, Redox can now be installed on a partition on certain hard drives and internal SSDs, including some vintage systems. USB drives are not yet supported during runtime, although they can be used for installation and *livedisk* boot. Check the release notes for additional details on supported hardware. Systems with unsupported drives can still use the *livedisk* method described below. Ensure you backup your data before trying Redox on your hardware.

Hardware support is limited at the moment, so your milage may vary. USB HID drivers are a work in progress but are not currently included, so a USB keyboard or mouse will not work. There is a PS/2 driver, which works with the keyboards and touchpads in many (but not all) laptops. For networking, the rtl8168d and e1000d ethernet controllers are currently supported.

On some computers, hardware incompatibilities, e.g. disk driver issues, can slow Redox performance. This is not reflective of Redox in general, so if you find that Redox is slow on your computer, please try it on a different model for a better experience.

The current ISO image uses a bootloader to load the filesystem into memory (*livedisk*) and emulates a hard drive. You can use the system in this mode without installing. Although its use of memory is inefficient, it is fully functional and does not require changes to your drive. The ISO image is a great way to try out Redox on real hardware. 

## Creating a bootable USB drive

You can obtain a *livedisk* ISO image either by downloading the [latest release](https://static.redox-os.org/releases/0.8.0/x86_64/), or by [building one](./ch02-05-building-redox.md). The [demo ISO](https://static.redox-os.org/releases/0.8.0/x86_64/redox_demo_x86_64_2022-11-23_638_livedisk.iso) is recommended for most laptops. After downloading completes, check the [SHA256 sum](https://static.redox-os.org/releases/0.8.0/x86_64/SHA256SUM):

```sh
sha256sum $HOME/Downloads/redox_demo_x86_64*_livedisk.iso
```

### Linux Instructions

We recommend that you use the [Popsicle](https://github.com/pop-os/popsicle) tool on Linux to flash your USB device, follow the steps below:

- Click on [this](https://github.com/pop-os/popsicle/releases) link to open the Popsicle releases page and download the `.AppImage` file of the most recent version.
- Open your file manager, click with the right-button of your mouse on the `.AppImage` file and open the "Properties", find the "Permissions" section and mark it as executable.
- Open the Popsicle AppImage file, select the downloaded Redox image and your USB device.
- Confirm the flash process and wait until the progress bar reach 100%
- If the flash process had no errors it will give a success warning.
- Now you can restart your Linux distribution and boot Redox.
- Some computers don't come with USB booting enabled, to enable it press the keyboard key to open your UEFI or BIOS setup and allow the booting from USB devices (the name varies from firmware to firmware).
- If you don't know the keyboard keys to open your UEFI/BIOS setup or boot menu, press the Esc or F keys (from 1 until 12), if you press the wrong key or got the wrong timing, don't stop your operating system boot process to try again, as it could corrupt your data.

### Windows Instructions

We recommend that you use the [Rufus](https://rufus.ie/) tool on Windows to flash your USB device, follow the steps below:

- Click on [this](https://rufus.ie/) link to open the Rufus website, move the page until the "Download" section and download the latest version.
- Open Rufus, select the ISO image of Redox, wait the Rufus image scanning, select your USB device and click on "Start".
- Confirm the permission to erase the data of your device and wait until the progress bar reach 100%
- If it show a choice window with "ISO" and "DD" mode, select one of them, if some mode don't boot, select the other mode.
- If the flash process had no errors it will give a success warning.
- Now you can restart your Windows and boot Redox.
- Some computers don't come with USB booting enabled, to enable it press the keyboard key to open your UEFI or BIOS setup and allow the booting from USB devices (the name varies from firmware to firmware).
- If you don't know the keyboard keys to open your UEFI/BIOS setup or boot menu, press the Esc or F keys (from 1 until 12), if you press the wrong key or got the wrong timing, don't stop your operating system boot process to try again, as it could corrupt your data.

## Booting the system

Once the ISO image boots, the system will display the **Orbital** GUI. Log in as user `user` with no password. The password for `root` is `password`.

See [Trying Out Redox](./ch02-04-trying-out-redox.md) for things to try.

To switch between **Orbital** and the console, use the following keys:
- F1: Display the console log messages
- F2: Open a text-only terminal
- F3: Return to the **Orbital** GUI

If you want to be able to boot Redox from your HDD or SSD, follow the [Installation](./ch02-03-installing.md) instructions.

Redox isn't currently going to replace your existing OS, but it's a fun thing to try; boot Redox on your computer, and see what works.
