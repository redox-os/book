# Introduction

<img class="redox-logo" width=511 height=180/>

This is the **Redox OS** book, which will go through (almost) everything about Redox: design, philosophy, how it works, how you can contribute, how to deploy Redox, and much more.

*Please note that this book is work-in-progress.*

If you want to skip straight to trying out Redox, see [Getting started](./getting-started.md).

If you want to contribute to Redox, read these guides: [CONTRIBUTING](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/CONTRIBUTING.md) and [Developing for Redox](./developing-overview.md).

## What is Redox?

Redox OS is a general-purpose operating system written in [Rust](https://www.rust-lang.org). Our aim is to provide a fully functioning Unix-like microkernel-based operating system, that is secure, reliable and free.

We have modest compatibility with [POSIX](https://en.wikipedia.org/wiki/POSIX), allowing Redox to run many programs without porting.

We take inspiration from [Plan 9](http://9p.io/plan9/index.html), [Minix](http://www.minix3.org/), [seL4](https://sel4.systems/), [Linux](https://www.kernel.org/), [OpenBSD](https://openbsd.org) and [FreeBSD](https://freebsd.org). Redox aims to synthesize years of research and hard won experience into a system that feels modern and familiar.

This book is written in a way that you don't need any prior knowledge in Rust or OS development.
