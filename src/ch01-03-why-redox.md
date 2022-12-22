Why Redox?
==========

There are plenty of operating systems out there. It's natural to wonder why we should build a new one. Wouldn't it be better to contribute to an existing project?

The Redox community believes that existing projects fall short, and that our goals are best served by a new project built from scratch.

Let's consider 3 existing projects.

### Linux

Linux runs the world, and boots on everything from high performance servers to tiny embedded devices. Indeed, many Redox community members run Linux as their main workstations. However, Linux is not an ideal platform for new innovation in OS development.

- Legacy until infinity: Old syscalls stay around forever, drivers for long-unbuyable hardware stay in the kernel as mandatory parts. While they can be disabled, running them in kernel space is unnecessary, and can be a source of system crashes, security issues, and unexpected bugs.
- Huge codebase: To contribute, you must find a place to fit in to nearly _25 million lines of code_, in just the kernel. This is due to Linux's monolithic architecture.
- Non-permissive license: Linux is licensed under GPL2, preventing the use of other free software licenses inside of the kernel. For more on why, see [Our Philosophy](./ch01-02-philosophy.md).
- Lack of memory safety: Linux has had numerous issues with memory safety throughout time. C is a fine language, but for such a security critical system, C is difficult to use safely.

### BSD

It is no secret that we're more in favor of BSD. The BSD community has led the way in many innovations in the past 2 decades. Things like [jails] and [ZFS] yield more reliable systems, and other operating systems are still catching up.

That said, BSD doesn't meet our needs either:

- It still has a monolithic kernel. This means that a single buggy driver can crash, hang, or, in the worst case, cause damage to the system.
- The use of C in the kernel makes it probable to write code with memory safety issues.

### MINIX

And what about MINIX? Its microkernel design is a big influence on the Redox project, especially for reasons like [reliability]. MINIX is the most in line with Redox's philosophy. It has a similar design, and a similar license.

- Use of C - again, we would like drivers and the kernel to be written in Rust, to improve readability and organization, and to catch more potential safety errors. Compared to monolithic kernels, Minix is actually a very well-written and manageable code base, but it is still prone to memory unsafety bugs, for example. These classes of bugs can unfortunately be quite fatal, due to their unexpected nature.
- Lack of driver support - MINIX does not work well on real hardware, partly due to having less focus on real hardware.
- Less focus on "Everything is a File" - MINIX does focus less on "Everything is a File" than various other operating systems, like Plan9. We are particularly focused on this idiom, for creating a more uniform program infrastructure.

The Need for Something New
--------------------------

We have to admit, that we do like the idea of writing something that is our own (Not Invented Here syndrome). There are numerous places in the MINIX 3 source code where we would like to make changes, so many that perhaps a rewrite in Rust makes the most sense.

- Different VFS model, based on URLs, where a program can control an entire segmented filesystem
- Different driver model, where drivers interface with filesystems like `network:` and `audio:` to provide features
- Different file system, RedoxFS, with a [TFS] implementation in progress
- User space written mostly in Rust
- [Orbital], a new GUI

[jails]: https://www.freebsd.org/doc/handbook/jails.html
[ZFS]: https://www.freebsd.org/doc/handbook/zfs.html
[reliability]: http://wiki.minix3.org/doku.php?id=www:documentation:reliability
[TFS]: https://gitlab.redox-os.org/redox-os/tfs
[Orbital]: https://gitlab.redox-os.org/redox-os/orbital
