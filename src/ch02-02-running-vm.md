# Running Redox in a virtual machine

The downloadable images for Release 0.8.0 of Redox are located [here](https://static.redox-os.org/releases/0.8.0/x86_64/). To try Redox using a virtual machine such as QEMU or VirtualBox, download the `demo_harddrive.img` file, which for Release 0.8.0, is [redox_demo_x86_64_2022-11-23_638_harddrive.img](https://static.redox-os.org/releases/0.8.0/x86_64/redox_demo_x86_64_2022-11-23_638_harddrive.img). After downloading, check the [SHA sum](https://static.redox-os.org/releases/0.8.0/x86_64/SHA256SUM) to ensure it has downloaded correctly.

```sh
sha256sum $HOME/Downloads/redox_demo_x86_64*_harddrive.img
```
If you have more than one `.img` file in the `Downloads` directory, you may need to adjust this command.

You can then run the image in your preferred emulator. If you don't have an emulator installed, use the following command (Pop!_OS/Ubuntu/Debian) to install qemu:
```sh
sudo apt-get install qemu-system-x86
```
This command will run qemu with various features Redox can use enabled:

```
SDL_VIDEO_X11_DGAMOUSE=0 qemu-system-x86_64 -d cpu_reset,guest_errors -smp 4 -m 2048 \
    -chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug \
    -machine q35 -device ich9-intel-hda -device hda-duplex -netdev user,id=net0 \
    -device e1000,netdev=net0 -device nec-usb-xhci,id=xhci -enable-kvm -cpu host \
	-drive file=`echo $HOME/Downloads/redox_demo_x86_64*_harddrive.img`,format=raw
```

If you get an error with the filename, change  
`` `echo $HOME/Downloads/redox_demo_x86_64*_harddrive.img` ``  
to the name of the file you downloaded. 

## Using the emulation

As the system boots, it will ask you for a screen resolution to use, e.g. `1024x768`. After selecting a screen size, the system will complete the boot, start the **Orbital** GUI, and display a Redox login screen. Login as user `user` with no password. The password for `root` is `password`. Use **Ctrl+Alt+G** to toggle the mouse behavior if you need to zoom out or exit the emulation. If your emulated cursor is out of alignment with your mouse position, type **Ctrl+Alt+G** to regain full cursor control, then click on your emulated cursor. **Ctrl+Alt+F** toggles between full screen and window views.

See [Trying Out Redox](./ch02-11-trying-out-redox.html) for things to try.

If you want to try Redox in **server** mode, add `-nographic -vga none` to the command line above. You may wish to switch to the `redox_server` edition. There are also [i686 editions](https://static.redox-os.org/img/i686) available, although these are not part of the release.

## Running on Windows

To install **QEMU** on Windows, follow the instructions [here](https://www.qemu.org/download/#windows). The installation of **QEMU** will probably not update your command path, so the necessary QEMU command needs to be specified using its full path. Or, you can add the installation folder to your `Path` Environment Variable if you will be using it regularly.

Following the instructions for Linux above, download the same [redox_demo](https://static.redox-os.org/releases/0.8.0/x86_64/redox_demo_x86_64_2022-11-23_638_harddrive.img) image. Then, in a Command window, `cd` to the location of the downloaded Redox image and run the following very long command:

```
"C:\Program Files\qemu\qemu-system-x86_64.exe" -d cpu_reset,guest_errors -smp 4 -m 2048 -chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug -machine q35 -device ich9-intel-hda -device hda-duplex -netdev user,id=net0 -device e1000,netdev=net0 -device nec-usb-xhci,id=xhci -drive file=redox_demo_x86_64_2022-11-23_638_harddrive.img,format=raw
```

**Note:** If you get a filename error, change `redox_demo_x86_64*_harddrive.img` to the name of the file you downloaded.

**Note:** If necessary, change `"C:\Program Files\qemu\qemu-system-x86_64.exe"` to reflect where **QEMU** was installed. The quotes are needed if the path contains spaces.
