# Influences

This page explain how Redox was influenced by other operating systems.

## [Plan 9](http://9p.io/plan9/index.html)

This Bell Labs OS brings the concept of "Everything is a File" to the highest level, doing all the system communication from the filesystem.

- [Drew DeVault explains the Plan 9](https://drewdevault.com/2022/11/12/In-praise-of-Plan-9.html)
- [Plan 9's influence on Redox](https://doc.redox-os.org/book/ch05-00-urls-schemes-resources.html)

## [Minix](https://minix3.org/)

The most influential Unix-like system with a microkernel. It has advanced features such as system modularity, [kernel panic](https://en.wikipedia.org/wiki/Kernel_panic) resistence, driver reincarnation, protection against bad drivers and secure interfaces for [process comunication](https://en.wikipedia.org/wiki/Inter-process_communication).

Redox is largely influenced by Minix - it has a similar architecture but with a feature set written in Rust.

- [How Minix influenced the Redox design](https://doc.redox-os.org/book/ch04-01-microkernels.html)

## [seL4](https://sel4.systems/)

The most performant and simplest microkernel of the world.

Redox follow the same principle, trying to make the kernel-space small as possible (moving components to user-space and reducing the number of system calls, passing the complexity to user-space) and keeping the overall performance good (reducing the context switch cost).

## [BSD](https://en.wikipedia.org/wiki/Berkeley_Software_Distribution)

This Unix [family](https://en.wikipedia.org/wiki/Research_Unix) included several improvements on Unix systems and the open-source variants of BSD added many improvements to the original system (like Linux did).

- [FreeBSD](https://www.freebsd.org/) - The [Capsicum](https://man.freebsd.org/cgi/man.cgi?capsicum(4)) (a capability-based system) and [jails](https://en.wikipedia.org/wiki/Freebsd_jail) (a sandbox technology) influenced the Redox namespaces implementation.

- [OpenBSD](https://www.openbsd.org/) - The [system call](https://man.openbsd.org/pledge.2), [filesystem](https://man.openbsd.org/unveil.2), [display server](https://www.xenocara.org/) and [audio server](https://man.openbsd.org/sndiod.8) sandbox and [others](https://www.openbsd.org/innovations.html) influenced the Redox security.

## [Linux](https://www.kernel.org/)

The most advanced monolithic kernel and biggest open-source project of the world. It brought several improvements and optimizations to the Unix-like world.

Redox tries to implement the Linux performance improvements in a microkernel design.
