# Boot Process

## Bootloader
The first code to be executed is the boot sector in `kernel/asm/bootsector.asm`. This loads the bootloader from the first partition. In Redox, the bootloader finds the kernel and loads it in full at address 0x100000. It also initializes the memory map and the VESA display mode, as these rely on BIOS functions that cannot be accessed easily once control is switched to the kernel.

## Kernel
The kernel is entered through the interrupt table, with interrupt 0xFF. This interrupt is only available in the bootloader. By utilizing this method, all kernel entry can be contained to a single function, the `kernel` function, found in `kernel/main.rs`, that serves as the entry point in the `kernel.bin` executable file.

At this stage, the kernel copies the memory map out of low memory, sets up an initial page mapping, allocates the environment object, defined in `kernel/env/mod.rs`, and begins initializing the drivers and schemes that are embedded in the kernel. This process will print out kernel information such as the following:

```
Redox 32 bits
  * text=101000:151000 rodata=151000:1A4000
  * data=1A4000:1A5000 bss=1A5000:1A6000
 + PS/2
   + Keyboard
     - Reset FA, AA
     - Set defaults FA
     - Enable streaming FA
   + PS/2 Mouse
     - Reset FA, AA
     - Set defaults FA
     - Enable streaming FA
 + IDE on 0, 0, 0, 0, C120, IRQ: 0
   + Primary on: C120, 1F0, 3F4, IRQ E
     + Master: Status: 58 Serial: QM00001 Firmware: 2.0.0 Model: QEMUHARDDISK 48-bit LBA Size: 128 MB
     + Slave: Status: 0
   + Secondary on: C128, 170, 374, IRQ F
     + Master: Status: 41 Error: 2
     + Slave: Status: 0
```

After initializing the in-kernel structures, drivers, and schemes, the first userspace process spawned by the kernel is the `init` process, more specifically the `initfs:/bin/init` process.

## Init
Redox has a multi-staged init process, designed to allow for the loading of disk drivers in a modular and configurable fashion. This is commonly referred to as an init ramdisk.

### Ramdisk Init
The ramdisk init has the job of loading the drivers required to access the root filesystem and then transfer control to the userspace init. This is a filesystem that is linked with the kernel and loaded by the bootloader as part of the kernel image. You can see the code associated with the `init` process in `crates/init/main.rs`.

The ramdisk init loads, by default, the file `/etc/init.rc`, which may be found in `initfs/etc/init.rc`. This file currently has the contents:

```
echo ############################
echo ##  Redox OS is booting   ##
echo ############################
echo

# Load the filesystem driver
initfs:/bin/redoxfsd disk:/0

# Start the filesystem init
cd file:/
init
```

As such, it is very easy to modify Redox to load a different filesystem as the root, or to move processes and drivers in and out of the ramdisk.

### Filesystem Init
As seen above, the ramdisk init has the job of loading and starting the filesystem init. By default, this will mean that a new init process will be spawned that loads a new configuration file, now in the root filesystem at `filesystem/etc/init.rc`. This file currently has the contents:

```
echo ############################
echo ##  Redox OS has booted   ##
echo ##  Press enter to login  ##
echo ############################
echo

# Login process, handles debug console
login
```

Modifying this file allows for booting directly to the GUI. For example, we could replace `login` with `orbital`.

## Login
After the init processes have set up drivers and daemons, it is possible for the user to log in to the system. A simple login program is currently used, it's source may be found in `crates/login/main.rs`

The login program accepts a username, currently any username may be used, prints the `/etc/motd` file, and then executes `sh`. The motd file can be configured to print any message, it is at `filesystem/etc/motd` and currently has the contents:

```
############################
##  Welcome to Redox OS   ##
##  For GUI: Run orbital  ##
############################
```

At this point, the user will now be able to access the [Shell](./explore/shell.html)
