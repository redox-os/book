Scheduling on Redox
===================

The Redox kernel uses a scheduling algorithm called [Round Robin Scheduling].

The kernel registers a function called an [interrupt handler] that the CPU calls periodically. This function keeps track of how many times it is called, and will schedule the next process ready for scheduling every 10 "ticks".

[Round Robin Scheduling]: https://wiki.osdev.org/Scheduling_Algorithms#Round_Robin
[interrupt handler]: https://wiki.osdev.org/Interrupts
