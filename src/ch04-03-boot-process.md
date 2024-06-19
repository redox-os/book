# Boot Process

## Boot Loader

The boot loader source can be found in `cookbook/recipes/bootloader/source` after a successful build or [here](https://gitlab.redox-os.org/redox-os/bootloader).

### BIOS Boot

The first code to be executed on x86 systems using BIOS is the boot sector, called stage 1, which is written in Assembly, and can be found in `asm/x86-unknown-none/stage1.asm`. This loads the stage 2 bootloader from disk, which is also written in Assembly. This stage switches to 32-bit mode and finally loads the Rust-written boot loader, called stage 3. These three boot loader stages are combined in one executable written to the first megabyte of the storage device. At this point, the bootloader follows the same common boot process on all boot methods, which can be seen in a later section.

### UEFI Boot

TODO

### Common boot process

The bootloader initializes the memory map and the display mode, both of which rely on firmware mechanisms that are not acccessible after control is switched to the kernel. The bootloader then finds the RedoxFS partition on the disk and loads the `kernel`, `bootstrap`, and `initfs` into memory. It maps the kernel to its expected virtual address, and jumps to its entry function.

## Kernel

The Redox kernel performs (fairly significant) architecture-specific initialization in the `kstart` function before jumping to the `kmain` function. At this point, the user-space bootstrap, a specially prepared executable that limits the required kernel parsing, sets up the `initfs` scheme, and loads and executes the `init` program.

## Init

Redox has a multi-staged init process, designed to allow for the loading of disk drivers in a modular and configurable fashion. This is commonly referred to as an init RAMdisk.

### RAMdisk Init

The ramdisk init has the job of loading the drivers required to access the root filesystem and then transfer control to the filesystem init. This contains drivers for ACPI, for the framebuffer, and for IDE, SATA, and NVMe disks. After loading all disk drivers, the RedoxFS driver is executed with the UUID of the partition where the kernel and other boot files were located. It then searches every driver for this partition, and if it is found, mounts it and then allows init to continue.

### Filesystem Init

The filesystem init continues the loading of drivers for all other functionality. This includes audio, networking, and anything not required for disk access. After this, the login prompt is shown.

If Orbital is enabled, the display server is launched.

## Login

After the init processes have set up drivers and daemons, it is possible for the user to log in to the system. The login program accepts an username, with a default user called `user`, prints the `/etc/motd` file, and then executes the user's login shell, usually `ion`. At this point, the user will now be able to access the [Shell](./ch06-03-shell.md)

## Graphical overview

Here is an overview of the initialization process with scheme creation and usage. For simplicity's sake, we do not depict all scheme interaction but at least the major ones. **this is currently out of date, but still informative**

![Redox initialization graph](./assets/init.svg "Redox initialization graph")

## Boot process documentation

- [Boot process documentation](https://wiki.osdev.org/Boot_Sequence)
