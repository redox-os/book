# How Redox Compares to Other Operating Systems

We share quite a lot with other operating systems.

## System Calls

The Redox system call interface is Unix-like. For example, we have `open`, `pipe`, `pipe2`, `lseek`, `read`, `write`, `brk`, `execv`, and so on. Currently, we support the most common Linux system calls.

Compared to Linux, our system call interface is much more minimal. This is not because of our development phase, but a minimalist design decision.

## "Everything is a URL"

This is an generalization of "Everything is a file", largely inspired by Plan 9. In Redox, [resources](./ch05-05-resources.html) can be both socket-like and file-like, making them fast enough to use for virtually everything.

This way, we get a more unified system API. We will explain this later, in [URLs, schemes, and resources](./ch05-00-urls-schemes-resources.md).

## The kernel

Redox's kernel is a microkernel. The architecture is largely inspired by MINIX and seL4.

In contrast to Linux or BSD, Redox has around 25,000 lines of kernel code, a number that is often decreasing. Most system services are provided in user-space as daemons.

Having vastly smaller amount of code in the kernel makes it easier to find and fix bugs/security issues in an efficient way. Andrew Tanenbaum (author of MINIX) stated that for every 1,000 lines of properly written C code, there is a bug. This means that for a monolithic kernel with nearly 25,000,000 lines of C code, there could be nearly 25,000 bugs. A microkernel with only 25,000 lines of C code would mean that around 25 bugs exist.

It should be noted that the extra lines are simply based outside of kernel-space, making them less dangerous, not necessarily a smaller number.

The main idea is to have system components and drivers that would be inside a monolithic kernel exist in user-space and follow the Principle of Least Authority (POLA). This is where every individual component is:

- Completely isolated in memory as separated user processes (daemons)
  - The failure of one component does not crash other components
  - Foreign and untrusted code does not expose the entire system
  - Bugs and malware cannot spread to other components
- Has restricted communication with other components
- Doesn't have Admin/Super-User privileges
  - Bugs are moved to user-space which reduces their power

All of this increases the reliability of the system significantly. This is important for users that want minimal issues with their computers or mission-critical applications.
