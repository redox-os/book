# Introduction

![Redox OS](assets/redox_light_512.png)

This is the **Redox OS** book, which will go through (almost) everything about Redox: design, philosophy, how it works, how you can contribute, how to deploy Redox, and much more.

*Please note that this book is a work in progress.*

If you want to skip straight to trying out Redox, see [Getting started](./ch02-00-getting-started.md).

If you want to contribute to Redox, read these guides: [CONTRIBUTING.md](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/CONTRIBUTING.md), [Low-Hanging Fruit](./ch10-01-low-hanging-fruit.md) and [Developing for Redox](./ch07-00-developing-overview.md).

## What is Redox?

Redox OS is a general purpose operating system written in [Rust](https://www.rust-lang.org). Our aim is to provide a fully functioning Unix-like microkernel, that is both secure and free.

We have modest compatibility with [POSIX](https://en.wikipedia.org/wiki/POSIX), allowing Redox to run many programs without porting.

We take inspiration from [Plan 9](http://9p.io/plan9/index.html), [Minix](http://www.minix3.org/), [Linux](https://www.kernel.org/), and [BSD](http://www.bsd.org/). Redox aims to synthesize years of research and hard won experience into a system that feels modern and familiar.

At this time, Redox supports:

* All x86-64 CPUs, and most i686 CPUs since the Pentium II.
* Graphics cards with VBE and/or GOP support (all Nvidia, Intel, and AMD cards from the past decade have this).
* AHCI, IDE, and NVMe disks.
* E1000 or RTL8168 network cards.
* Intel HDA and AC'97 audio controllers.
* Mouse and keyboard with PS/2 emulation.

This book is broken into the following chapters:

### Introduction and Getting Started

- [Introducing Redox](./ch01-00-introducing-redox.md)
- [Getting started](./ch02-00-getting-started.md)

### Architecture and Design

- [Design Overview](./ch03-00-design-overview.md)
- [The kernel](./ch04-00-kernel.md)
- [URLs, schemes and resources](./ch05-00-urls-schemes-resources.md)
- [Programs and Libraries](./ch06-00-programs-libraries.md)

### Developing with and for Redox

- [Developing Overview](./ch07-00-developing-overview.md)
- [The Redox Build Process](./ch08-00-build-process.md)
- [Developing for Redox](./ch09-00-developing-for-redox.md)
- [Best practices and guidelines](./ch11-00-best-practices.md)
- [Using Redox GitLab](./ch12-00-using-redox-gitlab.md)
- [Chat](./ch13-01-chat.md)
 

It is written such that you do not need any prior knowledge in Rust and/or OS development.
