Why Redox?
==========

A natural question this raises is: why do we need yet another OS? There are plenty out there already.

The answer is: you don't. No-one _needs_ an OS.

Why not contribute somewhere else? Linux? BSD? MINIX?
-----------------------------------------------------

### Linux
There are numerous other OS's, kernels, whatever that lack for contributors, and are in desperate need of more coders. Many times, this is for a good reason. Failures in management, a lack of money, inspiration, or innovation, or a limited set of applications have all caused projects to dwindle and eventually fail.

All these have numerous short-fallings, vulnerability, and bad design choices. Redox isn't and won't be perfect, but we seek to improve over other OSes.

Take Linux for example:

- Legacy until infinity: Old syscalls stay around forever, drivers for long-unbuyable hardware stay in the kernel as a mandatory part. While they can be disabled, running them in kernel space is unnecessary, and can be a source of system crashes, security issues, and unexpected bugs.
- Huge codebase: To contribute, you must find a place to fit in to nearly _25 million lines of code_, in just the kernel. This is due to Linux's monolithic architecture.
- Restrictive license: Linux is licensed under GPL2, preventing some use cases that we would like to allow. More on this in `Why MIT?`.
- Lack of memory safety: Linux has had numerous issues with memory safety throughout time. C is a fine language, but for such a security critical system, C is difficult to use safely.

### BSD

It is no secret that we're more in favor of BSD, than Linux (although most of us are still Linux users, for various reasons). This is because of certain security features that allow the construction of a more reliable system, things like [jails](https://www.freebsd.org/doc/handbook/jails.html) and [ZFS](https://www.freebsd.org/doc/handbook/zfs.html).

BSD isn't quite there yet:

- It still has a monolithic kernel. This means that a single buggy driver can crash, hang, or, in worst case, cause damage to the system.
- The use of C in the kernel makes it probable to write code with memory safety issues.

### MINIX

And what about MINIX? It's microkernel design is a big influence on the Redox project, especially for reasons like [reliability](http://wiki.minix3.org/doku.php?id=www:documentation:reliability). MINIX is the most in line with Redox's philosophy. It has a similar design, and a similar license.

- Use of C - again, we would like drivers and the kernel to be written in Rust, to improve readability and organization, and to catch more potential safety errors. Compared to monolithic kernels, Minix is actually a very well-written and manageable code base, but it is still prone to memory unsafety bugs, for example. These classes of bugs can unfortunately be quite fatal, due to their unexpected nature.
- Lack of driver support - MINIX does not work well on real hardware, partly due to having less focus on real hardware.
- Less focus on "Everything is a File" - MINIX do focus less on "Everything is a File" than various other operating system, like Plan9. We are particularly focus on this idiom, for creating a more uniform program infrastructure.

The Need for Something New
--------------------------

We have to admit, that we do like the idea of writing something that is my own (Not Invented Here syndrome). There are numerous places in the MINIX 3 source code where I would like to make changes, so many that perhaps a rewrite in Rust makes the most sense.

- Different VFS model, based on URLs, where a program can control an entire segmented filesystem
- Different driver model, where drivers interface with filesystems like network: and audio: to provide features
- Different file system, RedoxFS, with a ZFS implementation in progress
- Userspace written mostly in Rust
- Orbital, a new GUI
