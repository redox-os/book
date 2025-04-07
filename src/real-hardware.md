# Running Redox on Real Hardware

(You need to use the `*livedisk.iso` image variant for real hardware)

Since version 0.8.0, Redox can now be installed on certain hard drives and internal SSDs, including some vintage systems. USB devices are not yet supported during run-time, although they can be used for installation and *livedisk* boot. Check the release notes for additional details on supported hardware. Systems with unsupported devices can still use the *livedisk* method described below. Ensure you backup your data before trying Redox on your hardware.

Hardware support is limited at the moment, so your milage may vary. Only USB input devices (HID) work. There is a PS/2 driver, which works with the keyboards and touchpads in many (but not all) laptops. For networking, the Realtek and Intel ethernet controllers are currently supported.

On some computers, hardware incompatibilities, e.g. disk driver issues, can slow down Redox performance. This is not reflective of Redox in general, so if you find that Redox is slow on your computer, please try it on a different model for a better experience.

The current ISO image uses a bootloader to load the filesystem into memory (*livedisk*) and emulates a hard drive. You can use the system in this mode without installing. Although its use of memory is inefficient, it is fully functional and does not require changes to your device. The ISO image is a great way to try out Redox on real hardware. 

## Creating a Bootable USB Device

### Download an Compressed ISO Image

You can obtain a *livedisk* ISO image either by downloading the [latest release](https://static.redox-os.org/releases/0.9.0/x86_64/), or by [building one](./building-redox.md). The [demo ISO](https://static.redox-os.org/releases/0.9.0/x86_64/redox_demo_x86_64_2024-09-07_1225_livedisk.iso.zst) is recommended for most laptops. After downloading completes, check the [SHA256 sum](https://static.redox-os.org/releases/0.9.0/x86_64/SHA256SUM):

```sh
sha256sum $HOME/Downloads/redox_demo_x86_64_*_livedisk.iso.zst
```

If you have more than one demo image in the `Downloads` directory, you may need to replace the `*` symbol with the date of your file.

If the `demo` variant doesn't boot on your computer, try the [`desktop`](https://static.redox-os.org/releases/0.9.0/x86_64/redox_desktop_x86_64_2024-09-07_1225_livedisk.iso.zst) and [`server`](https://static.redox-os.org/releases/0.9.0/x86_64/redox_server_x86_64_2024-09-07_1225_livedisk.iso.zst) variants.

If even the `desktop` and `server` variants don't work, use the daily images below.

#### Daily Images

If you want to test the latest Redox changes you can use our bootable images created each day by opening the [build server images](https://static.redox-os.org/img) and downloading your preferred variant.

(Sometimes our daily images can be one week old or more because of breaking changes)
Once the download is complete, check the [SHA256 sum](https://static.redox-os.org/img/x86_64/SHA256SUM).

### Decompress the ISO Image

Downloaded Redox images are compressed using the [Zstd](https://github.com/facebook/zstd) algorithm. To decompress an image, follow the appropriate steps below for your system:

#### Linux (GUI)

 1. Install [GNOME File Roller](https://gitlab.gnome.org/GNOME/file-roller) or [KDE Ark](https://apps.kde.org/ark/) (both can be installed from [Flathub](https://flathub.org/))
 2. Open the Redox image and click on the "Extract" button

If you are using the GNOME Nautilus or KDE Dolphin file manager, right-click the file and select the option to extract the file.

#### Linux (Terminal)

Install the Zstd tool and run:

```sh
zstd -d $HOME/Downloads/redox_*_x86_64_*_livedisk.iso.zst
```

#### Windows (GUI)

 1. Install [7-Zip](https://www.7-zip.org/)
 2. Right-click the Redox image, hover the 7-Zip section and click on the option to extract the file or open the file on 7-Zip and extract

### Flash the ISO Image

#### Linux Instructions

We recommend using the [Popsicle](https://github.com/pop-os/popsicle) tool to flash ISO images to USB devices on Linux. To flash an image, follow the steps below:

 1. Open the [Releases](https://github.com/pop-os/popsicle/releases/latest) section to open the Popsicle releases page and download the `.AppImage` file.
 2. Open your file manager, click with the right-button of your mouse on the `.AppImage` file and open the "Properties", find the "Permissions" section and mark it as executable.
 3. Open the Popsicle `.AppImage` file, select the downloaded Redox image and your USB device.
 4. Confirm the flash process and wait until the progress bar reach 100%. If the flashing process completes with no errors, the flash was successful.

You can now restart your Linux machine and boot into Redox.

#### Windows Instructions

We recommend using the [Rufus](https://rufus.ie/) tool on Windows to flash your USB device, follow the steps below:

 1. Open the [Rufus website](https://rufus.ie/), navigate to the "Download" section and download the latest version.
 2. Open Rufus, select the ISO image of Redox, wait the Rufus image scanning, select your USB device and click on "Start".
 3. Confirm the permission to erase the data of your device and wait until the progress bar reach 100%
 4. If it shows a choice window with "ISO" and "DD" mode, select the "DD" mode. If the flashing process completes with no errors, the flash was successful.

Now you can now restart your Windows machine and boot into Redox.

## Booting the System

Some computers don't come with USB booting enabled, to enable it press the keyboard key to open your UEFI or BIOS setup and allow the booting from USB devices (the name varies from firmware to firmware).

If you don't know the keyboard keys to open your UEFI/BIOS setup or boot menu, press the Esc or F keys (from 1 until 12), if you press the wrong key or got the wrong timing, don't stop your operating system boot process to try again, as it could corrupt your data.

Once the ISO image boots, the system will display the Orbital GUI. Log in as the user named `user` with no password. The password for `root` is `password`.

See [Trying Out Redox](./trying-out-redox.md) for things to try.

To switch between Orbital and the console, use the following keys:

- F1: Display the console log messages
- F2: Open a text-only terminal
- F3: Return to the Orbital GUI

If you want to be able to boot Redox from your HDD or SSD, follow the [Installation](./installing.md) instructions.

Redox isn't currently going to replace your existing operating system, but it's a fun thing to try: boot Redox on your computer, and see what works.
