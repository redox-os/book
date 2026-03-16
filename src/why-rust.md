# Why Rust?

Why did we write an operating system in Rust? Why even write in Rust?

Rust has enormous advantages, because for operating systems, security and stability matters a lot.

Since operating systems are such an integrated part of computing, they are the most important piece of software.

There have been numerous bugs and security vulnerabilities in Linux, BSDs, glibc, GNU Bash, X11, etc. throughout time, simply due to the lack of memory-safety and type-safety. Rust does this right, by enforcing memory and type safety statically (compile-time verification).

Design does matter, but so does implementation. Rust attempts to avoid these unexpected unsafe memory conditions (which are a major source of security critical bugs). Design is a very transparent source of issues. You know what is going on, you know what was intended and what was not.

The basic design of the kernel/user-space separation is fairly similar to Unix-like systems, at this point. The idea is roughly the same: you separate kernel and user-space, through strict enforcement by the kernel (permission system with small attack surface) and CPU (memory address space isolation), which manages system resources.

However, we have an advantage: enforced memory and type safety. This is Rust's strong side, a large number of "unexpected bugs" (for example, undefined behavior) are eliminated with compile-time verification.

The design of Linux and BSD is secure, the implementation is not. Many bugs in Linux originate in unsafe conditions (which Rust effectively eliminates) like buffer overflows, not the overall design.

We hope that using Rust we will produce a more secure and stable operating system in the end.

## Unsafes

`unsafe` is a way to tell Rust that "I know what I'm doing!", which is often necessary when writing low-level code, providing safe abstractions. You cannot write a kernel without `unsafe`.

In that light, a kernel cannot be 100% verified by the Rust compiler, however the unsafe parts have to be marked with an `unsafe`, which keeps the unsafe parts segregated from the safe code. We seek to eliminate the `unsafe`s where we can, and when we use `unsafe`s, we are extremely careful.

This contrasts with kernels written in C, which cannot make guarantees about security without costly formal analysis.

You can find out more about how `unsafe` works in the [relevant section](https://doc.rust-lang.org/book/ch19-01-unsafe-rust.html) of the Rust book.

## Benefits

The following sections explain the Rust benefits.

### Less likely to have bugs

The restrictive syntax and compiler requirements to build the code reduce the probability of bugs a lot.

The borrow checker verifies all memory allocation at compile-time which eliminate most memory bugs, like buffer overflows or dangling pointers.

The type system verifies invalid type usage at compile-time and allow the creation of new types to invalidate logic states that aren't allowed, which eliminate some logic bugs and reduce the formal verification effort.

### Less vulnerable to data corruption

The Rust compiler helps the programmer to avoid memory errors and race conditions, which reduces the probability of data corruption bugs.

### No need for memory exploit mitigations

The microkernel design written in Rust protects against memory defects that one might see in software written in C/C++, which reduces the system complexity by not using memory exploit mitigations.

By isolating the system components from the kernel, the [attack surface](https://en.wikipedia.org/wiki/Attack_surface) is very limited.

### Improved security and reliability without significant performance impact

As the kernel is small, it uses less memory to do its work. The limited kernel code size helps us to achieve a possible bug-free status ([KISS](https://en.wikipedia.org/wiki/KISS_principle)).

Rust's safe and fast language design, combined with the small kernel code size, helps ensure a reliable, performant and easy to maintain the system core.

### Thread-safety

The C/C++ support for thread-safety is quite fragile. As such, it is very easy to write a program that looks safe to run across multiple CPU threads, but which introduces subtle bugs or security holes. If one thread accesses a piece of state at the same time that another thread is changing it, the whole program can exhibit some truly confusing and bizarre bugs.

You can see [this example](https://en.wikipedia.org/wiki/Time_of_check_to_time_of_use) of a serious class of security bugs that thread-safety fixes.

In Rust, this kind of bug is easy to avoid: the same type system that prevent us from writing memory mistakes also prevents us from writing dangerous concurrent access patterns

### Rust-written Drivers

Drivers written in Rust reduces the probability of bugs, which increases their stability and security.
