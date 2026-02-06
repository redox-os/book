# Why a New OS?

The essential goal of the Redox project is to build a robust, reliable and safe general-purpose operating system. To that end, the following key design choices have been made.

## Written in Rust

Wherever possible, Redox code is written in [Rust](https://www.rust-lang.org/). Rust enforces a set of rules and checks on the use, sharing and deallocation of memory references. This almost entirely eliminates the potential for memory leaks, buffer overruns, use after free, and other [memory errors](https://en.wikipedia.org/wiki/Memory_safety#Types_of_memory_errors) that arise during development. The vast majority of security vulnerabilities in operating systems originate from memory errors. The Rust compiler prevents this type of error before the developer attempts to add it to the code base.

It allows us to unlock the full Rust potential by dropping legacy C and C++ code.

### Benefits

The following items summarize the Rust benefits:

- Memory-Safety

  All memory allocations are verified by the compiler to prevent bugs.

- Thread-Safety

  Concurrent code in programs is immune to data races.

- NULL-Safety

  NULLs can't cause undefined behavior.

## Microkernel Architecture

The [Microkernel Architecture](https://en.wikipedia.org/wiki/Microkernel) moves as much system components as possible out of the operating system kernel. Drivers, subsystems and other operating system functionality are excuted as independent processes on user-space (daemons). The kernel's main responsibility is the coordination of these processes, and the management of system resources to the processes.

Most kernels, other than some real-time operating systems, use an event-handler design. Hardware interrupts and application system calls, each one trigger an event invoking the appropriate handler. The kernel runs in supervisor-mode, with access to all system's resources. In [Monolithic Kernels](https://en.wikipedia.org/wiki/Monolithic_kernel), the operating system's entire response to an event must be completed in supervisor mode. A bug in the kernel, drivers or hardware, can cause the system to enter a state where it can't to respond to *any* event. And because of the large amount of code in the kernel, the potential for vulnerabilities while in supervisor mode is vastly greater than for a microkernel design.

Beyond monolithic kernels being much more vulnerable to bugs there's also the much higher complexity of post-Internet modern hardware and drivers that didn't existed when monolithic kernels were adopted, but since the adoption of Internet and the implementation of the [TCP/IP](https://en.wikipedia.org/wiki/Internet_protocol_suite) network stack in [BSD Unix](https://en.wikipedia.org/wiki/Berkeley_Software_Distribution) the complexity grew fast. This growth has caused a epidemic of bugs that are hard or invisible to debug due to all monolithic kernel components sharing the same memory address space.

In Redox, drivers and many system services can run in user-mode, similar to user programs, and the system can restrict them so they can only access the resources that they require for their designated purpose. If a driver fails or panics, it could be ignored or restarted with no impact on the rest of the system. A misbehaving piece of hardware might impact system performance or cause the loss of a service with a small chance of data corruption, but the kernel and maybe the essential system components will continue to function and to provide whatever services remain available.

Thus Redox is an unique opportunity to show the microkernel potential for the mainstream operating systems universe with the features and comodity that you would expect from them.

### Benefits

The following items summarize the microkernel benefits:

- More stable and secure

  The very small size of the kernel allow the system to be more stable and secure because most system components are isolated in user-space, reducing the chance of a [kernel panic](https://en.wikipedia.org/wiki/Kernel_panic) and the severity of security bugs.

- Bug isolation

  Most system components run in user-space on a microkernel system. Because of this some types of bugs in most system components and drivers can't spread to other system components or drivers.

- More stable long execution

  When an operating system is left running for a long time (days, months or even years) it will activate many bugs and it's hard to know when they were activated, at some point these bugs can cause security issues, data corruption or crash the system.

  In a microkernel most system components are isolated and some bug types can't spread to other system components, thus the long execution tend to enable less bugs reducing the security issues, data corruption and downtime on servers.

  Also some system components can be restarted on-the-fly (without a full system restart) to disable the bugs of a long execution.

- Restartless design

  A mature microkernel changes very little (except for bug fixes), so you won't need to restart your system very often to update it.

  Since most system components are in userspace they can be restarted/updated on-the-fly, reducing the downtime of servers a lot.

- Easy to develop and debug

  Most system components run in userspace, simplifying the testing and debugging.

- Easy and quick to expand

  New system components and drivers are easily and quickly added as userspace daemons.

- True modularity

  You can enable/disable/update most system components without a system restart, similar to but safer than some modules on monolithic kernels and [livepatching](https://en.wikipedia.org/wiki/Kpatch).

You can read more about the above benefits on the [Microkernels](./microkernels.md) page.

## Advanced Filesystem

Redox provides an advanced filesystem, [RedoxFS](https://gitlab.redox-os.org/redox-os/redoxfs). It includes many of the features in [ZFS](https://en.wikipedia.org/wiki/OpenZFS), but in a more modular design.

More details on RedoxFS can be found on the [RedoxFS](./redoxfs.md) page.

## Unix-like Tools and API

Redox provides a Unix-like command interface, with many everyday tools written in Rust but with familiar names and options. As well, Redox system services include a programming interface that is a subset of the [POSIX](https://en.wikipedia.org/wiki/POSIX) API, via [relibc](https://gitlab.redox-os.org/redox-os/relibc). This means that many Linux/POSIX programs can run on Redox with only recompilation. While the Redox team has a strong preference for having essential programs written in Rust, we are agnostic about the programming language for programs of the user's choice. This means an easy migration path for systems and programs previously developed for a Unix-like platform.
