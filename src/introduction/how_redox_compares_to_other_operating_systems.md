How Redox compares to other operating systems
=============================================

We share quite a lot with quite a lot other operating systems.

Syscalls
--------

The syscall interface is very Unix-y. For example, we have `open`, `pipe`, `pipe2`, `lseek`, `read`, `write`, `brk`, `execv`, and so on. Currently, we support the 31 most common Linux syscalls.

Compared to Linux, our syscall interface is much more minimal. This is not because of the stage in development. This is a matter of design. Linux has a lot unnecessary, bloated syscalls (try to run `man syscalls`, and an almost infinite list appears).

"Everything is an URL"
----------------------

This is an generalization of "Everything is an file", largely inspired by Plan 9. In Redox, "resources" (will be explained later) can be both socket-like and file-like, making them fast enough for using them for virtually everything.

This way we get a more unified system API.

The kernel
----------

Redox's kernel is a microkernel. The architecture is largely inspired by L4 and Minix.

In contrast to Linux or BSD, Redox is a microkernel, giving it numerous advantages (I'll explain these later on).
