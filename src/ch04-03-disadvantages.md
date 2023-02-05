Disadvantages of microkernels
=============================

Performance
-----------

Any modern operating system needs basic security mechanisms such as virtualization and segmentation of memory. Furthermore any process (including the kernel) has its own stack and variables stored in registers. On [context switch], that is each time a syscall is invoked or any other inter-process communication (IPC) is done, some tasks have to be done, including:

* Saving caller registers, especially the program counter (caller: process invoking syscall or IPC)
* Reprogramming the [MMU]'s page table (aka [TLB])
* Putting CPU in another mode (kernel mode, user mode)
* Restoring callee registers (callee: process invoked by syscall or IPC)

These are not inherently slower on microkernels, but microkernels suffer from having to perform these operations more frequently. Many of the system functionality is performed by user space processes, requiring additional context switches.

The performance difference between monolithic and microkernels has been marginalized over time, making their performance comparable. This is partly due to a smaller surface area which can be easier to optimize.

Unfortunately, Redox isn't quite there yet. We still have a relatively slow kernel since not much time has been spent on optimizing it.

[Context switch documentation]
[Microkernels performance paper]

[context switch]: https://en.wikipedia.org/wiki/Context_switch
[MMU]: https://en.wikipedia.org/wiki/Memory_management_unit
[TLB]: https://en.wikipedia.org/wiki/Translation_lookaside_buffer
[Microkernels performance paper]: https://os.inf.tu-dresden.de/pubs/sosp97/
[Context switch documentation]: https://wiki.osdev.org/Context_Switching