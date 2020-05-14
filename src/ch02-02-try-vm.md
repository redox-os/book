Trying Redox in a virtual machine
=================================

The ISO image is *not* the prefered way to run Redox in a virtual machine. Currently the ISO image loads the entire hard disk image (including unused space) into memory. In the future, the live disk should be improved so that doesn't happen.

Instead, you want to use the harddrive image, which you can find [here (version 0.5.0)](https://gitlab.redox-os.org/redox-os/redox/-/jobs/10824/artifacts/browse/build/img/) as a `.bin.gz` file. Download and extract that file.

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

Here is the latest way of invoking the redox image as called by developers "make qemu" tool.  We are currently unable to successfully use "ping" by starting the image this way.
```
$ make qemu
SDL_VIDEO_X11_DGAMOUSE=0 qemu-system-x86_64 -d cpu_reset -d guest_errors -smp 4 -m 2048 -serial mon:stdio -machine q35 -device ich9-intel-hda -device hda-duplex -netdev user,id=net0 -device e1000,netdev=net0 -object filter-dump,id=f1,netdev=net0,file=build/network.pcap -device nec-usb-xhci,id=xhci -device usb-tablet,bus=xhci.0 -enable-kvm -cpu host -drive file=build/harddrive.bin,format=raw -drive file=build/extra.bin,format=raw
```

We are working on a way to tweak qemu to allow/enable ping/icmp from within the redox image.

```
apt-get install uml-utilities
```

Then we need this tap0 device to be created and configured:
```
sudo tunctl -u $USER
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo sh -c "echo 1 > /proc/sys/net/ipv4/conf/wlan0/proxy_arp"
sudo sh -c "echo 1 > /proc/sys/net/ipv4/conf/tap0/proxy_arp"

sudo sh -c "ip link set tap0 up"
ip -4 addr show dev enx00e04c78944d -->this shows your ip (192.168.2.29) on the particular dev
sudo sh -c "route add -host 192.168.2.29 dev tap0"   <-- to be changed by you.
```

Finally try invoking qemu using tap0 as the network device rather than net0:
```
SDL_VIDEO_X11_DGAMOUSE=0 qemu-system-x86_64 -d cpu_reset -d guest_errors -smp 4 -m 2048 -serial mon:stdio -machine q35 -device ich9-intel-hda -device hda-duplex -netdev user,id=tap0 -device e1000,netdev=tap0 -object filter-dump,id=f1,netdev=tap0,file=build/network.pcap -device nec-usb-xhci,id=xhci -device usb-tablet,bus=xhci.0 -enable-kvm -cpu host -drive file=build/harddrive.bin,format=raw -drive file=build/extra.bin,format=raw
```
