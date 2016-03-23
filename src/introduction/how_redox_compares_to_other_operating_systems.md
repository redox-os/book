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

Having vastly smaller amounts of code in the kernel makes it easier to find and fix bugs/security issues more efficiently. Andrew Tanenbaum (author of MINIX) stated that for every 1,000 lines of properly written code, there is a bug. This means that for a monolithic kernel which could average over 15,000,000 lines of code, there could be at least 15,000 bugs. A micro kernel which usually averages 15,000 lines of code would mean that at least 15 bugs exist.

It should be noted that the extra lines are simply based outside of kernel space, making them less dangerous, not necessarily a smaller number.

The main idea is to have components and drivers that would be inside a monolithic kernel exist in user space and follow the Principle of Least Authority (POLA). This is where every individual component is:
* Completely isolated in memory and as separate user processes.
  * The failure of one component does not crash the other components.
  * Allows foreign and untrusted code to not expose the entire system.
  * Bugs and malware cannot spread to other components.
* Has restricted communication which each other.
* Doesn't have Admin/Super-User privileges.
  * Bugs are moved to user space which reduces their power

All of this increases the reliability of the system significantly. This would be useful for mission-critical applications and for users that want minimal issues with their computer systems.
