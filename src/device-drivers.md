# Writing a Device Driver

## Overview

A Redox device driver is a userspace task, very much like an application you might run.

But there are a few special things about Redox device drivers.

- Most device drivers are started by the driver for their bus,
and get configuration information from the bus driver.
- They receive requests from other applications via the "scheme" interface.
- They must run with `root` permission, to be able to access device addresses.
- They can request the kernel to memory-map the device into the driver address space.
- They can subscribe to device interrupts from the kernel.

## Driver to Device Interaction

### PCIe Driver

The PCIe driver,
[pcid](https://gitlab.redox-os.org/redox-os/drivers/-/tree/898f8dc72befa770e666f2f7b6379bfa4cb71975/pcid/src),
manages the PCIe bus and starts up drivers for the various devices on the bus.

The PCIe driver reads configuration files to determine
what driver corresponds to each device type.

It then [scans the bus](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/pcid/src/main.rs#L251),
identifying each device, and doing the common part of
[configuration](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/pcid/src/main.rs#L110).

### Driver Startup

When the PCIe driver determines the type of a device,
it [starts the device driver](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/pcid/src/main.rs#L193)
using the command from the configuration file.

First, it creates a two-way communication connection using Unix pipes,
then it executes the command for the correct driver.

When the driver starts up, it "daemonizes",
meaning that it creates an independent process to act as the actual driver
so the initial command can exit.
The daemonized driver uses the pipe connection to request
detailed information about the device from the PCIe driver.

### Memory Mapped Devices

If the device is a memory mapped device,
as is normally the case with modern devices,
the driver requests the kernel to map the device to the driver's virtual memory.
It uses the Redox function `physmap()`,
providing the Base Address Register (BAR) pointer and the BAR size,
which describe the devices's physical memory addresses,
and were received from the PCIe driver.
`physmap()` must be run with `root` permission.

`physmap()` requests the kernel to make the physical addresses
of the device available in the driver's virtual memory space,
returning a pointer to the virtual memory address.
The driver can then communicate with the device by writing to
the virtual address range that `physmap()` provided.

### Port IO

The PCIe driver also supports PCI.
"Legacy" PCI devices on x86 and x86_64 architectures use Port IO,
which is a special form of addressing and not part of the normal address space.

In order for a driver to use Port IO,
it must first request permission with the Redox system call `iopl()`.
It must be run with `root` permission to be granted Port IO access.

Once granted access, it can use physical port addresses directly
with the `in` and `out` asm instructions.

### Interrupts

When a device needs attention,
it send interrupt requests (IRQs) to the CPU,
causing the CPU to enter kernel mode and run
the designated function for that specific interrupt
as specified in an IRQ table in a known memory location.

Before the CPU can return to running tasks,
it must block or clear the interrupt condition.

Setting up interrupt handling functions,
keeping track of interrupts, blocking/clearing the condition,
and signalling the device driver tasks in userspace
is handled by the IRQ portion of the kernel.
Details of [how the kernel handles interrupts](#interrupt-handling-in-the-kernel) are below.

Because the device driver is a task and cannot be
directly executed in response to an interrupt,
Redox uses events and messages on a file-like interface to inform
the driver when an interrupt has occurred.

The mechanism for receiving messages about interrupts
is described below.
- [Driver Support Crates](#driver-support-crates)
- [IRQ Scheme](#the-irq-scheme)

### Device-specific code

Some examples of device-specific code are included below.
- [Device-specific initialization](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/storage/nvmed/src/nvme/mod.rs#L274)
- [Using a submission queue](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/storage/nvmed/src/nvme/mod.rs#L592)
- [Responding to an interrupt](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/storage/nvmed/src/nvme/cq_reactor.rs#L292-302)

### Using a Thread for Device Management

Since device interrupts are sent on a file-like interface,
and requests from the application interface also uses a file-like interface,
there are two possible strategies for each part of the driver
being able to block while waiting for an event.

Either:

1. Both kinds of events can be handled by a single mechanism,
and the decision on how to handle the event can be made
based on which file descriptor is active.
2. The device interface can be handled in a separate thread
from the application interface,
waiting for device events without concern for application events.

In the case of the NVMe driver, we have implemented both options,
with the "async" feature to select which approach to use.
- [Single-threaded](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/storage/nvmed/src/nvme/mod.rs#L454)
- [Separate device-handling thread](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/storage/nvmed/src/nvme/mod.rs#L531)

Using a separate thread simplifies some aspects of some drivers,
but relies on Rust's ["Fearless Concurrency"](https://doc.rust-lang.org/book/ch16-00-concurrency.html)
and Redox's [pthreads](https://en.wikipedia.org/wiki/Pthreads).
Redox pthreads are now mature enough to allow threaded drivers,
but many drivers have not yet added thread support.

## Application to Device Driver Interaction

### The Scheme

In the [Schemes and Resources](./schemes-resources.md) chapter,
we discuss the Redox concept of system services as "schemes".
Formally, "scheme" refers to the path used to reference a
system service.
But we also use the name "scheme" to refer to responding to
requests that use that path.
Please read the Schemes and Resources chapter,
and the section on [Scheme Operation](./scheme-operation.md)
in particular.

Some of the content of that chapter may be out of date
as we have been working on improving the scheme API.
A device driver is the provider of a scheme typically named
**"/scheme/{category}-{bus}-{function}-{type}"**, for example,
**"/scheme/disk.pci-00-00-05.0-nvme"**.
Here is [an example of registering](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/storage/nvmed/src/main.rs#L168) to provide a scheme.

### System Calls

This section is a little off-topic,
but it is background for how requests are sent to schemes.

When an application wants to request an action from a system service,
it performs a system call.
A system call places the call's parameters,
including the target of the call, any buffers and their lengths,
and a code for what function is requested,
onto the stack, and then triggers the system to switch to kernel mode.

In kernel mode, the system has access to the application's memory space, including the stack,
so it can read the system call parameters and determine what action to take.
The type of system call, and the meaning of the parameters,
is not immediately known, so in Redox we name the parameters "a", "b", "c", "d" and so on.
"a" is always the code for what function is requested,
and "b" is most often the file descriptor indicating the target of the system call.

For example,

`read(fd, buf, count)`

translates to a system call with

- `a = SYS_FREAD`
- `b = fd`
- `c = buf`
- `d = count`

The kernel uses the *application file descriptor* to look up
a *file description* that contains the kernel's knowledge
about what specific resource is being referred to,
which system service is responsible for that resource,
and the value of the *scheme file descriptor*,
that the system service uses to identify the resource.

### Scheme Interface

The scheme interface is the way the kernel tells a driver or system service
that it is requested to perform an action.

A packet is sent to the system service with
a copy of the information from the system call.

- `a` is the operation to be performed
- `b` is typically the *scheme file descriptor*, which the kernel has replaced in the system call
- other parameters for the system call

Any buffers that have been allocated are mapped in to the system service's memory space
and the `buf` pointer points to the buffer's virtual address in the system service's 
address space.
As well, the caller's `uid`, `gid` and `pid` are added to the packet.

This unwrapping of parameters and calling the correct
"scheme handler" function is handled transparently
by the [redox-scheme](https://gitlab.redox-os.org/redox-os/redox-scheme/-/blob/master/src/lib.rs?ref_type=heads#L173-184) crate.
When the [packet is received](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/storage/nvmed/src/main.rs#L199) by the system service,
[a "handler" is called](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/storage/nvmed/src/main.rs#L218),
which invokes the correct function in the system service's scheme handler.

### Redox Namespaces

Redox has the concept of a namespace,
used for resolving which service provides which scheme,
among other things.
This is different from namespaces used by devices like NVMe.

From a device driver's perspective,
the simplest way to describe a namespace is that it is a hashtable
where the name of the scheme is the key and the scheme socket is the value.
It is a much more powerful concept than that,
but the driver can get by with only that functionality.

When a driver or other privileged task is started,
it is started in the "root namespace",
meaning that all schemes that have been created are accessible
by specifying `/scheme/{scheme}` where `{scheme}` is the name used
when creating the scheme socket.

Creating a [scheme socket](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/storage/nvmed/src/main.rs#L168)
adds the scheme to the namespace,
and registers the socket using that name in the root namespace.

Once the driver has set up all the file descriptors it will be using,
it enters the [null namespace](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/storage/nvmed/src/main.rs#L193).
The `null` namespace is not completely empty,
it does have a few necessary services in it,
but there are no files and no device drivers that can be accessed.
This follows the [Principle of Least Privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege),
so if a security flaw is somehow found in a driver,
the system will not allow the driver to access anything
it does not already have a file descriptor for.

### Schemes, Paths, and Resources

A scheme is a provider of a service.
The service can be accessed using the path `/scheme/{scheme}`.
But often a service manages a collection of resources,
for example, the ACPI service manages several tables loaded from BIOS memory.
Each resource can be given a unique name,
so an application can identify the specific resource being addressed.

When the driver receives an [`open` call](https://gitlab.redox-os.org/redox-os/drivers/-/blob/b26aa9b32be53e2d41f807d674c067969e3dd2d3/acpid/src/scheme.rs#L145),
it includes a path (with `/scheme/{scheme}` removed)
to indicate what resource the application is referring to.
A driver can use flat naming, for example, `"1"`, `"2"`, `...`,
or it can use [hierarchical naming](https://gitlab.redox-os.org/redox-os/drivers/-/blob/b26aa9b32be53e2d41f807d674c067969e3dd2d3/acpid/src/scheme.rs#L152-157),
with slashes between layers,
implementing a path-like name.
It is up to the driver to determine the format,
and how to parse and interpret the resource name.
The application must then use the correct format when opening a path to the resource.

### User Space Schemes and Kernel Schemes

Most system services are provided as userspace tasks.
This is the preferred approach -
one goal of a microkernel operating system
is to have the smallest amount of code possible in the kernel.
However, there are some services that are hard to implement in userspace,
because most of the functionality needs to be in the kernel context.
There are some services that are implemented in the kernel for performance reasons, and may be moved into userspace later.

From the driver's perspective, it doesn't matter whether a service
is implemented in the kernel or in userspace,
the interaction is the same.
But some kernel services you might not think of as
using a read/write style of interface are implemented as Kernel Schemes.

- [IRQ](https://gitlab.redox-os.org/redox-os/kernel/-/blob/495c3708f3194aaf0a98c1d38a70a7e306b3ebc4/src/scheme/irq.rs) - manage interrupts and send events
- [Event](https://gitlab.redox-os.org/redox-os/kernel/-/blob/495c3708f3194aaf0a98c1d38a70a7e306b3ebc4/src/scheme/event.rs) - notify if a file descriptor needs attention (similar to [epoll]())
- [Time](https://gitlab.redox-os.org/redox-os/kernel/-/blob/495c3708f3194aaf0a98c1d38a70a7e306b3ebc4/src/scheme/time.rs) - send a message at a time in the future (used for timeouts)
- [Memory](https://gitlab.redox-os.org/redox-os/kernel/-/blob/495c3708f3194aaf0a98c1d38a70a7e306b3ebc4/src/scheme/memory.rs) - map physical memory pages to the caller's virtual address space

### File Systems and Pseudo-Devices

Most devices do not directly provide services to user applications.
Instead, there is some pseudo-device service or other service that the
user application accesses,
and that service then accesses the device driver service.

But the interface between a file system or pseudo-device and
a device driver is mostly the same as the interface between the
application and the file system or pseudo-device.

For example, the user accesses files on disk through the [RedoxFS file system](https://gitlab.redox-os.org/redox-os/redoxfs/-/blob/6abf533fdff23243e66c63c18db28215aab342c3/src/mount/redox/scheme.rs),
and RedoxFS accesses the blocks on disk through the [disk driver's scheme](https://gitlab.redox-os.org/redox-os/redoxfs/-/blob/6abf533fdff23243e66c63c18db28215aab342c3/src/disk/file.rs#L45).
RedoxFS has the knowledge of how the file system is organized,
and the disk driver provides RedoxFS with blocks of data
as requested.

### Handling Multiple Schemes

A device driver can support multiple schemes,
with a separate instantiation of the scheme handler for each scheme,
and a separate scheme socket.
The file descriptor for the scheme socket allows choosing the
correct scheme handler.

In order to listen to multiple schemes,
the driver can use the [redox-event](https://gitlab.redox-os.org/redox-os/event/-/blob/master/src/wrappers.rs?ref_type=heads#L155) crate.
The `redox-event` crate waits on multiple file descriptors,
receiving a message when one or more file descriptors are ready
to be read.
The [network stack](https://gitlab.redox-os.org/redox-os/netstack/-/blob/9c7c874cbcfbca23e33cdb2309bdc8a0a45f64a0/src/dnsd/main.rs#L32-70)
is an example of a service that supports multiple schemes.

### Timeouts

Timeouts in device drivers are normally handled one of two ways:

- By having a thread that [sleeps for the requested amount of time](https://gitlab.redox-os.org/redox-os/drivers/-/blob/b26aa9b32be53e2d41f807d674c067969e3dd2d3/xhcid/src/xhci/irq_reactor.rs#L122)
- By requesting a [timer notification](https://gitlab.redox-os.org/redox-os/ptyd/-/blob/9521cffd6d3453cd4dc6b74229fb1c73ab629bdc/src/main.rs#L44) from the "time" scheme

Either approach can work.
If you are designing a multithreaded or asynchronous driver,
consider using a thread that sleeps.
If you are already using the `redox-event` crate,
consider using a notification from the "time" scheme.

## Interrupt Handling in the Kernel

### Hardware Interrupts

There are few parts to the IRQ code in the kernel.

- [interrupt hardware configuration](https://gitlab.redox-os.org/redox-os/kernel/-/blob/7db6667e6bbc6287998620acd2ac8dd81aa2f6f1/src/dtb/irqchip.rs)
- [architecture-dependent interrupt handling](https://gitlab.redox-os.org/redox-os/kernel/-/blob/7db6667e6bbc6287998620acd2ac8dd81aa2f6f1/src/arch/x86_64/interrupt/irq.rs)
- [Notifying drivers via the IRQ scheme](https://gitlab.redox-os.org/redox-os/kernel/-/blob/495c3708f3194aaf0a98c1d38a70a7e306b3ebc4/src/scheme/irq.rs#L510)

### The IRQ Scheme

The "irq" scheme provides an `open/read/write` style interface
for device drivers to request notification when an interrupt occurs.

A device driver [opens a path that indicates what IRQ](https://gitlab.redox-os.org/redox-os/kernel/-/blob/495c3708f3194aaf0a98c1d38a70a7e306b3ebc4/src/scheme/irq.rs#L208) it is subscribing to.
The driver receives a file descriptor for the IRQ path it opened.

The driver can then read from the file descriptor,
either blocking (if it is using a thread),
or waiting for an event on the file descriptor.

## How Drivers are Built

When you build the system following the [build instructions](./podman-build.md),
the drivers are built automatically.
However, there are a few quirks when it comes to drivers.

Redox uses "recipes" to provide instructions on how to build applications and services.
A recipe is a script that tells the build system how to fetch,
compile and package the drivers.
Drivers are built in two groups, with slightly different recipes.
First, the critical drivers are built using the
[drivers-initfs recipe](https://gitlab.redox-os.org/redox-os/cookbook/-/blob/467e6d15dbc07f8a0119efba2434510393a776be/recipes/core/drivers-initfs/recipe.toml).
Then, the rest of the drivers are built using the
[drivers recipe](https://gitlab.redox-os.org/redox-os/cookbook/-/blob/467e6d15dbc07f8a0119efba2434510393a776be/recipes/core/drivers/recipe.toml).

The source for the drivers recipe is fetched into the directory
`cookbook/recipes/core/drivers/source`.
`drivers-initfs/source` is a symbolic link to `drivers/source`,
so you should do all your work in `drivers/source`.

Notice that you must add your driver to the appropriate recipe for it to get built.
As well, you must add your driver to the configuration file, either
[initfs.toml](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/initfs.toml) for the `initfs` drivers, or a driver-specific
[config.toml](https://gitlab.redox-os.org/redox-os/drivers/-/blob/e4ac216fe2ea6b211cc9118223adcfe833026903/net/e1000d/config.toml) for optional drivers.

### The Development Workflow

The build system for Redox is designed to run on Linux,
using Podman to ensure a consistent environment.
It may work on other platforms that support Podman.

When you begin development for Redox,
start by building Redox using the [Podman build](./podman-build.md).

If you want to use Redox's GitLab server for your Git repository,
please [follow the instructions here](./signing-in-to-gitlab.md).

Then, go to the directory `cookbook/recipes/core/drivers`
in your Redox working directory,
and edit the file `recipe.toml`.
Comment out the `[source]` section of the file,
including the `git = ` line,
so the Redox's build system will not try to update the source.

Setting up the working directory can be done a few ways,
but this is the most straightforward.

Remove the `source` directory and start fresh.
Clone the `drivers` repo, renaming the directory `source`.
You can find the Redox's [recommended way of using Git](./creating-proper-pull-requests.md).
Enter the drivers `source` directory and configure the Git repository.

If you are using Redox's GitLab,
create a fork of the `drivers` repo using the GitLab web interface.
Add your repository with `git remote add origin {my_repo}`.

For a new driver, create a directory using your driver name
in the category that suits your driver.
If you are developing a new optional driver,
you will need a `Cargo.toml` file and a `config.toml` file
in your new directory.
If you are developing a driver that is part of the `drivers-initfs`,
you will need to add it to `initfs.toml` and add it to the `recipe.toml`
in `cookbook/recipes/core/drivers-initfs`.

After doing your driver development,
open a terminal window in the base `redox` directory
where you did your original build of the system.

Run `make r.drivers` or `make r.drivers-initfs`,
depending on if your driver is optional or part of the initfs.
This will compile all the drivers the first time,
but after, it will only compile the files that you have changed.

Once you successfully compile the drivers,
run `make image` in the `redox`  directory to build an image
that you can run in QEMU.
Note that you must run `make r.drivers` and `make image` each time
you make a change to your driver.
Or, you can just run `make rebuild`,
which will update the whole system with the latest upstream changes (it can break your changes).

VirtualBox and QEMU have lots of options for emulating or passing through
hardware interfaces.
Have a look at the files `mk/virtualbox.mk` and `mk/qemu.mk`to see what options we support.
Or create a script for yourself to run VirtualBox or QEMU with the options you need.

## Other Topics

### USB

Redox has USB drivers for HID (keyboard and mouse).
Drivers for hubs, flash drives and other devices are under development
but not currently available.

Redox does not support USB Interrupts at this time.
Instead, it polls the device every few microseconds.

### ACPI

ACPI is a set of tables provided by the BIOS that describes the
system hardware.
Not all systems use ACPI.
Some device drivers might require information from ACPI.
On Redox, ACPI tables are available from the "acpi" scheme.
Start Redox and run `ls /scheme/acpi/tables` to see a list of available tables.
The contents of the tables are in binary and need to be parsed.
We do not have a standardized way of parsing them,
but you can use a crate like [acpi](https://docs.rs/acpi/latest/acpi/).

Read the data from the table like you are reading a binary file into a buffer,
then access the tables using the mechanism your `acpi` crate provides
to read the data you need.

### AML

AML is a means for the BIOS to provide hardware configuration
and management routines.
System power states, fan control and other environmental functions
are typically provided using AML.
AML is part of the ACPI table content.

Redox provides very limited support for AML, using the [aml](https://docs.rs/aml/latest/aml/) crate.
If Redox can successfully parse the AML code for your system,
you can get a list of available functions and data fields
by running the command `ls /scheme/acpi/symbols` on Redox.
If you view one of these files, there is a text display of the type and value of the AML symbol.

There is currently no mechanism to invoke an AML function.
It is planned as future work.

## Future Work

### IOMMU

IOMMU is a virtual memory component for a device to do [direct memory access](https://en.wikipedia.org/wiki/Direct_memory_access) (DMA) copying of data.

Devices that support DMA can read and write
the system's physical memory directly.
A corrupted driver can potentially read secret data from a program,
or overwrite the kernel.

The IOMMU allows the kernel to provide hardware protected access for DMA,
potentially keeping physical addresses secret from the device and
locking all pages except those configured for DMA.

Redox does not currently support IOMMU hardware. It is planned.
At this time, all devices should use physical addresses.

### io_uring

[io_uring](https://en.wikipedia.org/wiki/Io_uring) is a means for
requests to the operating system to be passed using shared ring buffers,
rather than through individual system calls.
This model of requesting and receiving messages from the operating system
can improve overall performance in some circumstances.

Redox does not currently support `io_uring`.
An `io_uring`-inspired implementation is planned
to be used in service-to-driver communication,
and in some application-to-service situations.
Because `io_uring` can create additional system overhead
and add latency to system calls,
it may not be implemented across the full system.