# Installing Redox on a Drive

Once you have [downloaded](./real-hardware.md#creating-a-bootable-usb-drive) or [built](./coding-and-building.md#testing-on-real-hardware) your ISO image, you can install it to your internal HDD or SSD. **Please back up your system** before attempting to install. Note that at this time (Release 0.8.0), you can't install onto a USB device, or use a USB device for your Redox filesystem, but you can install from it.

After starting your *livedisk* system from a USB device or from CD/DVD, log in as the user named `user` with an empty password. Open a terminal window and type:

```sh
sudo redox_installer_tui
```

If Redox recognizes your device, it will prompt you to select a device to install on. Choose carefully, as it will erase all the data on that device. Note that if your device is not recognized, it may offer you the option to install on `disk/live` (the in-memory *livedisk*). Don't do this, as it will crash Redox.

You will be prompted for a `redoxfs password`. This is for a encrypted filesystem. Leave the password empty and press Enter if an encrypted filesystem is not required.

Once the installation completes, power off your computer, remove the USB device, power on your computer and you are ready to start using Redox!
