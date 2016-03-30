Disadvantages of microkernels
=============================

Performance
-----------

Any modern operating system needs basic security mechanisms such as virtualization and segmentation of memory. Furthermore any process (including the kernel) has its own stack and variables stored in registers. On [context switch](https://en.wikipedia.org/wiki/Context_switch), that is each time a syscall is invoked or any other inter-process communication (IPC) is done, some tasks have to be done, including:

* saving caller registers, especially the program counter (caller: process invoking syscall or IPC)
* reprogramming the [MMU](https://en.wikipedia.org/wiki/Memory_management_unit)'s page table (aka [TLB](https://en.wikipedia.org/wiki/Translation_lookaside_buffer))
* putting CPU in another mode (kernel mode, user mode)
* restoring callee registers (callee: process invoked by syscall or IPC)

These are not necessarily slower on microkernels, instead microkernels suffers from having the need to perform these operations more frequently, due to many of the system functionality is performed by userspace processes, often requiring additional context switches.

To this date, microkernels have marginalized the performance difference between monolithic and microkernels, making the performance comparable. This is partly due to a smaller surface area, which can be more manageable to optimize. Unfortunately, Redox isn't quite there yet, we do still have a relatively slow kernel, since not much time has been spent on optimizing it.
