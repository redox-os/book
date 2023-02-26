Advantages of microkernels
==========================

There are quite a lot of advantages (and disadvantages!) to microkernels, a few of which will be covered here.

Modularity and customizability
------------------------------

Monolithic kernels are, well, monolithic. They do not allow as fine-grained control as microkernels. This is due to many essential components being "hard-coded" into the kernel, and thus requiring modifications to the kernel itself (e.g., device drivers).

Microkernels are very modular by nature. You can replace, reload, modify, change, and remove modules, on runtime, without even touching the kernel.

Modern monolithic kernels try to solve this issue using kernel modules but still often require the system to reboot.

Security
--------

Microkernels are undoubtedly more secure than monolithic kernels. The minimality principle of microkernels is a direct consequence of the principle of least privilege, according to which all components should have only the privileges absolutely needed to provide the needed functionality.

Many security-critical bugs in monolithic kernels stem from services and drivers running unrestricted in kernel mode, without any form of protection.

In other words: **in monolithic kernels, drivers can do whatever, without restrictions, when running in ring 0**.

Fewer crashes
-------------

When compared to microkernels, Monolithic kernels tend to be crash-prone. A crashed driver in a Monolithic kernel can crash the whole system whereas with a microkernel there is a separation of concerns which allows the system to handle any crash safely.

In Linux we often see errors with drivers dereferencing bad pointers which ultimately results in kernel panics.

[There is very good documentation in MINIX about how this can be addressed by a microkernel.](http://wiki.minix3.org/doku.php?id=www:documentation:reliability
)
