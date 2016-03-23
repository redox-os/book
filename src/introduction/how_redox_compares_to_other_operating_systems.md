How Redox compares to other operating systems
=============================================

We share quite a lot with quite a lot other operating systems.

Syscalls
--------

The syscall interface is very Unix-y. For example, we have `open`, `pipe`, `pipe2`, `lseek`, `read`, `write`, `brk`, `execv`, and so on. Currently, we support the 31 most common Linux syscalls.

Compared to Linux, our syscall interface is much more minimal. This is not because of the stage in development, but because of a minimalist design.

"Everything is a URL"
----------------------

This is an generalization of "Everything is a file", largely inspired by Plan 9. In Redox, "resources" (will be explained later) can be both socket-like and file-like, making them fast enough for using them for virtually everything.

This way we get a more unified system API. We will explain this later, in [URLs, schemes, and resources](./design/urls_schemes_resources.html)

The kernel
----------

Redox's kernel is a microkernel. The architecture is largely inspired by MINIX.

In contrast to Linux or BSD, Redox has only 16,000 lines of kernel code, a number that is often decreasing. Most services are provided in userspace
