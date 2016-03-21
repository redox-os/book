Why Redox?
==========

A natural question this raises is: why do we need yet another OS? There are plenty out there already.

The answer is: you don't. No-one _needs_ an OS.

Why not contribute somewhere else? Linux? Plan 9? A BSD? Maybe even HURD? Or even go proprietary?
-------------------------------------------------------------------------------------------------

There are numerous other OS's, kernels, whatever that lack for contributors, and are in desperate need of more coders. Many times, this is for a good reason. Failures in management, a lack of money, inspiration, or innovation, or a limited set of applications have all caused projects to dwindle and eventually fail.

All these have numerous short-fallings, vulnerability, and bad design choices. Redox isn't and won't be perfect, but we seek to improve over other OSes.

Take Linux for example:

- Legacy until infinity: Old syscalls stay around forever, drivers for long-unbuyable hardware stay in the kernel as a mandatory part. While they can be disabled, running them in kernel space is essentially unnecessary, and is, by far, the biggest source of system crashes, security issues, and unexpected bugs.
- Huge codebase: To contribute, you must find a place to fit in to nearly _25 million lines of code_, in just the kernel. This is due to Linux's monolithic architecture.
- Restrictive license: Linux is licensed under GPL2. More on this in `Why MIT?`.
- Lack of memory safety: Linux has had numerous issues with memory safety throughout time. C is a fine language, but for such a security critical system, C doesn't fit.

It is no secret that we're more in favor of BSD, than Linux (although most of us are still Linux users, for various reasons). But BSD isn't quite there yet: most importantly, **it has a monolithic kernel, written in C**. This means that a single buggy driver can crash, hang, or cause damage to the system.

> TODO: Rewrite this
