# Running Redox in a virtual machine

To try Redox using a virtual machine such as QEMU or VirtualBox, download the `harddrive.img` file, which you can find [here](https://static.redox-os.org/img/x86_64). You will want the demo edition, which is labelled `redox_demo_x86_64`, then some version numbers, then `harddrive.img`.

You can then run it in your preferred emulator. If you don't have an emulator installed, use the following command (Pop!_OS/Ubuntu/Debian) to install qemu:
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

Change `$HOME/Downloads/redox_demo_x86_64*_harddrive.img` to the name of the file you downloaded. 

## Using the emulation

As the system boots, it will ask you for a screen resolution to use, e.g. `1024x768`. After selecting a screen size, the system will complete the boot, start the **Orbital** GUI, and display a Redox login screen. Login as user `user` with no password. The password for `root` is `password`. Use **Ctrl+Alt+G** to toggle the mouse behavior if you need to zoom out or exit the emulation. If your emulated cursor is out of alignment with your mouse position, type **Ctrl+Alt+G** to regain full cursor control, then click on your emulated cursor. **Ctrl+Alt+F** toggles between full screen and window views.

See [Trying Out Redox](./ch02-11-trying-out-redox.html) for things to try.

If you want to try Redox in **server** mode, add `-nographic -vga none` to the command line above. You may wish to switch to the `redox_server` edition. There are also [i686 editions](https://static.redox-os.org/img/i686) available.

## Running on Windows

To install **QEMU** on Windows, follow the instructions [here](https://www.qemu.org/download/#windows). The installation of **QEMU** will probably not update your command path, so the necessary QEMU command needs to be specified using its full path. Or, you can add the installation folder to your `Path` Environment Variable if you will be using it regularly.

Download the Redox image as above from [here](https://static.redox-os.org/img/x86_64). Then, in a Command window, `cd` to the location of the downloaded Redox image and run the following very long command:

```
"C:\Program Files\qemu\qemu-system-x86_64.exe" -d cpu_reset,guest_errors -smp 4 -m 2048 -chardev stdio,id=debug,signal=off,mux=on,"" -serial chardev:debug -mon chardev=debug -machine q35 -device ich9-intel-hda -device hda-duplex -netdev user,id=net0 -device e1000,netdev=net0 -device nec-usb-xhci,id=xhci -drive file=redox_demo_x86_64_harddrive.img,format=raw
```

**Note:** Change `redox_demo_x86_64_harddrive.img` to the name of the file you downloaded.

**Note:** Change `"C:\Program Files\qemu\qemu-system-x86_64.exe"` to reflect where **QEMU** was installed. The quotes are needed if the path contains spaces.
