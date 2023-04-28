# System Services in User Space

As any microkernel-based operating system, most kernel components are moved to user-space and adapted to work on it.

Monolithic kernels in general have hundreds of system calls due to the high number of kernel components (system calls are interfaces for these components), not to mention the number of sub-syscalls provided by ioctl and e.g. procfs/sysfs. Microkernels on the other hand, can have dozens of them.

This happens because the non-core kernel components are moved to user-space, thereby relying on IPC instead, which we will later explain.

Userspace bootstrap is the first program launched by the kernel, and has a simple design. The kernel loads the `initfs` blob, containing both the bootstrap executable itself and the initfs image, that was passed from the bootloader. It creates an address space containing it, and jumps to a bootloader-provided offset. Bootstrap allocates a stack (in an Assembly stub), `mprotect`s itself, and does the remaining steps to exec the `init` daemon. It also sets up the `initfs` scheme daemon.

The system calls used for IPC, are almost exclusively file-based. The kernel therefore has to know what schemes to forward certain system calls to. All file syscalls are marked with either `SYS_CLASS_PATH` or `SYS_CLASS_FILE`. The kernel associates paths with schemes by checking their scheme prefix against the scheme's name, in the former case, and in the latter case, the kernel simply remembers which scheme opened file descriptors originated from. Most IPC in general is done using schemes, with the exception of regular pipes like Linux has, which uses `pipe2`, `read`, `write`, `close`. Any scheme can also of course setup its own custom pipe-like IPC that also uses the aforementioned syscalls, like `shm:` and `chan:` from `ipcd`.

Schemes are implemented as a regular Rust trait in the kernel. Some builtin kernel schemes exist, which just implement that trait. Userspace schemes are provided via the `UserScheme` trait implementor, which relies on messages being sent between the kernel and the scheme daemon. This channel is created by scheme daemons when opening `:SCHEME_NAME`, which is parsed to the root scheme `""` with path `"SCHEME_NAME"`. Messages are sent by reading from and writing to that root scheme file descriptor.

So all file-based syscalls on files owned by userspace, will send a message to that scheme daemon, and when the result is sent back, the kernel will return that result back to the process doing the syscall.

Communication between userspace and the kernel, is generally fast, even though the current syscall handler implementation is somewhat unoptimized. Systems with Meltdown mitigations would be an exception, although such mitigations are not yet implemented.
