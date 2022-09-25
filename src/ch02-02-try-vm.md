Trying Redox in a virtual machine
=================================

To try Redox using a virtual machine such as QEMU or VirtualBox, download the `redox_harddrive.img` file, which you can find [here](https://static.redox-os.org/img/).

You can then run it in your preferred emulator; this command will run qemu with various features Redox can use enabled:

```
qemu-system-x86_64 -serial mon:stdio -d cpu_reset -d guest_errors -smp 4 -m 1024 -s -machine q35 -device ich9-intel-hda -device hda-duplex -net nic,model=e1000 -net user -device nec-usb-xhci,id=xhci -device usb-tablet,bus=xhci.0 -enable-kvm -cpu host -drive file=redox_harddrive.img,format=raw
```

Change `redox_harddrive.img` to the name of the file you downloaded, or change the name of the file to `redox_harddrive.img`.

As the system boots, it will ask you for a screen size to use, e.g. `1024x768`. After selecting a size, the system will complete the boot and display a Redox login screen. Login as user `user` with no password. The password for `root` is `password`. Use Ctrl+Alt+G to toggle the mouse behavior if you need to zoom out or exit the emulation.

See [Trying Out Redox](./ch02-06-trying-out-redox.html) for things to try.