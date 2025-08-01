# Boot Process

## Boot Loader

The boot loader source can be found in `cookbook/recipes/bootloader/source` after a successful build or in the [Boot Loader](https://gitlab.redox-os.org/redox-os/bootloader) repository.

### BIOS Boot

BIOS Boot is a boot process that predates back to the [IBM PC](https://dosdays.co.uk/topics/pc_bios.php). Because of it's lengthy history, BIOS starts up in 16 bit mode (Real Mode) and the boot loader need to load in multi stages to move into higher bit environments. The firmware will execute the boot sector located in the first sector of the main storage device, this is known as stage 1 bootloader ([OSDev Wiki](https://wiki.osdev.org/Boot_Sequence#Master_Boot_Record)).

The stage 1 bootloader is written in Assembly and can be found in `asm/x86-unknown-none/stage1.asm`. The stage 1 main task is to allow reading of the whole disk to load stage 2 in another sector of the storage device. The stage 2 bootloader is also written in Assembly, which the main task is transferring [BIOS functions](https://wiki.osdev.org/BIOS#BIOS_functions) from real mode to protected mode (32 bit), then switches to protected mode or long mode (64 bit) and finally loads the Rust-written boot loader, called stage 3.

These three boot loader stages are combined in one executable written to the first megabyte of the storage device. The first code that is executed in Rust-written code is `pub extern "C" fn start()` in `src/os/bios/mod.rs`. At this point, the bootloader follows the same common boot process on all boot methods, which can be seen in a later section.

### UEFI Boot

Redox supports UEFI booting on x86-64, ARM64 and RISC-V 64-bit machines. UEFI starts up in 64 bit mode thus the boot process don't need multiple stages. The firmware will find the EFI System Partition (ESP) on the storage device, then loads and executes PE32+ UEFI programs typically located at `/EFI/BOOT/BOOTX64.efi` ([OSDev Wiki](https://wiki.osdev.org/UEFI#Bootable_UEFI_applications)). 

In the case of our bootloader, the first code that is executed is `pub extern "C" fn main()` in `src/os/uefi/mod.rs`. At this point, the bootloader follows the same common boot process on all boot methods, which can be seen in a later section.

### Common boot process

The bootloader initializes the memory map and the display mode, both of which rely on firmware mechanisms that are not acccessible after control is switched to the kernel. The bootloader then finds the RedoxFS boot partition on the disk and loads `/boot/kernel` and `/boot/initfs` files into memory. 

For a live disk it does load the whole partition into memory. It then loads `/boot/kernel` and `/boot/initfs` also at a different location in memory.

After the kernel and initfs has been loaded, it set up a virtual paging for kernel and environment variables including the location of the RedoxFS boot partiton to be passed into it. Then, it maps the kernel to its expected virtual address, and jumps to its entry function.

## Kernel

The Redox kernel is a single ELF program in `/boot/kernel`. This kernel performs (fairly significant) architecture-specific initialization in the `kstart` function before jumping to the `kmain` function. At this point, the user-space bootstrap, a specially prepared executable that limits the required kernel parsing, sets up the `/scheme/initfs` scheme, and loads and executes the `init` program.

The kernel creates three different namespaces during bootstrap process. Each namespaces has its own schemes where it can be accessed by userspace programs depending on where it loaded:

1. the `null` (0) namespace, which a global namespace that drivers are running on:
    - `/scheme/memory`
    - `/scheme/pipe`

2. the `root` (1) namespace, which can only be accessed by programs running as `root`:
    - `/scheme/kernel.acpi`
    - `/scheme/kernel.dtb`
    - `/scheme/kernel.proc`
    - `/scheme/debug`
    - `/scheme/irq`
    - `/scheme/serio`

3. the rest of isolated namespaces that can be accessed by all programs, also accessible by `root` namespace:
    - `/scheme/event`
    - `/scheme/memory`
    - `/scheme/pipe`
    - `/scheme/sys`
    - `/scheme/time`

## Init

Redox has a multi-staged init process, designed to allow for the loading of storage drivers in a modular and configurable fashion. This is commonly referred to as an init RAMdisk (initfs). The RAMdisk is contained in `/boot/initfs` which is a special file format containing the bootstrap code in ELF format and packed files which was loaded into `/scheme/initfs` by the kernel program.

### RAMdisk Init

The ramdisk init has the job of loading the drivers and daemons required to access the root filesystem and then transfer control to the filesystem init. The load order is defined in `/etc/init.rc` in initfs:

1. Daemons required for relibc
    - `rtcd` loads machine-specific RTC into `/scheme/time`
    - `nulld` null handler, creates `/scheme/null`
    - `zero` zero handler, creates `/scheme/zero`
    - `randd` rand handler, creates `/scheme/rand`
2. Logging 
    - `logd` system log handler, creates `/scheme/log`
    - `ramfs` loads in-memory FS handling into `/scheme/memory`
3. Graphics buffers
    - `inputd` virtual terminal (VT) handler, creates `/scheme/input`
    - `vesad` VESA interface handler, creates `/scheme/display.vesa`
    - `fbbootlogd` forwards log from inputd to VESA
    - `fbcond` handles keyboard interaction to VT
4. Live daemon
    - `lived` livedisk handler, creates `/scheme/disk.live`
5. Drivers in `/etc/init_drivers.rc`
    - `ps2d` loads PS/2 handling into `/scheme/serio`
    - `acpid` loads ACPI handling into `/scheme/kernel.acpi`
    - `pcid` PCI handler, creates `/scheme/pci`
    - `pcid-spawner` spawn drivers depending on available hardware
        - `ahcid` AHCI storage driver
        - `ided` IDE storage driver
        - `nvmed` NVME storage driver
        - `virtio-blkd` VirtIO BLK storage driver
        - `virtio-gpud` VirtIO GPU driver

After loading all drivers and daemons above, the `redoxfs` driver is executed with `--uuid $REDOXFS_UUID` where `$REDOXFS_UUID` is the partition chosen by the bootloader and creates `/scheme/file`. The command `set-default-scheme file` then is executed, so that the default path handler is set into `/scheme/file`.

### Filesystem Init

The filesystem init continues the loading of drivers for all other functionality. This includes audio, networking, and anything not required for storage device access. The drivers init configuration mainly found in `/usr/lib/init.d` and `/etc/pcid.d`. In the redox builder repository, it's configurable in the [config directory](https://gitlab.redox-os.org/redox-os/redox/-/tree/master/config/base.toml). After this, the login prompt is shown.

If Orbital is enabled, the display server is launched.

## Login

After the init processes have set up drivers and daemons, it is possible for the user to log in to the system. The login program accepts an username, with a default user called `user`, prints the `/etc/motd` file, and then executes the user's login shell, usually `ion`. At this point, the user will now be able to access the [shell](./shell.md)

## Graphical overview

Here is an overview of the initialization process with scheme creation and usage. For simplicity's sake, we do not depict all scheme interaction but at least the major ones. **this is currently out of date, but still informative**

![Redox initialization graph](./assets/init.svg "Redox initialization graph")

## Boot process documentation

- [Boot process documentation](https://wiki.osdev.org/Boot_Sequence)
