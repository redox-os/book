# Boot Process

## Boot Loader

The boot loader source can be found in `cookbook/recipes/bootloader/source` after a successful build or in the [Boot Loader](https://gitlab.redox-os.org/redox-os/bootloader) repository.

### BIOS Boot

BIOS Boot is a boot process predates back into [The IBM PC](https://dosdays.co.uk/topics/pc_bios.php). Because of it's lengthly history, BIOS starts up in 16 bit mode (Real Mode) and boot loader need to load in multi stages to move into higher bit environment. The firmware will execute the boot sector located in the first sector of the main disk, this is known as stage 1 bootloader ([OSDev Wiki](https://wiki.osdev.org/Boot_Sequence#Master_Boot_Record)).

Redox writes stage 1 bootloader in Assembly, and can be found in `asm/x86-unknown-none/stage1.asm`. The stage 1 main task is to allow reading of the whole disk to load stage 2 in another sector of the disk. The stage 2 bootloader is also written in Assembly, which is main task is transfering BIOS functions ([OSDev Wiki](https://wiki.osdev.org/BIOS#BIOS_functions)) from real mode to protected mode (32 bit), then switches to protected mode or long mode (64 bit) and finally loads the Rust-written boot loader, called stage 3.

These three boot loader stages are combined in one executable written to the first megabyte of the storage device. The first code that is executed in Rust-written code is `pub extern "C" fn start()` in `src/os/bios/mod.rs`. At this point, the bootloader follows the same common boot process on all boot methods, which can be seen in a later section.

### UEFI Boot

Redox supports UEFI boots targeting 64 bit x86, ARM and RISC-V machines. UEFI starts up in 64 bit mode so it isn't require to boot into multiple stages. The firmware will find EFI System Partition (ESP) on the main disk, then loads and executes PE32+ UEFI programs typically located at `/EFI/BOOT/BOOTX64.efi` ([OSDev Wiki](https://wiki.osdev.org/UEFI#Bootable_UEFI_applications)). 

In the case of our bootloader, the first code that is executed is `pub extern "C" fn main()` in `src/os/uefi/mod.rs`. At this point, the bootloader follows the same common boot process on all boot methods, which can be seen in a later section.

### Common boot process

The bootloader initializes the memory map and the display mode, both of which rely on firmware mechanisms that are not acccessible after control is switched to the kernel. The bootloader then finds the RedoxFS partition on the disk and loads `/boot/kernel` and `/boot/initfs` files into memory. In the case of live disk, it loads the whole partition into memory instead.

After the kernel and initfs has been loaded, it set up a virtual paging for kernel and other data to be passed into it. Then, it maps the kernel to its expected virtual address, and jumps to its entry function.

## Kernel

The Redox kernel is a single ELF program in `/boot/kernel`. This kernel performs (fairly significant) architecture-specific initialization in the `kstart` function before jumping to the `kmain` function. At this point, the user-space bootstrap, a specially prepared executable that limits the required kernel parsing, sets up the `/scheme/initfs` scheme, and loads and executes the `init` program.

<!-- TODO: Explain briefly about logger, interrupts, paging and userspace initializations -->

## Init

Redox has a multi-staged init process, designed to allow for the loading of disk drivers in a modular and configurable fashion. This is commonly referred to as an init RAMdisk. The RAMdisk is contained in `/boot/initfs` which is a special file format containing the bootstrap code in ELF format and packed files which was loaded into `/scheme/initfs` by the kernel program.

### RAMdisk Init

The ramdisk init has the job of loading the drivers and daemons required to access the root filesystem and then transfer control to the filesystem init. The load order is defined in `/etc/init.rc` in initfs, which loads:

<!-- TODO: This should be in an entirely a different page -->

1. Daemons required for relibc
    - `rtcd` <!-- TODO: loads what? -->
    - `nulld` loads `/scheme/null`
    - `zero` loads `/scheme/zero`
    - `randd` loads `/scheme/rand`
2. Logging 
    - `logd` loads `/scheme/debug`
    - `stdio` loads `/scheme/log`
    - `ramfs` loads `/scheme/memory`
    - `logging` loads `/scheme/logging`
3. Graphics buffers
    - `inputd` setup first graphics buffer
    - The first graphics load `vesad` and `fbbootlogd`
    - `inputd -A 1` setup second graphics buffer
    - The second graphics load `fbcond` then drivers after that
4. Live daemon
    - `lived` <!-- TODO: loads what? -->
5. ACPI storage drivers in `/etc/init_drivers.rc`
    - `ahcid` AHCI storage driver
    - `ided` IDE storage driver
    - `nvmed` NVME storage driver
    - `virtio-blkd` VirtIO BLK storage driver
    - `virtio-gpud` VirtIO GPU storage driver
6. Root file system
    - `redoxfs` loads `/scheme/file`

After loading all drivers and daemons above, the `redoxfs` RedoxFS driver is executed with the UUID of the partition where the kernel and other boot files were located (chosen from the bootloader). It then searches every driver for this partition, and if it is found, mounts it and then allows init to continue.

### Filesystem Init

The filesystem init continues the loading of drivers for all other functionality. This includes audio, networking, and anything not required for disk access. It's mainly found in `/usr/lib/init.d`. In the redox builder repository, it's configurable in the [config directory](https://gitlab.redox-os.org/redox-os/redox/-/tree/master/config).

After this, the login prompt is shown both in second graphics buffer and the serial driver.

If Orbital is enabled, the display server is launched in third graphics buffer.

## Login

After the init processes have set up drivers and daemons, it is possible for the user to log in to the system. The login program accepts an username, with a default user called `user`, prints the `/etc/motd` file, and then executes the user's login shell, usually `ion`. At this point, the user will now be able to access the [shell](./shell.md)

<!-- TODO: Tell people how to switch between graphics buffer using Super Key -->

## Graphical overview

Here is an overview of the initialization process with scheme creation and usage. For simplicity's sake, we do not depict all scheme interaction but at least the major ones. **this is currently out of date, but still informative**

![Redox initialization graph](./assets/init.svg "Redox initialization graph")

## Boot process documentation

- [Boot process documentation](https://wiki.osdev.org/Boot_Sequence)
