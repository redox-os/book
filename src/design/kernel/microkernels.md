Microkernels
============

As noted previously, Redox' kernel is a microkernel. Microkernels stands out in their design by providing minimal abstractions in kernel space. Microkernels do have, in contrary to monolithic kernel, great emphasis on userspace.

The philosophy of microkernels is essentially, that any components, which can run in user space, should run in user space. Kernel space should only be utilized for the most essential components, that is: system calls, process separation, resource management, IPC, thread management, and so on.

The kernel's main task is to act as a medium for communication and segregation of processes. The kernel should provide minimal abstraction over the hardware (that is, drivers which can, should run in user mode).

Microkernels are more secure and less prone to crashes than monolithic kernels. This is due to drivers and other abstraction being less privileged, and thus cannot do damage to the system. Furthermore, microkernels are extremely maintainable, due to their small code size, this can potentially reduce the number of bugs in the kernel.

As anything else, microkernels do also have disadvantages. We will discuss these later.

Versus monolithic kernels
-------------------------

Monolithic kernels provide a lot more abstractions than microkernels.

![An illustration](https://upload.wikimedia.org/wikipedia/commons/6/67/OS-structure.svg)

The above illustration ([from Wikimedia](https://commons.wikimedia.org/wiki/File:OS-structure.svg), by Wooptoo, License: Public domain) shows how they differ.

> TODO

A note on the current state
---------------------------

Currently, Redox has a 16,000 lines kernel. We would like to move certain things to userspace to get an even smaller kernel. For comparison, Minix has a 6,000 lines kernel.
