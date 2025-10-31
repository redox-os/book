# Programs and Libraries

- Redox is a general-purpose operating system, thus it can run any type of program.

Some programs are interpreted by a runtime for the program's language, such as a script running in the GNU Bash shell or a Python program. Others are compiled into CPU instructions that run on a particular operating system (Redox) and specific hardware (e.g. x86 compatible CPU in 64-bit mode).

- In Redox, the binaries use the standard [ELF](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format) ("Executable and Linkable Format") format.

Programs could directly invoke Redox system calls, but most call library functions that are higher-level and more easy to use. The program is linked with the libraries it needs.

- Most C/C++ programs call functions in a [C Standard Library](https://en.wikipedia.org/wiki/C_standard_library) (libc) such as `fopen()`
- Redox includes a Rust implementation of the C Standard Library called [relibc](https://gitlab.redox-os.org/redox-os/relibc/). This is how programs such as Git and Python can run on Redox. relibc has partial [POSIX compatibility](https://en.wikipedia.org/wiki/C_POSIX_library).
- relibc has Linux functions for libraries and programs
- Rust programs implicitly or explicitly call functions in the [Rust Standard Library](https://doc.rust-lang.org/std/).
- The Rust libstd includes an implementation of its system-dependent parts (such as file access and setting environment variables) for Redox, in `src/libstd/sys/redox`. Most of libstd works in Redox, so many Rust programs can be compiled for Redox.

The Redox [Cookbook](https://gitlab.redox-os.org/redox-os/cookbook) package system contain recipes (software ports) for compiling C, C++ and Rust programs into Redox binaries.

The porting of programs on Redox is done case-by-case, if a program just need small patches, the programmer can modify the Rust crate source code or add `.patch` files on the recipe folder, but if big or dirty patches are needed, Redox create a fork of it on GitLab and rebase for a while in the `redox` branch of the fork (some Redox forks use branches for different versions).

- [OS Internals Documentation](https://wiki.osdev.org/How_kernel,_compiler,_and_C_library_work_together)
- [ELF Documentation](https://wiki.osdev.org/ELF)
