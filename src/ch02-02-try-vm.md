Trying Redox in a virtual machine
=================================

The ISO image is *not* the prefered way to run Redox in a virtual machine. Currently the ISO image loads the entire hard disk image (including unused space) into memory. In the future, the live disk should be improved so that doesn't happen.

Instead, you want to use the harddrive image, which you can find [here (version 0.6.0)](https://gitlab.redox-os.org/redox-os/redox/-/jobs/31100/artifacts/browse/build/img/) as a `.bin.gz` file. Download and extract that file.

You can then run it in your prefered emulator; this command will run qemu with various features Redox can use enables:

```
qemu-system-x86_64 -serial mon:stdio -d cpu_reset -d guest_errors -smp 4 -m 1024 -s -machine q35 -device ich9-intel-hda -device hda-duplex -net nic,model=e1000 -net user -device nec-usb-xhci,id=xhci -device usb-tablet,bus=xhci.0 -enable-kvm -cpu host -drive file=harddrive.bin,format=raw
```

If necessary, change `harddrive.bin` to the path of the `.bin` file you just extracted.

Once the system is fully booted, you will be greeted by the RedoxOS login screen. In order to login, enter the following information:

```
User = root
password = password
```
