# Running Redox in a virtual machine

- [VirtualBox Instructions](#virtualbox-instructions)
- [QEMU Instructions](#qemu-instructions)

## Download the bootable images

This section will guide you to download the Redox images.

(You need to use the `harddrive.img` image variant for QEMU or VirtualBox)

### Stable Releases

The bootable images for the 0.9.0 release are located [here](https://static.redox-os.org/releases/0.9.0/x86_64/). To try Redox using a virtual machine such as QEMU or VirtualBox, download the [demo](https://static.redox-os.org/releases/0.9.0/x86_64/redox_demo_x86_64_2024-09-07_1225_harddrive.img.zst) variant, check the [SHA256 sum](https://static.redox-os.org/releases/0.9.0/x86_64/SHA256SUM) to ensure it has downloaded correctly.

```sh
sha256sum $HOME/Downloads/redox_demo_x86_64_*_harddrive.img.zst
```

If you have more than one demo image in the `Downloads` directory, you may need to replace the `*` symbol with the date of your file.

If the demo variant doesn't boot on your computer, try the [desktop](https://static.redox-os.org/releases/0.9.0/x86_64/redox_desktop_x86_64_2024-09-07_1225_harddrive.img.zst) and [server](https://static.redox-os.org/releases/0.9.0/x86_64/redox_server_x86_64_2024-09-07_1225_harddrive.img.zst) variants.

Even if the `desktop` and `server` variants doesn't work, use the daily images below.

### Daily Images

If you want to test the latest Redox changes you can use our bootable images created each day by opening [this](https://static.redox-os.org/img) link and downloading your preferred variant.

(Sometimes our daily images can be one week old or more because of breaking changes)

### Decompression

The Redox images are compressed using the [Zstd](https://github.com/facebook/zstd) algorithm, to decompress follow the steps below:

#### Linux

#### GUI

- Install [GNOME File Roller](https://gitlab.gnome.org/GNOME/file-roller) or [KDE Ark](https://apps.kde.org/ark/) (both can be installed from [Flathub](https://flathub.org/))
- Open the Redox image and click on the "Extract" button

If you are using the GNOME Nautilus or KDE Dolphin file managers, right-click the file and select the option to extract the file.

#### Terminal

Install the Zstd tool and run:

```sh
zstd -d $HOME/Downloads/redox_*_x86_64_*_harddrive.img.zst
```

#### Windows

#### GUI

- Install [PeaZip](https://peazip.github.io/)
- Right-click the Redox image, hover the PeaZip section and click on the option to extract the file or open the file on PeaZip and extract

## VirtualBox Instructions

To run Redox in a VirtualBox virtual machine you need to do the following steps:

- Create a VM with 2048 MB of RAM memory (or less if you are using a simplier Redox image variant) and 32MB of VRAM (video memory)
- Enable Nested Paging
- Change the keyboard and mouse interface to PS/2
- Change the audio controller to Intel HDA
- Disable the USB support
- Go to the network settings of the VM and change the NIC model to 82540EM
- Go to the storage settings of the VM, create an IDE controller and add the Redox bootable image on it
- Start the VM!

If you want to install Redox on the VM create a VDI disk of 5GB (or less if you are using a simplier Redox image variant).

### Command for the pre-installed image

If you want to do this using the command-line, run the following commands:

```sh
VBoxManage createvm --name Redox --register
```

```sh
VBoxManage modifyvm Redox --memory 2048 --vram 32 --nic1 nat --nictype1 82540EM \
--cableconnected1 on --usb off --keyboard ps2 --mouse ps2 --audiocontroller hda \
--audioout on --nestedpaging on
```

```sh
VBoxManage convertfromraw $HOME/Downloads/redox_demo_x86_64_*_harddrive.img harddrive.vdi
```

```sh
VBoxManage storagectl Redox --name SATA --add sata --bootable on --portcount 1
```

```sh
VBoxManage storageattach Redox --storagectl SATA --port 0 --device 0 --type hdd --medium harddrive.vdi
```

```sh
VBoxManage startvm Redox
```

### Command for the Live ISO image

If you want to use the [Live ISO](https://static.redox-os.org/releases/0.9.0/x86_64/redox_demo_x86_64_2024-09-07_1225_livedisk.iso.zst) run the following commands:

```sh
VBoxManage createvm --name Redox --register
```

```sh
VBoxManage modifyvm Redox --memory 2048 --vram 32 --nic1 nat --nictype1 82540EM \
--cableconnected1 on --usb off --keyboard ps2 --mouse ps2 --audiocontroller hda \
--audioout on --nestedpaging on
```

```sh
VBoxManage storagectl Redox --name SATA --add sata --bootable on --portcount 1
```

```sh
VBoxManage storageattach Redox --storagectl SATA --port 0 --device 0 --type dvddrive --medium $HOME/Downloads/redox_demo_x86_64_*_livedisk.iso
```

```sh
VBoxManage startvm Redox
```

## QEMU Instructions

### Linux

You can then run the image in your preferred emulator. If you don't have an emulator installed, use the following command (Pop!\_OS/Ubuntu/Debian) to install QEMU:

```sh
sudo apt-get install qemu-system-x86
```

This command will run qemu with various features Redox can use enabled:

```sh
SDL_VIDEO_X11_DGAMOUSE=0 qemu-system-x86_64 -d cpu_reset,guest_errors -smp 4 -m 2048 \
    -chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug \
    -machine q35 -device ich9-intel-hda -device hda-duplex -netdev user,id=net0 \
    -device e1000,netdev=net0 -device nec-usb-xhci,id=xhci -enable-kvm -cpu host \
	-drive file=`echo $HOME/Downloads/redox_demo_x86_64_*_harddrive.img`,format=raw
```

If you get an error with the filename, change the `echo $HOME/Downloads/redox_demo_x86_64*_harddrive.img` command to the name of the file you downloaded.

## MacOSX Instructions (Intel)

To install **QEMU** on MacOSX, use the following command:

```sh
brew install qemu
```

This command will run QEMU with various features Redox can use enabled:

```sh
SDL_VIDEO_X11_DGAMOUSE=0 qemu-system-x86_64 -d cpu_reset,guest_errors -smp 4 -m 2048 \
    -chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug \
    -machine q35 -device ich9-intel-hda -device hda-duplex -netdev user,id=net0 \
    -device e1000,netdev=net0 -device nec-usb-xhci,id=xhci -cpu max \
	-drive file=`echo $HOME/Downloads/redox_demo_x86_64_*_harddrive.img`,format=raw
```

If you get an error with the filename, change the `echo $HOME/Downloads/redox_demo_x86_64*_harddrive.img` command to the name of the file you downloaded.

**Note:** The `brew` command is part of the [Homebrew](https://brew.sh/) package manager for macOS.

### Windows

To install **QEMU** on Windows, follow the instructions [here](https://www.qemu.org/download/#windows). The installation of **QEMU** will probably not update your command path, so the necessary QEMU command needs to be specified using its full path. Or, you can add the installation folder to your `PATH` environment variable if you will be using it regularly.

Following the instructions for Linux above, download the same [redox_demo](https://static.redox-os.org/releases/0.8.0/x86_64/redox_demo_x86_64_2022-11-23_638_harddrive.img) image. Then, in a Command window, `cd` to the location of the downloaded Redox image and run the following very long command:

```
"C:\Program Files\qemu\qemu-system-x86_64.exe" -d cpu_reset,guest_errors -smp 4 -m 2048 -chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug -machine q35 -device ich9-intel-hda -device hda-duplex -netdev user,id=net0 -device e1000,netdev=net0 -device nec-usb-xhci,id=xhci -drive file=redox_demo_x86_64_2022-11-23_638_harddrive.img,format=raw
```

**Note:** If you get a filename error, change `redox_demo_x86_64_*_harddrive.img` to the name of the file you downloaded.

**Note:** If necessary, change `"C:\Program Files\qemu\qemu-system-x86_64.exe"` to reflect where **QEMU** was installed. The quotes are needed if the path contains spaces.

### Using the QEMU emulation

As the system boots, it will ask you for a screen resolution to use, for example `1024x768`. After selecting a screen size, the system will complete the boot, start the **Orbital** GUI, and display a Redox login screen. Login as user `user` with no password. The password for `root` is `password`. Use **Ctrl+Alt+G** to toggle the mouse behavior if you need to zoom out or exit the emulation. If your emulated cursor is out of alignment with your mouse position, type **Ctrl+Alt+G** to regain full cursor control, then click on your emulated cursor. **Ctrl+Alt+F** toggles between full screen and window views.

See [Trying Out Redox](./ch02-04-trying-out-redox.md) for things to try.

If you want to try Redox in **server** mode, add `-nographic -vga none` to the command line above. You may wish to switch to the `redox_server` edition. There are also i686 editions available, although these are not part of the release.
