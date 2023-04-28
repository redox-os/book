# Redox kernel

System calls are generally simple, and have a similar ABI compared to regular function calls. On x86_64, it simply uses the `syscall` instruction, causing a mode switch from user mode (ring 3) to kernel mode (ring 0), and when the syscall handler is finished, it mode switches back, as if the `syscall` instruction was a regular `call` instruction, using `sysretq`.

- [System calls documentation](https://docs.rs/redox_syscall/latest/syscall/)
