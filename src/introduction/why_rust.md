Why Rust?
=========

Why write an operating system in Rust? Why even write in Rust?

Rust has enormous advantages, because for operating systems, _safety matters_. A lot, actually.

Since operating systems are such an integrated part of computing, they are a very security critical component.

There have been numerous bugs and vulnerabilities in Linux, BSD, Glibc, Bash, X, etc. throughout time, simply due to the lack of memory and type safety. Rust does this right, by enforcing memory safety statically.

Design does matter, but so does implementation. Rust attempts to avoid these unexpected memory unsafe conditions (which are a major source of security critical bugs). Design is a very transparent source of issues. You know what is going on, you know what was intended and what was not.

The basic design of the kernel/user space separation is fairly similar to Unix-like systems, at this point. The idea is roughly the same: you separate kernel and user space, through strict enforcement by the kernel, which manages memory and other critical resources.

However, we have an advantage: enforced memory and type safety. This is Rust's strong side -- a large number of "unexpected bugs" (for example, undefined behavior) are eliminated at compile time.

The design of Linux and BSD is secure. The implementation is not:

- [Linux kernel vulnerabilities]
- [Glibc vulnerabilities]
- [Bash vulnerabilities]
- [X vulnerabilities]

Click on the above links. You'll probably notice that many are bugs originating in unsafe conditions (which Rust effectively eliminates) like buffer overflows, not the overall design.

We hope that using Rust will produce a more secure operating system in the end.

### Unsafes

`unsafe` is a way to tell Rust that "I know what I'm doing!", which is often necessary when writing low-level code, providing safe abstractions. You cannot write a kernel without `unsafe`s.

In that light, a kernel cannot be 100% safe, however the unsafe parts have to be marked with an `unsafe`, which keeps the unsafe parts segregated from the safe code. We seek to eliminate the `unsafe`s where we can, and when we use `unsafe`s, we are extremely careful.

A quick grep gives us some stats: the kernel has about 300 invocations of `unsafe` in about 16,000 lines of code overall. Every one of these is carefully audited to ensure correctness.

This contrasts with kernels written in C, which cannot make guarantees about safety without costly formal analysis.

You can find out more about how `unsafe` works in the [relevant section of the Rust book](https://doc.rust-lang.org/book/ch19-01-unsafe-rust.html).

[Linux kernel vulnerabilities]: https://www.cvedetails.com/vulnerability-list.php?vendor_id=33&product_id=47&version_id=&page=1&hasexp=0&opdos=0&opec=0&opov=0&opcsrf=0&opgpriv=0&opsqli=0&opxss=0&opdirt=0&opmemc=0&ophttprs=0&opbyp=0&opfileinc=0&opginf=0&cvssscoremin=7&cvssscoremax=7.99&year=0&month=0&cweid=0&order=3&trc=269&sha=27cc1be095dd1cc4189b3d337cc787289500c13e

[Glibc vulnerabilities]: https://www.cvedetails.com/vulnerability-list.php?vendor_id=72&product_id=767&version_id=&page=1&hasexp=0&opdos=0&opec=0&opov=0&opcsrf=0&opgpriv=0&opsqli=0&opxss=0&opdirt=0&opmemc=0&ophttprs=0&opbyp=0&opfileinc=0&opginf=0&cvssscoremin=0&cvssscoremax=0&year=0&month=0&cweid=0&order=3&trc=62&sha=5e0c40399ffafd65f77e6b537bcc0f50474eeed3

[Bash vulnerabilities]: http://www.cvedetails.com/vulnerability-list.php?vendor_id=72&product_id=21050&version_id=&page=1&hasexp=0&opdos=0&opec=0&opov=0&opcsrf=0&opgpriv=0&opsqli=0&opxss=0&opdirt=0&opmemc=0&ophttprs=0&opbyp=0&opfileinc=0&opginf=0&cvssscoremin=0&cvssscoremax=0&year=0&month=0&cweid=0&order=3&trc=10&sha=b7da5775428a703fdead6c27fbca76cd40b7c596

[X vulnerabilities]: https://www.cvedetails.com/vulnerability-list.php?vendor_id=8216&product_id=&version_id=&page=1&hasexp=0&opdos=0&opec=0&opov=0&opcsrf=0&opgpriv=0&opsqli=0&opxss=0&opdirt=0&opmemc=0&ophttprs=0&opbyp=0&opfileinc=0&opginf=0&cvssscoremin=0&cvssscoremax=0&year=0&month=0&cweid=0&order=3&trc=55&sha=a68a1ced1b67444749733b7fa9e1438ff0c42810

