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

![An illustration]

The above illustration ([from Wikimedia], by Wooptoo, License: Public domain) shows how they differ.

Documentation about microkernels
--------------------------------

- [OSDev technical wiki]
- [Minix documentation]
- [Minix features]
- [Minix reliability]
- [Minix paper]
- [GNU Hurd documentation]
- [HelenOS FAQ]
- [Microkernels performance paper]
- [seL4 whitepaper]
- [Fuchsia documentation]

A note on the current state
---------------------------

Redox has less than 9,000 lines of kernel code. For comparison Minix has ~6,000 lines of kernel code.

We would like to move parts of Redox to user space to get an even smaller kernel.

[An illustration]: https://upload.wikimedia.org/wikipedia/commons/6/67/OS-structure.svg
[from Wikipedia]: https://commons.wikimedia.org/wiki/File:OS-structure.svg
[OSDev technical wiki]: https://wiki.osdev.org/Microkernel
[Minix documentation]: https://wiki.minix3.org/doku.php?id=www:documentation:start
[Minix features]: https://wiki.minix3.org/doku.php?id=www:documentation:features
[Minix reliability]: https://wiki.minix3.org/doku.php?id=www:documentation:reliability
[Minix paper]: http://www.minix3.org/docs/jorrit-herder/osr-jul06.pdf
[GNU Hurd documentation]: https://www.gnu.org/software/hurd/hurd/documentation.html
[HelenOS FAQ]: http://www.helenos.org/wiki/FAQ
[Microkernels performance paper]: https://os.inf.tu-dresden.de/pubs/sosp97/
[seL4 whitepaper]: https://sel4.systems/About/seL4-whitepaper.pdf
[Fuchsia documentation]: https://fuchsia.dev/fuchsia-src/get-started/learn/intro