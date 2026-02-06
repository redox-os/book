# The Redox Operating-System

[Introduction](./introduction.md)

# Introduction

- [Introducing Redox](./introducing-redox.md)
  - [Our Goals](./our-goals.md)
  - [Our Philosophy](./philosophy.md)
  - [Why a New OS?](./why-a-new-os.md)
  - [Why Rust?](./why-rust.md)
  - [Redox Use Cases](./redox-use-cases.md)
  - [Comparing Redox to Other OSes](./how-redox-compares.md)
  - [Influences](./influences.md)
  - [Hardware Support](./hardware-support.md)
  - [Important Programs](./important-programs.md)
  - [Side Projects](./side-projects.md)

# Architecture and Design

- [System Design](./system-design.md)
  - [Microkernels](./microkernels.md)
  - [Boot Process](./boot-process.md)
  - [Redox kernel](./kernel.md)
  - [System Services in User Space](./user-space.md)
  - [Communication](./communication.md)
  - [Memory Management](./memory.md)
  - [Scheduling](./scheduling.md)
  - [Drivers](./drivers.md)
  - [RedoxFS](./redoxfs.md)
  - [Graphics and Windowing](./graphics-windowing.md)
  - [Security](./security.md)
  - [Features](./features.md)
  - [Package Management](./package-management.md)

- [Schemes and Resources](./schemes-resources.md)
  - [Scheme-rooted Paths](./scheme-rooted-paths.md)
  - [Resources](./resources.md)
  - [Schemes](./schemes.md)
  - ["Everything is a File"](./everything-is-a-file.md)
  - [Stitching It All Together](./stitching-it-all-together.md)
  - [Scheme Operation](./scheme-operation.md)
  - [Event Scheme](./event-scheme.md)
  - [An Example](./example.md)

- [Programs and Libraries](./programs-libraries.md)
  - [Components](./components.md)
  - [GUI](./gui.md)
  - [Shell](./shell.md)
  - [System Tools](./system-tools.md)

# Getting Started

- [Getting started](./getting-started.md)
  - [Running Redox in a Virtual Machine](./running-vm.md)
  - [Running Redox on Real Hardware](./real-hardware.md)
  - [Installing Redox on a Drive](./installing.md)
  - [Trying Out Redox](./trying-out-redox.md)
  - [Tasks](./tasks.md)
  - [Downloading Packages with pkg](./pkg.md)

# Contributing

- [Contributing](./contributing.md)
  - [Chat](./chat.md)

- [Best practices and guidelines](./best-practices.md)
  - [Literate programming](./literate-programming.md)
  - [Writing docs correctly](./writing-docs-correctly.md)
  - [Style](./style.md)
  - [Rusting properly](./rusting-properly.md)
  - [Avoiding Panics](./avoiding-panics.md)
  - [Testing](./testing-practices.md)

- [Using Redox GitLab](./using-redox-gitlab.md)
  - [Signing in to GitLab](./signing-in-to-gitlab.md)
  - [Repository Structure](./repository-structure.md)
  - [Creating Proper Bug Reports](./creating-proper-bug-reports.md)
  - [Creating Proper Pull Requests](./creating-proper-pull-requests.md)
  - [Filing Issues](./filing-issues.md)

# Developing with and for Redox

- [The Redox Build Process](./build-process.md)
  - [Building Redox](./podman-build.md)
  - [Native Build](./building-redox.md)
  - [From Nothing To Hello World](./nothing-to-hello-world.md)
  - [Configuration Settings](./configuration-settings.md)
  - [Build System Reference](./build-system-reference.md)
  - [Advanced Podman Build](./advanced-podman-build.md)
  - [Advanced Native Build](./advanced-build.md)
  - [Working with i586](./i686.md)
  - [Working with ARM64](./aarch64.md)
  - [Raspberry Pi](./raspi.md)
  - [Troubleshooting the Build](./troubleshooting.md)
  - [Build Process](./build-phases.md)

- [Developing for Redox](./developing-for-redox.md)
  - [Developer FAQ](./developer-faq.md)
  - [References](./references.md)
  - [Libraries and APIs](./libraries-apis.md)
  - [Coding and Building](./coding-and-building.md)
  - [Including Programs in Redox](./including-programs.md)
  - [Application Porting](./porting-applications.md)
  - [Porting Case Study](./porting-case-study.md)
  - [Continuous Integration](./ci.md)
  - [Performance](./performance.md)
  - [System Call Tracing](./syscall-debug.md)
  - [Quick Workflow](./quick-workflow.md)
  - [Questions and Feedback](./asking-questions.md)
