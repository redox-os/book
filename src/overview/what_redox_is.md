What Redox is
=============

Redox is a general purpose operating system and surrounding ecosystem written in pure [Rust]. Our aim is to provide a fully functioning Unix-like microkernel, that is both secure and free.

We have modest compatibility with [POSIX], allowing Redox to run many programs without porting.

We take inspiration from [Plan9], [Minix], [Linux], and [BSD]. We are trying to generalize various concepts from other systems, to get one unified design. We will speak about this some more in the [Design] chapter.

Redox runs on real hardware today.

This book is broken into 8 parts:

- [Overview]: A quick'n'dirty overview of Redox.
- [Introduction]: Explanation of what Redox is and how it compares to other systems.
- [Getting started]: Compiling and running Redox.
- [The design]: An in-depth introduction to the design and implementation of Redox.
- Development in user space: Writing applications for Redox.
- [Contributing]: How you can contribute to Redox.
- Understanding the codebase: For familiarizing yourself with the codebase.
- Fun: Top secret chapter.
- The future: What Redox aims to be.

It is written such that you do not need any prior knowledge in Rust and/or OS development.

[Rust]: https://rust-lang.org  
[POSIX]: https://en.wikipedia.org/wiki/POSIX
[Plan9]: http://plan9.bell-labs.com/plan9/index.html
[Minix]: http://www.minix3.org/
[Linux]: https://en.wikipedia.org/wiki/Linux
[BSD]: http://www.bsd.org/

[Design]: ./design/design.html
[Overview]: ./overview/welcome.html
[Introduction]: ./introduction/why_redox.html
[Getting started]: ./getting_started/preparing_the_build.html
[The design]: ./design/design.html
[Contributing]: ./contributing/chat.html
