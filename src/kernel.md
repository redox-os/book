# Redox kernel

Redox OS kernel contains code for boot, context switching, CPU synchronization and certain services strictly requiring privileged kernel. Efforts to made it minimal has been done, but it can be moved to userspace even more. 

## Boot Initialization

Recalling [previous section](./boot-process.md), Redox OS bootloader specializes for searching hardware descriptor which will be sent to the Kernel. Here's what handed over from the bootloader:

- Display Framebuffer
- ACPI or DTB table
- Pointer to InitFS

To boot properly, the kernel has basic ACPI parser for certain task like paging, timer, serial devices and secondary CPUs. The rest of parsing will be done in userspace via `/scheme/kernel.acpi`.

In ARM and RISC-V, initialization via DTB can be used, but the decision is made from the bootloader and currently not customizable without recompiling. The rest of parsing can also being done in userspace via `/scheme/kernel.dtb`.

Each CPU will be initialized by the kernel and given an initial context called `[kmain]`. The primary CPU then starts a new context called `bootstrap` for initalizing initFS, then jumps into main context switch loop.

Read [System Services in User Space](./user-space.html) for more information about Userspace Initialization.

## Context

Each thread in userspace is one context in the kernel. Each context have one address space which may shared into other context grouped together as one process ID (PID).

Redox InitFS contains two things, an InitFS read-only data and ELF binary. The ELF binary contains `ProcMgr` which manages processes and threads in a secure way, communicating with kernel context via `/scheme/kernel.proc`, then bootstrap driver and services found in the InitFS mounted in `/scheme/initfs`. 

Contexts in the kernel is deliberately minimal. It does not know what kind of userspace code it's containing. When `fork()` is called, relibc send a message to `ProcMgr` which then issues new context to clone the context it was called from, while `exec()` is fully done in userspace via relibc.

Read [Scheduling](./scheduling.md) for more information about Context Scheduler.

## System Calls

System calls (syscall) are the backbone of communication between Userspace Application with Kernel. There are no application compiled without syscall, as the kernel is responsible for managing multiple apps running in a secure way. To ensure application uses syscall correctly, the Operating System is expected to maintain an [Application Binary Interface (ABI)](https://en.wikipedia.org/wiki/Application_binary_interface).

Redox Kernel ABI is maintained in [redox-syscall crate](https://crates.io/crates/redox_syscall). There are [45 syscalls](https://docs.rs/redox_syscall/latest/syscall/number/index.html) and the crate have a convenient function wrapping the syscall into Rust functions. However, Redox syscall ABI is unstable and might be reduced or abstracted into other form of IPC such as `/scheme`. Userspace apps and drivers are expected to use [libredox](https://crates.io/crates/libredox) that will route calls into relibc which aims to be stabilized in the future.

Read [Communication](./communication.md) for more information about Syscall, Scheme and other forms of communication.

## Address Spaces (Pages)

TODO

Read [Memory Management](./memory.md) for more information about RMM.

## Events and Interrupts

TODO

Events and Interrupts is explained thoroughly in [Scheduling](./scheduling.md).
