# What is Redox?

Redox is a general purpose operating system written in pure [Rust]. Our aim is to provide a fully functioning Unix-like microkernel, that is both secure and free.

We have modest compatibility with [POSIX], allowing Redox to run many programs without porting.

We take inspiration from [Plan9], [Minix], [Linux], and [BSD]. Redox aims to synthesize years of research and hard won experience into a system that feels modern and familiar. 

At this time, Redox supports:

* All x86-64 CPUs.
* Graphics cards with VBE support (all Nvidia, Intel, and AMD cards from the past decade have this).
* AHCI disks.
* E1000 or RTL8168 network cards.
* Intel HDA audio controllers.
* Mouse and keyboard with PS/2 emulation.
*TODO: update*

This book is broken into the following chapters:

*TODO*

It is written such that you do not need any prior knowledge in Rust and/or OS development.

[Rust]:  https://www.rust-lang.org
[POSIX]: https://en.wikipedia.org/wiki/POSIX
[Plan9]: http://9p.io/plan9/index.html
[Minix]: http://www.minix3.org/
[Linux]: https://www.linuxfoundation.org
[BSD]: http://www.bsd.org/

[Design]: ../design/design.html
[Overview]: ./welcome.html
[Introduction]: ../introduction/why_redox.html
[Getting started]: ../getting_started/preparing_the_build.html
[The design]: ../design/design.html
[Contributing]: ../contributing/chat.html

