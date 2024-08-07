# Microkernels

The Redox kernel is a microkernel. Microkernels stand out in their design by providing minimal abstractions in kernel-space. Microkernels focus on user-space, unlike Monolithic kernels which focus on kernel-space.

The basic philosophy of microkernels is that any component which *can* run in user-space *should* run in user-space. Kernel-space should only be utilized for the most essential components (e.g., system calls, process separation, resource management, IPC, thread management, etc).

The kernel's main task is to act as a medium for communication and segregation of processes. The kernel should provide minimal abstraction over the hardware (that is, drivers, which can and should run in user-space).

Microkernels are more secure and less prone to crashes than monolithic kernels. This is because most kernel components are moved to user-space and use different memory address spaces, and thus can't do damage to the system. Furthermore, microkernels are extremely maintainable, due to their small code size the number of bugs in the kernel is reduced a lot.

As anything else, microkernels do also have disadvantages.

## Advantages of microkernels

There are quite a lot of advantages (and disadvantages) with microkernels, a few of which will be covered here.

### Better Modularity and Configuration

Monolithic kernels are, well, monolithic. They do not allow fine-grained control as microkernels. This is due to many essential components being "hard-coded" into the kernel, and thus requiring modifications to the kernel itself (e.g., device drivers).

Microkernels are very modular by nature. You can replace, reload, modify, change, and remove modules, on runtime, without even touching the kernel.

Modern monolithic kernels try to solve this issue using kernel modules but still often require the system to reboot.

### Better Security

Microkernels are undoubtedly more secure than monolithic kernels. The minimality principle of microkernels is a direct consequence of the principle of least privilege, according to which all components should have only the privileges absolutely needed to provide the needed functionality.

Many security-critical bugs in monolithic kernels comes from services and drivers running unrestricted in kernel mode, without any form of protection.

In other words: **in monolithic kernels, drivers can do whatever they want, without restrictions, when running in kernel mode**.

### Better Stability

When compared to microkernels, Monolithic kernels tend to be crash-prone. A buggy driver in a Monolithic kernel can crash the whole system because the driver code is running on the same memory address space of the kernel, thus the kernel process can't continue to run (to avoid memory corruption) and crash (kernel panic).

While in a microkernel the drivers run in different memory address spaces (separation of concerns) which allows the system to handle any crash safely.

In Linux, we often see errors with drivers dereferencing bad pointers which ultimately results in kernel panics.

There is very good documentation in [MINIX](http://wiki.minix3.org/doku.php?id=www:documentation:reliability) about how this can be addressed by a microkernel.

### Sane Debugging

In microkernels the kernel components (drivers, filesystems, etc) are moved to user-space, thus bugs on them don't crash the kernel.

This is very important to debug in real hardware, because if a kernel panic happens, the log can't be saved to find the root of the bug.

In monolithic kernels, a bug in kernel component will cause a kernel panic and lock the system (if it happens in real hardware, you can't debug without serial output support)

(Buggy drivers are the main cause of kernel panics)

## Disadvantages of microkernels

### Small Performance Overhead

Any modern operating system needs basic security mechanisms such as virtualization and segmentation of memory. Furthermore any process (including the kernel) has its own stack and variables stored in registers. On [context switch](https://en.wikipedia.org/wiki/Context_switch), that is each time a system call is invoked or any other inter-process communication (IPC) is done, some tasks have to be done, including:

- Saving caller registers, especially the program counter (caller: process invoking syscall or IPC)
- Reprogramming the [MMU](https://en.wikipedia.org/wiki/Memory_management_unit)'s page table (aka [TLB](https://en.wikipedia.org/wiki/Translation_lookaside_buffer))
- Putting CPU in another mode (kernel mode and user mode, also known as ring 0 and ring 3)
- Restoring callee registers (callee: process invoked by syscall or IPC)

These are not inherently slower on microkernels, but microkernels need to perform these operations more frequently. Many of the system functionality is performed by user-space processes, requiring additional context switches.

The performance difference between monolithic and microkernels has been marginalized over time, making their performance comparable. This is partly due to a smaller surface area which can be easier to optimize.

- [Context switch documentation](https://wiki.osdev.org/Context_Switching)
- [Microkernels performance paper](https://os.inf.tu-dresden.de/pubs/sosp97/)

We are working on exciting performance optimizations to minimize the overhead of extra context switches.

## Versus monolithic kernels

Monolithic kernels provide a lot more abstractions than microkernels.

![An illustration](https://upload.wikimedia.org/wikipedia/commons/6/67/OS-structure.svg)

The above illustration from [Wikimedia](https://commons.wikimedia.org/wiki/File:OS-structure.svg), by Wooptoo, License: Public domain) shows how they differ.

## Documentation about the kernel/user-space separation

- [Dual Mode operations in OS](https://www.geeksforgeeks.org/dual-mode-operations-os/)
- [User mode and Kernel mode switching](https://www.geeksforgeeks.org/user-mode-and-kernel-mode-switching/)

## Documentation about microkernels

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
- [Tanenbaum-Torvalds debate](https://en.wikipedia.org/wiki/Tanenbaum%E2%80%93Torvalds_debate)

## A Note On The Current State

Redox has less than 40,000 Rust lines of kernel code. For comparison Minix has ~6,000 C lines of kernel code.

(The above comparison can't be used to argument that Minix is more stable or safe than Redox because of the number of source code lines, because Redox is more advanced than Minix in features, thus more lines of code are expected)

We would like to move more parts of Redox to user-space to get an even smaller kernel.
