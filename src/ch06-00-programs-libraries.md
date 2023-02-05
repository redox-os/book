Programs and Libraries
======================

Redox can run programs. Some programs are interpreted by a runtime for the program's language, such as a script running in the Ion shell or a Python program. Others are compiled into machine instructions that run on a particular operating system (Redox) and specific hardware (e.g. x86 compatible CPU in 64-bit mode).
* In Redox compiled binaries use the standard [ELF](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format) ("Executable and Linkable Format") format.

Programs could directly invoke Redox syscalls, but most call library functions that are higher-level and more comfortable to use. You link your program with the libraries it needs.
* Redox does not support dynamic-link libraries yet ([issue #927](https://gitlab.redox-os.org/redox-os/redox/issues/927)), so the libraries that a program uses are statically linked into its compiled binary.
* Most C and C++ programs call functions in a [C standard library](https://en.wikipedia.org/wiki/C_standard_library) ("libc") such as `fopen`
  * Redox includes a Rust implementation of the Standard C library called [relibc](https://gitlab.redox-os.org/redox-os/relibc/). This is how programs such as git can run on Redox. relibc has some POSIX compatibility.
* Rust programs implicitly or explicitly call functions in the Rust standard library (libstd).
  * The Rust libstd now includes an implementation of its system-dependent parts (such as file access and setting environment variables) for Redox, in `src/libstd/sys/redox`. Most of libstd works in Redox, so many command-line Rust programs can be compiled for Redox.

The Redox ["cookbook" project](https://gitlab.redox-os.org/redox-os/cookbook) includes recipes for compiling C and Rust projects into Redox binaries.

- [OS internals documentation]
- [ELF documentation]

[OS internals documentation]: https://wiki.osdev.org/How_kernel,_compiler,_and_C_library_work_together
[ELF documentation]: https://wiki.osdev.org/ELF
