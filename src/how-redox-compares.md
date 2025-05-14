# How Redox Compares to Other Operating Systems

We share quite a lot with other operating systems.

## System Calls

The Redox userspace API is Unix-like. For example, we have the `open`, `pipe`, `pipe2`, `lseek`, `read`, `write`, `brk`, `execv` POSIX functions, and so on. Currently, we implement userspace analogues of most Unix-like system calls (on monolithic kernels). The kernel syscall interface itself is unstable and may not be similar at all, but is closely related to the higher-level POSIX APIs built on top of them, at the moment.

However, Redox does not necessarily implement them as system calls directly. Much of the machinery for these functions (typically the [man(2)](https://en.wikipedia.org/wiki/Man_page#Manual_sections) functions) is provided in userspace through an interface library, `relibc`.

For example, the `open` POSIX function is called `SYS_OPEN` on relibc.

## "Everything is a File"

In a model largely inspired by Plan 9, in Redox, [resources](./resources.md) can be socket-like or file-like, providing a more unified system API.
Resources are named using paths, similar to what you would find in Linux or another Unix system.
But when referring to a resource that is being managed by a particular resource manager, you can address it using a scheme-rooted path.
We will explain this later, in the [Schemes and Resources](./schemes-resources.md) page.

## The kernel

Redox's kernel is a microkernel. The architecture is largely inspired by MINIX and seL4.

In contrast to Linux or BSD, Redox has around 50,000 lines of kernel code, a number that is often decreasing. Most system services are provided in userspace, either in an interface library, or as daemons.

Having vastly smaller amount of code in the kernel makes it easier to find and fix bugs/security issues in an efficient way.
Andrew Tanenbaum (author of MINIX) stated that for every 1,000 lines of properly written C code, there is a bug.
This means that for a monolithic kernel with nearly 25,000,000 lines of C code, there could be nearly 25,000 bugs.
A microkernel with only 50,000 lines of C code would mean that around 50 bugs exist (Tanenbaum Law).

It should be noted that in a microkernel the high amount of code (present in a monolithic kernel) is not removed, it's just moved to user-space daemons to make it less dangerous.

The main idea is to have system components and drivers that would be inside a monolithic kernel exist in user-space and follow the Principle of Least Authority (POLA). This is where every individual component is:

- Completely isolated in memory as separated user processes (daemons)
  - The failure of one component does not crash other components
  - Foreign and untrusted code does not expose the entire system
  - Bugs and malware cannot spread to other components
- Has restricted communication with other components
- Doesn't have Admin/Super-User privileges
  - Bugs are moved to user-space which reduces their power

All of this increases the reliability of the system significantly. This is important for users that want minimal issues with their computers or mission-critical applications.
