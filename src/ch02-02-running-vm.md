# Running Redox in a virtual machine

To try Redox using a virtual machine such as QEMU or VirtualBox, download the `redox_harddrive.img` file, which you can find [here](https://static.redox-os.org/img/).

You can then run it in your preferred emulator. If you don't have an emulator installed, use the following command (Pop!_OS/Ubuntu/Debian) to install qemu:
```sh
$ sudo apt-get install qemu-system-x86
```
This command will run qemu with various features Redox can use enabled:

```
SDL_VIDEO_X11_DGAMOUSE=0 qemu-system-x86_64 -d cpu_reset,guest_errors -smp 4 -m 2048 \
    -chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug \
    -machine q35 -device ich9-intel-hda -device hda-duplex -netdev user,id=net0 \
    -device e1000,netdev=net0 -device nec-usb-xhci,id=xhci -enable-kvm -cpu host \
	-drive file=$HOME/Downloads/redox_harddrive.img,format=raw
```

Change `$HOME/Downloads/redox_harddrive.img` to the name of the file you downloaded. 

### Using the emulation

As the system boots, it will ask you for a screen size to use, e.g. `1024x768`. After selecting a size, the system will complete the boot, start the **Orbital** GUI, and display a Redox login screen. Login as user `user` with no password. The password for `root` is `password`. Use Ctrl+Alt+G to toggle the mouse behavior if you need to zoom out or exit the emulation. If your emulated cursor is out of alignment with your mouse position, type Ctrl+Alt+G to regain full cursor control, then click on your emulated cursor.

See [Trying Out Redox](./ch02-09-trying-out-redox.html) for things to try.

If you want to try Redox in **server** mode, add `-nographic -vga none` to the command line above.