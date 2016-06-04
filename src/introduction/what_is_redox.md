What is Redox?
==============

You might still have the question: What is Redox actually?

Redox is an attempt to make a complete, fully-functioning, general-purpose operating system with a focus on safety, freedom, reliability, correctness, and pragmatism.

The goals of Redox
------------------

We want to be able to use it, without obstructions, as a alternative to Linux on our computers. It should be able to run most Linux programs with only minimal modifications. (see [Why Free Software])

We're aiming towards a complete, safe Rust ecosystem. This is a design choice, which hopefully improves correctness and security (see [Why Rust]).

We want to improve the security design when compared to other Unix-like kernels by using safe defaults and disallowing insecure configurations where possible.

The non-goals of Redox
----------------------

We are not a Linux clone, or POSIX-compliant, nor are we crazy scientists, who wish to redesign everything. Generally, we stick to well-tested and proven correct designs. If it ain't broken don't fix it.

This means that a large number of standard programs and libraries will be compatible with Redox. Some things that do not align with our design decisions will have to be ported.

The key here is the trade off between correctness and compatibility. Ideally, you should be able achieve both, but unfortunately, you can't always do so.

[Why Free Software]: ./introduction/why_free_software.html
[Why Rust]: ./introduction/why_rust.html
