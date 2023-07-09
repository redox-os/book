# Introduction

![Redox OS](assets/redox_light_512.png)

This is the **Redox OS** book, which will go through (almost) everything about Redox: design, philosophy, how it works, how you can contribute, how to deploy Redox, and much more.

*Please note that this book is a work in progress.*

If you want to skip straight to trying out Redox, see [Getting started](./ch02-00-getting-started.md).

If you want to contribute to Redox, read these guides: [CONTRIBUTING](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/CONTRIBUTING.md) and [Developing for Redox](./ch07-00-developing-overview.md).

## What is Redox?

Redox OS is a general purpose operating system written in [Rust](https://www.rust-lang.org). Our aim is to provide a fully functioning Unix-like microkernel, that is both secure and free.

We have modest compatibility with [POSIX](https://en.wikipedia.org/wiki/POSIX), allowing Redox to run many programs without porting.

We take inspiration from [Plan 9](http://9p.io/plan9/index.html), [Minix](http://www.minix3.org/), [Linux](https://www.kernel.org/), and [BSD](http://www.bsd.org/). Redox aims to synthesize years of research and hard won experience into a system that feels modern and familiar.

This book is written in a way that you don't need any prior knowledge in Rust and/or OS development.
