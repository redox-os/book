# Introduction

<img class="redox-logo" width=511 height=180/>

This is the **Redox OS** book, which will go through (almost) everything about Redox: design, philosophy, how it works, how you can contribute, how to deploy Redox, and much more.

**Please keep in mind that this book is work-in-progress and sometimes can be outdated, any help to improve it is important.**

If you want to skip straight to trying out Redox, see the [Getting started](./getting-started.md) page.

If you want to contribute to Redox, read the following guides: [CONTRIBUTING](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/CONTRIBUTING.md) and [Developing for Redox](./developing-for-redox.md).

## Conventions

### Notices

The following notices are commonly used throughout the book to convey noteworthy information:

| Notice     | Meaning |
|:---------- |:------- |
| 🛈 **Info**    | Provides neutral information to deliver key facts. |
| 📝 **Note**    | Provides information to enhance understanding. |
| 💡 **Tip**     | Offers suggestions to optimize an experience. |
| ⚠️ **Warning** | Highlights potential risks or mistakes. |

## What is Redox?

Redox OS is a general-purpose operating system written in [Rust](https://www.rust-lang.org). Our aim is to provide a fully functioning Unix-like microkernel-based operating system, that is secure, reliable and free.

We have modest compatibility with [POSIX](https://en.wikipedia.org/wiki/POSIX), allowing Redox to run many programs without porting.

We take inspiration from [Plan 9](http://9p.io/plan9/index.html), [Minix](http://www.minix3.org/), [seL4](https://sel4.systems/), [Linux](https://www.kernel.org/), [OpenBSD](https://openbsd.org) and [FreeBSD](https://freebsd.org). Redox aims to synthesize years of research and hard won experience into a system that feels modern and familiar.

This book is written in a way that you doesn't require any prior knowledge of Rust or OS development.

### Origin Story

Redox OS was created in 2015 before the first stable version (1.0) of the Rust compiler and was one of the first operating systems written in Rust.
It started as an unikernel (without a hypervisor) and gathered the contributions of many Rust developers.

As the project progressed, Jeremy Soller decided that the OS should be focused on stability and security.
To achieve that, Redox was redesigned to adopt a microkernel architecture and a unified system API for resources.

Minix and Plan 9 were the main inspirations for the system design in the beginning.
