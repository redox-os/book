# Why Rust?

Why we wrote an operating system in Rust? Why even write in Rust?

Rust has enormous advantages, because for operating systems, security and stability matters a lot.

Since operating systems are such an integrated part of computing, they are the most important piece of software.

There have been numerous bugs and vulnerabilities in Linux, BSD, glibc, Bash, X11, etc. throughout time, simply due to the lack of memory allocation and type safety. Rust does this right, by enforcing memory safety statically.

Design does matter, but so does implementation. Rust attempts to avoid these unexpected memory unsafe conditions (which are a major source of security critical bugs). Design is a very transparent source of issues. You know what is going on, you know what was intended and what was not.

The basic design of the kernel/user-space separation is fairly similar to Unix-like systems, at this point. The idea is roughly the same: you separate kernel and user-space, through strict enforcement by the kernel, which manages system resources.

However, we have an advantage: enforced memory and type safety. This is Rust's strong side, a large number of "unexpected bugs" (for example, undefined behavior) are eliminated at compile-time.

The design of Linux and BSD is secure. The implementation is not. Many bugs in Linux originate in unsafe conditions (which Rust effectively eliminates) like buffer overflows, not the overall design.

We hope that using Rust we will produce a more secure and stable operating system in the end.

### Unsafes

`unsafe` is a way to tell Rust that "I know what I'm doing!", which is often necessary when writing low-level code, providing safe abstractions. You cannot write a kernel without `unsafe`.

In that light, a kernel cannot be 100% verified by the Rust compiler, however the unsafe parts have to be marked with an `unsafe`, which keeps the unsafe parts segregated from the safe code. We seek to eliminate the `unsafe`s where we can, and when we use `unsafe`s, we are extremely careful.

This contrasts with kernels written in C, which cannot make guarantees about security without costly formal analysis.

You can find out more about how `unsafe` works in the [relevant section](https://doc.rust-lang.org/book/ch19-01-unsafe-rust.html) of the Rust book.

