# Programs and Libraries

Redox is a general-purpose operating system, thus can run any program.

Some programs are interpreted by a runtime for the program's language, such as a script running in the Ion shell or a Python program. Others are compiled into CPU instructions that run on a particular operating system (Redox) and specific hardware (e.g. x86 compatible CPU in 64-bit mode).

- In Redox, the binaries use the standard [ELF](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format) ("Executable and Linkable Format") format.

Programs could directly invoke Redox syscalls, but most call library functions that are higher-level and more comfortable to use. You link your program with the libraries it needs.

- Most C/C++ programs call functions in a [C Standard Library](https://en.wikipedia.org/wiki/C_standard_library) (libc) such as `fopen`.
- Redox includes a Rust implementation of the standard C library called [relibc](https://gitlab.redox-os.org/redox-os/relibc/). This is how programs such as Git and Python can run on Redox. relibc has some [POSIX compatibility](https://en.wikipedia.org/wiki/C_POSIX_library).
- Rust programs implicitly or explicitly call functions in the [Rust standard library](https://doc.rust-lang.org/std/).
- The Rust libstd now includes an implementation of its system-dependent parts (such as file access and setting environment variables) for Redox, in `src/libstd/sys/redox`. Most of libstd works in Redox, so many terminal-based Rust programs can be compiled for Redox.

The Redox [Cookbook](https://gitlab.redox-os.org/redox-os/cookbook) package system includes recipes (software ports) for compiling C, C++ and Rust programs into Redox binaries.

The porting of programs on Redox is done case-by-case, if a program just need small patches, the programmer can modify the Rust crate source code or add `.patch` files on the recipe folder, but if big or dirty patches are needed, Redox create a fork of it on GitLab and rebase for a while in the `redox` branch of the fork (some Redox forks use branches for different versions).

- [OS internals documentation](https://wiki.osdev.org/How_kernel,_compiler,_and_C_library_work_together)
- [ELF documentation](https://wiki.osdev.org/ELF)
