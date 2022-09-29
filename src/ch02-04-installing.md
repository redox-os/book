# Installing Redox on a drive

Once you have [downloaded](./ch02-03-real-hardware.md) or [built](./ch02-05-building-redox.md) your ISO image, you can install it to your HDD or SSD. **Please back up your system** before attempting to install. Note that at this time (Release 0.8.0), you cannot install onto a USB drive, or use a USB drive for your Redox filesystem. 

After starting your *livedisk* system from a USB thumbdrive or from CD, log in as user `user` with an empty password. Open a Terminal window and type 
```sh
$ sudo redox_install_tui
```

If Redox recognizes your drive, it will prompt you to select a partition to install on. Choose carefully, as it will erase all the data on that partition. Note that if your drive is not recognized, it may offer you the option to install on `disk/live` (the in-memory *livedisk*). Don't do this, as it will crash Redox. Enter the number of the partition to install to. You will be prompted for a `redoxfs password`. This is for a secure filesystem. Leave the password empty and press enter if a secure filesystem is not required. Once the installation completes, power the system off, remove the USB, boot your system and you are ready to start using Redox!