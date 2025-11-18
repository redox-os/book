# Running Redox in a Virtual Machine

- [VirtualBox Instructions](#virtualbox-instructions)
- [QEMU Instructions](#qemu-instructions)

## Download the bootable images

This section will guide you to download the Redox images.

(You need to use the `harddrive.img` image variant for QEMU or VirtualBox)

### Stable Releases

The bootable images for the 0.9.0 release are located on the [build server release folder](https://static.redox-os.org/releases/0.9.0/x86_64/). To try Redox using a virtual machine such as QEMU or VirtualBox, download the [demo](https://static.redox-os.org/releases/0.9.0/x86_64/redox_demo_x86_64_2024-09-07_1225_harddrive.img.zst) variant, check the [SHA256 sum](https://static.redox-os.org/releases/0.9.0/x86_64/SHA256SUM) to ensure it has downloaded correctly.

```sh
sha256sum $HOME/Downloads/redox_demo_x86_64_*_harddrive.img.zst
```

If you have more than one demo image in the `Downloads` directory, you may need to replace the `*` symbol with the date of your file.

If the demo variant doesn't boot on your computer, try the [desktop](https://static.redox-os.org/releases/0.9.0/x86_64/redox_desktop_x86_64_2024-09-07_1225_harddrive.img.zst) and [server](https://static.redox-os.org/releases/0.9.0/x86_64/redox_server_x86_64_2024-09-07_1225_harddrive.img.zst) variants.

Even if the `desktop` and `server` variants doesn't work, use the daily images below.

### Daily Images

If you want to test the latest Redox changes you can use our bootable images created each day by opening the [build server images](https://static.redox-os.org/img) and downloading your preferred variant.
Once the download is complete, check the [SHA256 sum](https://static.redox-os.org/img/x86_64/SHA256SUM).

(Sometimes our daily images can be one week old or more because of breaking changes)

## Decompression

The Redox images are compressed using the [Zstd](https://github.com/facebook/zstd) algorithm, to decompress follow the steps below:

### Linux

#### GUI

 1. Install [GNOME File Roller](https://gitlab.gnome.org/GNOME/file-roller) or [KDE Ark](https://apps.kde.org/ark/) (both can be installed from [Flathub](https://flathub.org/))
 2. Open the Redox image and click on the "Extract" button

If you are using the GNOME Nautilus or KDE Dolphin file manager, right-click the file and select the option to extract the file.

#### Terminal

Install the Zstd tool and run:

```sh
zstd -d $HOME/Downloads/redox_*_x86_64_*_harddrive.img.zst
```

### Windows

#### GUI

 1. Install [7-Zip](https://www.7-zip.org/)
 2. Right-click the Redox image, hover the 7-Zip section and click on the option to extract the file or open the file on 7-Zip and extract

## VirtualBox Instructions

To run Redox in a VirtualBox virtual machine you need to do the following steps:

 1. Create a VM with 2048 MB of RAM memory (or less if using a simpler Redox image variant) and 32MB of VRAM (video memory)
 2. Enable Nested Paging
 3. Change the keyboard and mouse interface to PS/2
 4. Change the audio controller to Intel HDA
 5. Disable USB support
 6. Go to the network settings of the VM and change the NIC model to 82540EM
 7. Go to the storage settings of the VM, create an IDE controller and add the Redox bootable image on it
 8. Start the VM!

If you want to install Redox on the VM create a VDI disk of 5GB (or less if you are using a simplier Redox image variant).

### Command for the pre-installed image

If you want to do this using the command-line, run the following commands:

 1. ```sh
    VBoxManage createvm --name Redox --register
    ```

 2. ```sh
    VBoxManage modifyvm Redox --memory 2048 --vram 32 --nic1 nat --nictype1 82540EM \
    --cableconnected1 on --usb off --keyboard ps2 --mouse ps2 --audiocontroller hda \
    --audioout on --nestedpaging on
    ```

 3. ```sh
    VBoxManage convertfromraw $HOME/Downloads/redox_demo_x86_64_*_harddrive.img harddrive.vdi
    ```

 4. ```sh
    VBoxManage storagectl Redox --name SATA --add sata --bootable on --portcount 1
    ```

 5. ```sh
    VBoxManage storageattach Redox --storagectl SATA --port 0 --device 0 --type hdd --medium harddrive.vdi
    ```

 6. ```sh
    VBoxManage startvm Redox
    ```

### Command for the Live ISO image

If you want to use the [Live ISO](https://static.redox-os.org/releases/0.9.0/x86_64/redox_demo_x86_64_2024-09-07_1225_livedisk.iso.zst) run the following commands:

 1. ```sh
    VBoxManage createvm --name Redox --register
    ```

 2. ```sh
    VBoxManage modifyvm Redox --memory 2048 --vram 32 --nic1 nat --nictype1 82540EM \
    --cableconnected1 on --usb off --keyboard ps2 --mouse ps2 --audiocontroller hda \
    --audioout on --nestedpaging on
    ```

 3. ```sh
    VBoxManage storagectl Redox --name SATA --add sata --bootable on --portcount 1
    ```

 4. ```sh
    VBoxManage storageattach Redox --storagectl SATA --port 0 --device 0 --type dvddrive --medium $HOME/Downloads/redox_demo_x86_64_*_livedisk.iso
    ```

 5. ```sh
    VBoxManage startvm Redox
    ```

## QEMU Instructions

### Linux

If you don't have QEMU installed use one of the following commands on Ubuntu, Debian or PopOS:

- x86 (i586) and x86-64 images

```sh
sudo apt-get install qemu-system-x86 qemu-kvm
```

- ARM64 images

```sh
sudo apt-get install qemu-system-arm qemu-kvm
```

- RISC-V images

```sh
sudo apt-get install qemu-system-riscv
```

Use one of the following commands to run QEMU with a Redox-compatible configuration:

- x86 (i586) image

```
SDL_VIDEO_X11_DGAMOUSE=0 qemu-system-x86_64 -d cpu_reset,guest_errors -smp 1 -m 2048 \
    -chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug \
    -machine pc -cpu pentium2 -device AC97 -netdev user,id=net0 \
    -device e1000,netdev=net0 -device nec-usb-xhci,id=xhci \
    -drive file=`echo $HOME/Downloads/redox_demo_i586_*_harddrive.img`,format=raw
```

- x86-64 image

```
SDL_VIDEO_X11_DGAMOUSE=0 qemu-system-x86_64 -d cpu_reset,guest_errors -enable-kvm -smp 4 -m 2048 \
    -chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug \
    uefi=yes -machine q35 -cpu host -device ich9-intel-hda -device hda-duplex -netdev user,id=net0 \
    -device e1000,netdev=net0 -device nec-usb-xhci,id=xhci \
    -drive file=`echo $HOME/Downloads/redox_demo_x86_64_*_harddrive.img`,format=raw
```

- ARM64 image

```
SDL_VIDEO_X11_DGAMOUSE=0 qemu-system-aarch64 -d cpu_reset,guest_errors -smp 4 -m 2048 \
    -chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug \
    uefi=yes -machine virt -cpu max -vga none -device ramfb -netdev user,id=net0 \
    -device e1000,netdev=net0 -device nec-usb-xhci,id=xhci \
    -drive file=`echo $HOME/Downloads/redox_demo_aarch64_*_harddrive.img`,format=raw
```

- RISC-V image

```
SDL_VIDEO_X11_DGAMOUSE=0 qemu-system-riscv64 -d cpu_reset,guest_errors -smp 4 -m 2048 \
    -chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug \
    -machine virt,acpi=off -cpu max -vga none -device ramfb -audio none -netdev user,id=net0 \
    -device e1000,netdev=net0 -device nec-usb-xhci,id=xhci \
    -drive file=`echo $HOME/Downloads/redox_demo_riscv64gc_*_harddrive.img`,format=raw
```

> 💡 **Tip:** if you encounter an error with the file name, verify that the name passed into the previous command (i.e., `$HOME/Downloads/redox_demo_x86_64_*_harddrive.img`) matches the file you downloaded.

### Windows

To install **QEMU** on Windows, follow the instructions [here](https://www.qemu.org/download/#windows). The installation of **QEMU** will probably not update your command path, so the necessary QEMU command needs to be specified using its full path. Or, you can add the installation folder to your `PATH` environment variable if you will be using it regularly.

Use one of the following commands to run QEMU with a Redox-compatible configuration:

- x86 (i586) image

```
"C:\Program Files\qemu\qemu-system-x86.exe" -d cpu_reset,guest_errors -smp 1 -m 2048
-chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug
-machine pc -cpu pentium2 -device AC97 -netdev user,id=net0
-device e1000,netdev=net0 -device nec-usb-xhci,id=xhci -device usb-tablet
-drive file=redox_demo_i586_*_harddrive.img,format=raw
```

- x86-64 image

```
"C:\Program Files\qemu\qemu-system-x86_64.exe" -d cpu_reset,guest_errors -smp 4 -m 2048
-chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug
uefi=yes -machine pc -cpu host -device ich9-intel-hda -device hda-duplex -netdev user,id=net0
-device e1000,netdev=net0 -device nec-usb-xhci,id=xhci -device usb-tablet
-drive file=redox_demo_x86_64_2024-09-07_1225_harddrive.img,format=raw
```

- ARM64 image

```
"C:\Program Files\qemu\qemu-system-aarch64.exe" -d cpu_reset,guest_errors -smp 4 -m 2048
-chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug
uefi=yes -machine virt -cpu max -vga none -device ramfb -netdev user,id=net0
-device e1000,netdev=net0 -device nec-usb-xhci,id=xhci -device usb-tablet
-drive file=redox_demo_aarch64_*_harddrive.img,format=raw
```

- RISC-V image

```
"C:\Program Files\qemu\qemu-system-riscv64.exe" -d cpu_reset,guest_errors -smp 4 -m 2048
-chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug
-machine virt,acpi=off -cpu max -vga none -device ramfb -audio none -netdev user,id=net0
-device e1000,netdev=net0 -device nec-usb-xhci,id=xhci -device usb-tablet
-drive file=redox_demo_riscv64gc_*_harddrive.img,format=raw
```

> 💡 **Tip:** if you get a filename error, change `redox_demo_x86_64_*_harddrive.img` to the name of the file you downloaded.

> 💡 **Tip:** if necessary, change `"C:\Program Files\qemu\qemu-system-x86_64.exe"` to reflect where **QEMU** was installed. The quotes are needed if the path contains spaces.

### Using the QEMU emulation

As the system boots, it will ask you for a screen resolution to use, for example `1024x768`. After selecting a screen size, the system will complete the boot, start the **Orbital** GUI, and display a Redox login screen. Login as user `user` with no password. The password for `root` is `password`. Use **Ctrl+Alt+G** to toggle the mouse behavior if you need to zoom out or exit the emulation. If your emulated cursor is out of alignment with your mouse position, type **Ctrl+Alt+G** to regain full cursor control, then click on your emulated cursor. **Ctrl+Alt+F** toggles between full screen and window views.

See [Trying Out Redox](./trying-out-redox.md) for things to try.

If you want to try Redox in **server** mode, add `-nographic -vga none` to the command line above. You may wish to switch to the `redox_server` edition. There are also i586 editions available, although these are not part of the release.
