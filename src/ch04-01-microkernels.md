Microkernels
============

Redox's kernel is a microkernel. Microkernels stand out in their design by providing minimal abstractions in kernel-space. Microkernels have an emphasis on user space, unlike Monolithic kernels which have an emphasis on kernel space.

The basic philosophy of microkernels is that any component which *can* run in user space *should* run in user space. Kernel-space should only be utilized for the most essential components (e.g., system calls, process separation, resource management, IPC, thread management, etc).

The kernel's main task is to act as a medium for communication and segregation of processes. The kernel should provide minimal abstraction over the hardware (that is, drivers, which can and should run in user mode).

Microkernels are more secure and less prone to crashes than monolithic kernels. This is due to drivers and other abstraction being less privileged, and thus cannot do damage to the system. Furthermore, microkernels are extremely maintainable, due to their small code size, this can potentially reduce the number of bugs in the kernel.

As anything else, microkernels do also have disadvantages. We will discuss these later.

Versus monolithic kernels
-------------------------

Monolithic kernels provide a lot more abstractions than microkernels.

![An illustration](https://upload.wikimedia.org/wikipedia/commons/6/67/OS-structure.svg)

The above illustration from [Wikimedia](https://commons.wikimedia.org/wiki/File:OS-structure.svg), by Wooptoo, License: Public domain) shows how they differ.

Documentation about microkernels
--------------------------------

- [OSDev technical wiki](https://wiki.osdev.org/Microkernel)
- [Message passing documentation](https://wiki.osdev.org/Message_Passing)
- [Minix documentation](https://wiki.minix3.org/doku.php?id=www:documentation:start)
- [Minix features](https://wiki.minix3.org/doku.php?id=www:documentation:features)
- [Minix reliability](https://wiki.minix3.org/doku.php?id=www:documentation:reliability)
- [GNU Hurd documentation](https://www.gnu.org/software/hurd/hurd/documentation.html)
- [Fuchsia documentation](https://fuchsia.dev/fuchsia-src/get-started/learn/intro)
- [HelenOS FAQ](http://www.helenos.org/wiki/FAQ)
- [Minix paper](http://www.minix3.org/docs/jorrit-herder/osr-jul06.pdf)
- [seL4 whitepaper](https://sel4.systems/About/seL4-whitepaper.pdf)
- [Microkernels performance paper](https://os.inf.tu-dresden.de/pubs/sosp97/)

A note on the current state
---------------------------

Redox has less than 9,000 lines of kernel code. For comparison Minix has ~6,000 lines of kernel code.

We would like to move parts of Redox to user space to get an even smaller kernel.
