Disadvantages of microkernels
=============================

Performance
-----------

Any modern operating system needs basic security mechanisms such as virtualization and segmentation of memory. Furthermore any process (including the kernel) has its own stack and variables stored in registers. On [context switch](https://en.wikipedia.org/wiki/Context_switch), that is each time a syscall is invoked or any other inter-process communication (IPC) is done, some tasks have to be done, including:

* saving caller registers, especially the program counter (caller: process invoking syscall or IPC)
* reprogramming the [MMU](https://en.wikipedia.org/wiki/Memory_management_unit)'s page table (aka [TLB](https://en.wikipedia.org/wiki/Translation_lookaside_buffer))
* putting CPU in another mode (kernel mode, user mode)
* restoring callee registers (callee: process invoked by syscall or IPC)

These operations take some time and might be happening more than once. On microkernel systems this time adds up since compared to a monolithic kernel functionality is split off in several processes, often requiring several context switches to do the same task.

With a good approach and some time spend optimizing for performance this should no longer be an issue, but Redox is not there yet.

See also: [Wikipedia on performance of minikernels](https://en.wikipedia.org/wiki/Kernel_operating_system#Performance)
