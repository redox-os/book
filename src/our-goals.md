# Our Goals

Redox is an attempt to make a complete, fully-functioning, general-purpose operating system with a focus on safety, freedom, stabillity, correctness, and pragmatism.

We want to be able to use it, without obstructions, as a complete alternative to Linux/BSD in our computers. It should be able to run most Linux/BSD programs with minimal modifications. 

We're aiming towards a complete, stable, and safe Rust ecosystem. This is a design choice, which hopefully improves correctness and security (see the [Why Rust](./why-rust.md) page).

We want to improve the security design when compared to other Unix-like operating systems by using safe defaults and limiting insecure configurations where possible.

### Complete Alternative to Linux/BSD

Redox has its own kernel, drivers and filesystem written in Rust. The driver implementations are complete for QEMU, and [some hardware](./hardware-support.md) are known to work well. In terms of machine architectore, Redox aims to have an equal support to four major architectures: 64 bit of x86, ARM and RISC-V, and 32 bit of x86.

Redox can run C programs with the aid of [relibc](https://gitlab.redox-os.org/redox-os/relibc), an almost [POSIX-compliant C Library](https://en.wikipedia.org/wiki/C_POSIX_library) written in Rust. Relibc has goal to be supporting most C/C++ based software. Many programs and libraries can be build without any patches, some maybe need patches to workaround some functions, especially if it relies on non POSIX functions.

Redox also can run GUI programs running on top Orbital. Both Rust and C programs can open GUI windows with the help of [`orbclient`](https://gitlab.redox-os.org/redox-os/orbclient/) and [`liborbital`](https://gitlab.redox-os.org/redox-os/liborbital/), our official orbital client library. GUI libraries that used heavily by both communities has support on them, for example winit and SDL2, both are using orbclient and liborbital as their GUI backend.

Both drivers and userspace programs are worked well for known system and programs, but we aim more compability to reach more user interests. The details of them are expanded in separate page.

### Rust Ecosystem

Rust has officially support Redox as both Tier II and Tier III [platforms](https://doc.rust-lang.org/nightly/rustc/platform-support/redox.html). In this case, Rust community has accepted Redox-specific code for years. Some well-known Rust libraries (crates) that supports redox are [`winit`](https://github.com/rust-windowing/winit/), [`nix`](https://github.com/nix-rust/nix), [`rustix`](https://github.com/bytecodealliance/rustix), and much more. These crates are backed by either [Rust's `libc`](https://github.com/rust-lang/libc) or specific implementation of [Rust `std`](https://doc.rust-lang.org/std/), and anytime we added new features, we also trying to push changes into these libraries.

Libraries that are using Rust libc will be linked into relibc at compile time, statically linked by default. By this design choice, compiling any Rust program to Redox requires relibc available at linking time. While it seems like a inconvience, it allows us to make rapid development without having to push changes each time relibc improved. To alleviate this "inconvience", we have [`redoxer`](https://crates.io/crates/redoxer) to allow developers to compile and test Rust programs into Redox without using our build system.

### Security Design

Redox kernel is inspired by many former operating systems. Redox kernel is mainly microkernel from ground up, so many services has been extracted out from kernel, into either a driver or a runtime service. Both driver and runtime services are no difference than running a software from userspace, except it's spawn into a special namespace where it allows accessing hardware interrupts managed by the kernel.

All programs including kernel, drivers and runtime services are talking to each other by using special IPC called "scheme". Schemes lives inside `/scheme` and any program can access or create it using standard file API. For more advanced usage software can use `libredox` and many other `redox-*` crates, detailed in [another page](./libraries-apis.md#crates).

Schemes are secured mainly by namespaces. One namespace is invisible to another one. In case of programs talking to each other in the same namespace, kernel and drivers are using caller user ID or group ID, similar to Linux being having `sudo`, but we're about to change it into [Capability-based security](https://en.wikipedia.org/wiki/Capability-based_security) in near future.

## The non-goals of Redox

We are not a Linux/BSD clone, or POSIX-compliant, nor crazy scientists, who wish to redesign everything. Generally, we stick to well-tested and proven correct designs. If it ain't broken we aren't going to change it.

This means that a large number of programs and libraries will be compatible with Redox. Some things that do not align with our design decisions will have to be ported.

The key here is the trade off between correctness and compatibility. Ideally, you should be able to achieve both, but unfortunately, you can't always do so.

### Software ports that are non-Goals

Redox aims to support most software, especially those that are important. Software that are not ported are either:

1. Not open source, or known to have legal problems
2. No longer maintained and there's better alternative
3. Mostly using Non-POSIX (e.g. Linux or Windows) API
4. Too complicated to port or no interest to it (yet)
5. The compiler is not supporting Redox officially yet

A well known example of software being too complicated to port is Chromium, as it's heavily tuned to use OS-specific function call, even FreeBSD has [countless patches](https://github.com/gliaskos/freebsd-chromium/tree/master/www/chromium/files) to make sure it's working. It's easier for us to port smaller alternatives like Servo given that our limited resource is better spent into improving Redox itself.

This doesn't stop us from porting more programs even though it's non POSIX. For example, Wayland is challenging to port as it depends on many Linux features. But given enough time, it will became available in Redox, just like how X11 is working on Redox.

### System designs that are non-Goals

Redox aims to have the answer to every system design challenge. However, correctness and security is our top priority next to other aspect like "performance", "usability" or "stability". That may change if Redox are close to releasing version 1.

Redox have gotten though many major system design change since its inception. Historically Redox was not designed to be Microkernel nor Unix compliant, then both have changed in early times. We also recently switched our scheme design and about to change the security design to be Capability-based design.

Nowadays all recent and future major changes into Redox is happening via RFC and reviewed by Redox OS Board Members. Any request of changes that reduces correctness or security are likely not going to be accepted, but this terms are flexible and not enforced until version 1 happening.

One example major design that trade security over "usability" is user-space exec which has been fully implemented. A user-space exec means `exec` are fully managed in user-space, this means kernel have no way to know how any software has been executed (e.g.their args and envars), as the kernel also have been restricted to not read any userspace memory.
