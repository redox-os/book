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
  - [Side Projects](./ch01-07-side-projects.md)
  - [Influences](./ch01-08-influences.md)
  - [Hardware Support](./ch01-09-hardware-support.md)
  - [Important Programs](./ch01-10-important-programs.md)

- [Getting started](./ch02-00-getting-started.md)
  - [Running Redox in a virtual machine](./ch02-01-running-vm.md)
  - [Running Redox on real hardware](./ch02-02-real-hardware.md)
  - [Installing Redox on a drive](./ch02-03-installing.md)
  - [Trying Out Redox](./ch02-04-trying-out-redox.md)
  - [Building Redox](./ch02-05-building-redox.md)
  - [Podman Build](./ch02-06-podman-build.md)
  - [Configuration Settings](./ch02-07-configuration-settings.md)
  - [Downloading packages with pkg](./ch02-08-pkg.md)
  - [Tasks](./ch02-09-tasks.md)
  - [Questions and feedback](./ch02-10-asking-questions.md)

# Architecture and Design

- [Design Overview](./ch03-00-design-overview.md)

- [System Design](./ch04-00-system-design.md)
  - [Microkernels](./ch04-01-microkernels.md)
  - [Redox kernel](./ch04-02-kernel.md)
  - [Boot Process](./ch04-03-boot-process.md)
  - [Memory Management](./ch04-04-memory.md)
  - [Scheduling](./ch04-05-scheduling.md)
  - [System Services in User Space](./ch04-06-user-space.md)
  - [Drivers](./ch04-07-drivers.md)
  - [RedoxFS](./ch04-08-redoxfs.md)
  - [Graphics and Windowing](./ch04-09-graphics-windowing.md)
  - [Security](./ch04-10-security.md)
  - [Features](./ch04-11-features.md)

- [Schemes and Resources](./ch05-00-schemes-resources.md)
  - [Scheme-rooted Paths](./ch05-01-scheme-rooted-paths.md)
  - [Resources](./ch05-02-resources.md)
  - [Schemes](./ch05-03-schemes.md)
  - ["Everything is a File"](./ch05-04-everything-is-a-file.md)
  - [Stitching it all together](./ch05-05-stitching-it-all-together.md)
  - [Scheme Operation](./ch05-06-scheme-operation.md)
  - [Event Scheme](./ch05-07-event-scheme.md)
  - [An Example](./ch05-08-example.md)

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
  - [Working with ARM64](./ch08-04-aarch.md)
    - [Raspberry Pi](./ch08-04-01-raspi.md)
  - [Troubleshooting the Build](./ch08-05-troubleshooting.md)
  - [Build System](./ch08-06-build-system-reference.md)
  - [Build Phases](./ch08-07-build-phases.md)

- [Developing for Redox](./ch09-00-developing-for-redox.md)
  - [Including Programs in Redox](./ch09-01-including-programs.md)
  - [Coding and Building](./ch09-02-coding-and-building.md)
  - [Porting Applications using Recipes](./ch09-03-porting-applications.md)
  - [Porting Case Study](./ch09-04-porting-case-study.md)
  - [Quick Workflow](./ch09-05-quick-workflow.md)
  - [Libraries and APIs](./ch09-06-libraries-apis.md)
  - [Developer FAQ](./ch09-07-developer-faq.md)
  - [References](./ch09-08-references.md)
  - [Continuous Integration](./ch09-09-ci.md)
  - [Performance](./ch09-10-performance.md)

- [Contributing](./ch10-00-contributing.md)

- [Best practices and guidelines](./ch11-00-best-practices.md)
  - [Literate programming](./ch11-01-literate-programming.md)
  - [Writing docs correctly](./ch11-02-writing-docs-correctly.md)
  - [Style](./ch11-03-style.md)
  - [Rusting properly](./ch11-04-rusting-properly.md)
  - [Avoiding Panics](./ch11-05-avoiding-panics.md)
  - [Testing Practices](./ch11-06-testing-practices.md)

- [Using Redox GitLab](./ch12-00-using-redox-gitlab.md)
  - [Signing in to GitLab](./ch12-01-signing-in-to-gitlab.md)
  - [Repository Structure](./ch12-02-repository-structure.md)
  - [Creating Proper Bug Reports](./ch12-03-creating-proper-bug-reports.md)
  - [How to do a pull request properly](./ch12-04-creating-proper-pull-requests.md)
  - [Filing Issues](./ch12-05-filing-issues.md)

- [Communication](./ch13-00-communication.md)
  - [Chat](./ch13-01-chat.md)
