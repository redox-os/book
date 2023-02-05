# The Redox Operating-System

[Introduction](./ch00-00-introduction.md)

# Introduction and Getting Started

- [Introducing Redox](./ch01-00-introducing-redox.md)
  - [Our Goals](./ch01-01-our-goals.md)
  - [Our Philosophy](./ch01-02-philosophy.md)
  - [Why a New OS?](./ch01-03-why-a-new-os.md)
  - [Redox Use Cases](./ch01-04-redox-use-cases.md)
  - [Comparing Redox to Other OSes](./ch01-05-how-redox-compares.md)
  - [Why Rust?](./ch01-06-why-rust.md)
  - [Side projects](./ch01-07-side-projects.md)

- [Getting started](./ch02-00-getting-started.md)
  - [Running Redox in a virtual machine](./ch02-01-running-vm.md)
  - [Running Redox on real hardware](./ch02-02-real-hardware.md)
  - [Installing Redox on a drive](./ch02-03-installing.md)
  - [Trying Out Redox](./ch02-04-trying-out-redox.md)
  - [Building Redox](./ch02-05-building-redox.md)
  - [Podman Build](./ch02-06-podman-build.md)
  - [Configuration Settings](./ch02-07-configuration-settings.md)
  - [Questions and feedback](./ch02-08-asking-questions.md)

# Architecture and Design

- [Design Overview](./ch03-00-design-overview.md)

- [The kernel](./ch04-00-kernel.md)
  - [Microkernels](./ch04-01-microkernels.md)
  - [Advantages of microkernels](./ch04-02-advantages.md)
  - [Disadvantages of microkernels](./ch04-03-disadvantages.md)
  - [Boot Process](./ch04-04-boot-process.md)
  - [Drivers](./ch04-05-drivers.md)
  - [Memory management](./ch04-06-memory.md)
  - [Scheduling](./ch04-07-scheduling.md)

- [URLs, schemes and resources](./ch05-00-urls-schemes-resources.md)
  - [URLs](./ch05-01-urls.md)
  - [How it works under the hood](./ch05-02-how-it-works.md)
  - [Schemes](./ch05-03-schemes.md)
  - [The root scheme](./ch05-04-root-scheme.md)
  - [Resources](./ch05-05-resources.md)
  - [Stitching it all together](./ch05-06-stitching-it-all-together.md)
  - ["Everything is a URL"](./ch05-07-everything-is-a-url.md)
  - [An example](./ch05-08-example.md)

- [Programs and Libraries](./ch06-00-programs-libraries.md)
  - [Components](./ch06-01-components.md)
  - [GUI](./ch06-02-gui.md)
  - [Shell](./ch06-03-shell.md)
  - [System Tools](./ch06-04-system-tools.md)

# Developing with and for Redox

- [Developing Overview](./ch07-00-developing-overview.md)

- [The Redox Build Process](./ch08-00-build-process.md)
  - [Advanced Build](./ch08-01-advanced-build.md)
  - [Advanced Podman Build](./ch08-02-advanced-podman-build.md)
  - [Working with i686](./ch08-03-i686.md)
  - [Working with AArch64/Arm64](./ch08-04-aarch.md)
  - [Troubleshooting the Build](./ch08-05-troubleshooting.md)

- [Developing for Redox](./ch09-00-developing-for-redox.md)
  - [Including Programs in Redox](./ch09-01-including-programs.md)
  - [Coding and Building](./ch09-02-coding-and-building.md)

- [Contributing](./ch10-00-contributing.md)
  - [Low hanging fruit](./ch10-02-low-hanging-fruit.md)
  - [Book ToDos](./ch10-03-book-todos.md)

- [Best practices and guidelines](./ch11-00-best-practices.md)
  - [Literate programming](./ch11-01-literate-programming.md)
  - [Writing docs correctly](./ch11-02-writing-docs-correctly.md)
  - [Style](./ch11-03-style.md)
  - [Rusting properly](./ch11-04-rusting-properly.md)
  - [Avoiding panics in the kernel](./ch11-05-avoiding-kernel-panics.md)

- [Using Redox GitLab](./ch12-00-using-redox-gitlab.md)
  - [Signing in to GitLab](./ch12-01-signing-in-to-gitlab.md)
  - [Repository Structure](./ch12-02-repository-structure.md)
  - [Creating Proper Bug Reports](./ch12-03-creating-proper-bug-reports.md)
  - [How to do a pull request properly](./ch12-04-creating-proper-pull-requests.md)

- [Communication](./ch13-00-communication.md)
  - [Chat](./ch13-01-chat.md)
  - [Reddit](./ch13-02-reddit.md)
  - [GitLab issues](./ch13-03-gitlab-issues.md)
  - [Community](./ch13-04-community.md)
