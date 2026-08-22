# Scheduling on Redox

TODO: update to EEVDF scheduler and write a short explanation of how it works on Redox

The Redox kernel uses a scheduling algorithm called [Round Robin](https://wiki.osdev.org/Scheduling_Algorithms#Round_Robin).

The kernel registers a function called an [interrupt handler](https://wiki.osdev.org/Interrupts) that the CPU calls periodically. This function keeps track of how many times it is called, and will schedule the next process ready for scheduling every 10 "ticks".

- [Scheduling documentation](https://wiki.osdev.org/Scheduling_Algorithms)
