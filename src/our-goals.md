# Our Goals

Redox is an attempt to make a complete, fully-functioning, general-purpose operating system with a focus on safety, freedom, stabillity, correctness, and pragmatism.

We want to be able to use it, without obstructions, as a complete alternative to Linux/BSD in our computers. It should be able to run most Linux/BSD programs with minimal modifications. 

We're aiming towards a complete, stable, and safe Rust ecosystem. This is a design choice, which hopefully improves correctness and security (see the [Why Rust](./why-rust.md) page).

We want to improve the security design when compared to other Unix-like operating systems by using safe defaults and limiting insecure configurations where possible.

### Complete Alternative to Linux/BSD

Redox has its own kernel, drivers and filesystem written in Rust. The driver implementations are complete for QEMU, and [some hardware](./hardware-support.md) are known to work well. In terms of CPU architectures, Redox aims to have an equal support for three major architectures: x86 (32 and 64 bits), ARM (64 bits) and RISC-V (64 bits).

Redox can run C, C++ and Rust programs with the aid of [relibc](https://gitlab.redox-os.org/redox-os/relibc), an almost [POSIX-compliant C Standard Library](https://en.wikipedia.org/wiki/C_POSIX_library) written in Rust. Relibc has the goal to support most C, C++ and Rust based software. Many programs and libraries can be built and executed without any patches, some maybe need patches to workaround some functions, especially if it relies on non-POSIX functions.

Redox can also run GUI programs running on top of [Orbital](https://gitlab.redox-os.org/redox-os/orbital). C, C++ and Rust programs can draw windows with the help of [`orbclient`](https://gitlab.redox-os.org/redox-os/orbclient/) and [`liborbital`](https://gitlab.redox-os.org/redox-os/liborbital/) (our official Orbital client libraries).

Both system services and drivers are working well to run [important programs](./important-programs.md). We aim to have more POSIX and Linux compatibility to port more programs and attract more users.

### Rust Ecosystem

Rust officially supports Redox as both Tier II and Tier III [platforms](https://doc.rust-lang.org/nightly/rustc/platform-support/redox.html). The Rust community has accepted Redox-specific code for years. Some well-known Rust libraries (crates) that supports Redox are [`winit`](https://github.com/rust-windowing/winit/), [`nix`](https://github.com/nix-rust/nix), [`rustix`](https://github.com/bytecodealliance/rustix), and much more. These crates are backed by either [Rust's C Standard Library Bindings](https://github.com/rust-lang/libc) or a specific implementation of the [Rust's Standard Library](https://doc.rust-lang.org/std/). We upstream changes into these libraries as the system get new features.

Libraries using Rust libc are statically linked into relibc at compile-time. By this design choice, compiling any Rust program to Redox requires relibc available at linking time. While it seems like a inconvenience, it allows us to do quick development without having to push changes each time relibc is improved. To alleviate this "inconvenience", we have [`redoxer`](https://crates.io/crates/redoxer) to allow developers to compile and test Rust programs into Redox without using our complete build system.

### Security Design

The Redox kernel is a microkernel influenced by [some operating systems](./influences.md), thus many system services have been moved from the kernel to userspace daemons or drivers. Both drivers and system services are normal programs in userspace with higher permissions in a special namespace which allows them to access hardware interrupts managed by the kernel.

All programs including the kernel, drivers and system services are talking to each other using an IPC system called "Scheme". Schemes live inside the `/scheme` filesystem directory and any program can access or create it using the standard file API. For more advanced usage software can use `libredox` and many other `redox-*` crates, detailed in [another page](./libraries-apis.md#crates).

Schemes are secured mainly by namespaces. One namespace is invisible to another one. In case of programs talking to each other in the same namespace, the kernel and drivers use caller user ID or group ID, similar to Linux having `sudo`, but we're about to change it into [Capability-based security](https://en.wikipedia.org/wiki/Capability-based_security) in near future.

## The non-goals of Redox

We are not a Linux/BSD replacement, clone, or fully POSIX-compliant, nor crazy scientists who wish to redesign everything. Generally we stick to well-tested and proven correct designs: If it's not broken, don't fix it.

It means that a large number of programs and libraries will be compatible with Redox. Some things that do not align with our design decisions will have to be ported.

The key here is the trade off between correctness and compatibility. Ideally, you should be able to achieve both, but unfortunately, you can't always do so.

### Software Ports That Are Non-Goals

Redox aims to support most software, especially those that are important. Software that are not ported are either:

1. Not open source or libre, or known to have legal problems
2. No longer maintained (depending on importance we can fork and maintain it) or there's better alternative
3. Only using non-portable APIs like the Linux kernel or Windows
4. Lack of users and maintainers
5. The program language compiler lack Redox support

A well known example of software being too complicated to port is Chromium as it's heavily tuned to use OS-specific function calls and don't accept OS support beyond Linux in upstream, FreeBSD has to maintain [hundreds of patches](https://github.com/freebsd/freebsd-ports/tree/main/www/chromium/files) to make sure it's working. It's easier for us to port less complicated alternatives like Firefox, WebKit and Servo given that our limited resources are better spent on improving Redox itself.

This doesn't stop us from porting more programs even if they are non-POSIX. For example, Wayland is challenging to port as it depends on many Linux features. But given enough time, it will became available in Redox, just like how X11 is working on Redox.

### System Designs That Are Non-Goals

Redox aims to have the answer to every system design challenge if possible. However, correctness and security is our top priority next to other aspect like "performance", "usability" or "stability". That may change as Redox get close to releasing the 1.0 stable version.

Redox have gotten though many major system design changes since its inception. Historically Redox was not designed to be a microkernel nor POSIX-compliant, then both have changed in early times. We also recently switched our system service interface (scheme) design and about to change the security design to a capability-based system.

Nowadays all recent and future major changes into Redox is happening via [RFCs](https://gitlab.redox-os.org/redox-os/rfcs) and reviewed by Redox OS Board Members. Any Request For Changes that reduces correctness or security are likely not going to be accepted, but this terms are flexible and not enforced until the 1.0 stable version.

One example major design that trade security over "usability" is userspace exec which has been fully implemented. A userspace exec means `exec` are fully managed in userspace, it means that the kernel have no way to know how any software has been executed (e.g.their arguments and environment variables), as the kernel also have been restricted to not read any userspace memory.
