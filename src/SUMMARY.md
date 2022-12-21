# The Redox Operating-System

# Introduction and Getting Started

- [Introduction](./ch01-01-welcome.md)
  - [What is Redox?](./ch01-02-what-is-redox.md)
  - [Our Goals](./ch01-03-our-goals.md)
  - [Our Philosophy](./ch01-04-philosophy.md)
  - [Why a New OS?](./ch01-05-why-redox.md)
  - [Comparing Redox to Other OSes](./ch01-06-how-redox-compares.md)
  - [Why Rust?](./ch01-07-why-rust.md)
  - [Side projects](./ch01-08-side-projects.md)

- [Getting started](./ch02-01-getting-started.md)
  - [Running Redox in a virtual machine](./ch02-02-running-vm.md)
  - [Running Redox on real hardware](./ch02-03-real-hardware.md)
  - [Installing Redox on a drive](./ch02-04-installing.md)
  - [Trying Out Redox](./ch02-11-trying-out-redox.md)
  - [Building Redox](./ch02-05-building-redox.md)
  - [Podman Build](./ch02-08-podman-build.md)
  - [Configuration Settings](./ch02-06-configuration-settings.md)
  - [Questions and feedback](./ch02-12-asking-questions.md)

# Architecture and Design

- [The kernel](./ch04-12-kernel.md)
  - [Microkernels](./ch04-13-microkernels.md)
  - [Advantages of microkernels](./ch04-14-advantages.md)
  - [Disadvantages of microkernels](./ch04-15-disadvantages.md)
  - [Boot Process](./ch03-02-boot-process.md)
  - [Drivers](./ch04-18-drivers.md)
  - [Memory management](./ch04-17-memory.md)
  - [Scheduling](./ch04-16-scheduling.md)

- [URLs, schemes and resources](./ch04-03-urls-schemes-resources.md)
  - [URLs](./ch04-04-urls.md)
  - [How it works under the hood](./ch04-05-how-it-works.md)
  - [Schemes](./ch04-06-schemes.md)
  - [The root scheme](./ch04-07-the-root-scheme.md)
  - [Resources](./ch04-08-resources.md)
  - [Stitching it all together](./ch04-09-stitching-it-all-together.md)
  - ["Everything is a URL"](./ch04-10-everything-is-a-url.md)
  - [An example](./ch04-11-example.md)

- [Programs and Libraries](./ch04-19-programs-libraries.md)
  - [Components](./ch04-02-components.md)
  - [GUI](./ch03-04-gui.md)
  - [What Ion is](./ch05-05-ion.md)
  - [Shell](./ch03-03-shell.md)
  - [Coreutils](./ch04-20-coreutils.md)
  - [Supplement utilities](./ch04-21-supplement.md)
  - [Binutils](./ch04-22-binutils.md)
  - [Extrautils](./ch04-23-extrautils.md)

# Developing with and for Redox

- [The Redox Build Process](./todo.md)
  - [Advanced Build](./ch02-07-advanced-build.md)
  - [Advanced Podman Build](./todo.md)
  - [Working with i686](./ch02-09-i686.md)
  - [Working with AArch64/Arm64](./ch02-10-aarch.md)
  - [Troubleshooting the Build](./ch05-03-troubleshooting.md)

- [Developing for Redox](./ch05-01-developing-for-redox.md)
  - [Including Programs in Redox](./ch05-02-including-programs.md)
  - [Coding and Building](./ch05-04-coding-and-building.md)

- [Contributing](./ch06-01-contributing.md)
  - [Direct contributions](./ch06-05-direct-contributions.md)
  - [Low hanging fruit](./ch06-06-low-hanging-fruit.md)

- [Best practices and guidelines](./ch06-12-best-practices.md)
  - [Literate programming](./ch06-13-literate-programming.md)
  - [Writing docs correcty (TM)](./ch06-14-writing-docs-correctly.md)
  - [Style](./ch06-15-style.md)
  - [Rusting properly](./ch06-16-rusting-properly.md)
  - [Avoiding panics in the kernel](./ch06-17-avoiding-kernel-panics.md)

- [Using Git](./todo.md)
  - [How to do a bug report correctly](./ch06-08-creating-proper-bug-reports.md)
  - [Pull requests](./ch06-09-pull-requests.md)
  - [How to do a pull request properly](./ch06-10-creating-proper-pull-requests.md)
  - [Git Guidelines](./ch06-18-git-guidelines.md)

- [Communication](./ch06-02-communication.md)
  - [Chat](./ch06-03-chat.md)
  - [Reddit](./ch06-04-reddit.md)
  - [GitLab issues](./ch06-07-gitlab-issues.md)
  - [Community](./ch06-11-community.md)
