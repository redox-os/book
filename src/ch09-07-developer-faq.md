# Developer FAQ

The [website FAQ](https://www.redox-os.org/faq/) have questions and answers of newcomers and end-users, while this FAQ will cover organization, technical questions and answers of developers and testers, feel free to suggest new questions.

(If all else fails, join us on [Chat](./ch13-01-chat.md))

- [General Questions](#general-questions)
    - [What is the correct way to update the build system?](#what-is-the-correct-way-to-update-the-build-system)
    - [How can I verify if my build system is up-to-date?](#how-can-i-verify-if-my-build-system-is-up-to-date)
    - [When I should rebuild the build system or recipes from scratch?](#when-i-should-rebuild-the-build-system-or-recipes-from-scratch)
    - [How can I test my changes on real hardware?](#how-can-i-test-my-changes-on-real-hardware)
    - [How can I write a driver?](#how-can-i-write-a-driver)
    - [How can I port a program?](#how-can-i-port-a-program)
    - [How can I debug?](#how-can-i-debug)
    - [How can I insert files to the QEMU image?](#how-can-i-insert-files-to-the-qemu-image)
    - [How can I change my build variant?](#how-can-i-change-my-build-variant)
    - [How can I increase the filesystem size of my QEMU image?](#how-can-i-increase-the-filesystem-size-of-my-qemu-image)
    - [How can I change the CPU architecture of my build system?](#how-can-i-change-the-cpu-architecture-of-my-build-system)
    - [I only made a small change to my program. What's the quickest way to test it in QEMU?](#i-only-made-a-small-change-to-my-program-whats-the-quickest-way-to-test-it-in-qemu)
    - [How can I install the packages needed by recipes without a new download of the build system?](#how-can-i-install-the-packages-needed-by-recipes-without-a-new-download-of-the-build-system)
    - [How can I use the packages from the CI server on my build system?](#how-can-i-use-the-packages-from-the-ci-server-on-my-build-system)
    - [How can I cross-compile to ARM from a x86-64 computer?](#how-can-i-cross-compile-to-arm-from-a-x86-64-computer)
    - [How can I build the toolchain from source?](#how-can-i-build-the-toolchain-from-source)
    - [Why does Redox have unsafe Rust code?](#why-does-redox-have-unsafe-rust-code)
    - [Why does Redox have Assembly code?](#why-does-redox-have-assembly-code)
    - [Why does Redox do cross-compilation?](#why-does-redox-do-cross-compilation)
    - [Does Redox support OpenGL and Vulkan?](#does-redox-support-opengl-and-vulkan)
- [Porting Questions](#porting-questions)
    - [What is a recipe?](#what-is-a-recipe)
    - [How to determine if some program is portable to Redox?](#how-to-determine-if-some-program-is-portable-to-redox)
    - [How to determine the dependencies of some program?](#how-to-determine-the-dependencies-of-some-program)
    - [How can I configure the build system of the recipe?](#how-can-i-configure-the-build-system-of-the-recipe)
    - [How can I search for functions on relibc?](#how-can-i-search-for-functions-on-relibc)
    - [Which are the upstream requirements to accept my recipe?](#which-are-the-upstream-requirements-to-accept-my-recipe)
- [Scheme Questions](#scheme-questions)
    - [What is a scheme?](#what-is-a-scheme)
    - [When does a regular program need to use a scheme?](#when-does-a-regular-program-need-to-use-a-scheme)
    - [When would I write a program to implement a scheme?](#when-would-i-write-a-program-to-implement-a-scheme)
    - [How do I use a scheme for sandboxing a program?](#how-do-i-use-a-scheme-for-sandboxing-a-program)
    - [How can I see all user-space schemes?](#how-can-i-see-all-user-space-schemes)
    - [How can I see all kernel schemes?](#how-can-i-see-all-kernel-schemes)
    - [What is the difference between kernel and user-space schemes?](#what-is-the-difference-between-kernel-and-user-space-schemes)
- [User-Space Questions](#user-space-questions)
    - [How does a user-space daemon provide file-like services?](#how-does-a-user-space-daemon-provide-file-like-services)
- [Kernel Questions](#kernel-questions)
    - [Which CPU architectures the kernel support?](#which-cpu-architectures-the-kernel-support)
    - [How the system calls are used by user-space daemons?](#how-the-system-calls-are-used-by-user-space-daemons)
- [GitLab Questions](#gitlab-questions)
    - [I have a project/program with breaking changes but my merge request was not accepted, can I maintain the project in a separated repository on the Redox GitLab?](#i-have-a-projectprogram-with-breaking-changes-but-my-merge-request-was-not-accepted-can-i-maintain-the-project-in-a-separated-repository-on-the-redox-gitlab)
    - [I have a merge request with many commits, should I squash them after merge?](#i-have-a-merge-request-with-many-commits-should-i-squash-them-after-merge)
    - [Should I delete my branch after merge?](#should-i-delete-my-branch-after-merge)
    - [How can I have an anonymous account?](#how-can-i-have-an-anonymous-account)
- [Troubleshooting Questions](#troubleshooting-questions)
    - [Scripts](#scripts)
        - [I can't download the bootstrap scripts, how can I fix this?](#i-cant-download-the-bootstrap-scripts-how-can-i-fix-this)
        - [I tried to run the "bootstrap.sh" and "podman_bootstrap.sh" scripts but got an error, how to fix this?](#i-tried-to-run-the-bootstrapsh-and-podman_bootstrapsh-scripts-but-got-an-error-how-to-fix-this)
    - [Build System](#build-system)
        - [I called "make all" but it show a "rustup can't be found" message, how can I fix this?](#i-called-make-all-but-it-show-a-rustup-cant-be-found-message-how-can-i-fix-this)
        - [I tried all troubleshooting methods but my build system is still broken, how can I fix that?](#i-tried-all-troubleshooting-methods-but-my-build-system-is-still-broken-how-can-i-fix-that)
    - [Recipes](#recipes)
        - [I had a compilation error with a recipe, how can I fix that?](#i-had-a-compilation-error-with-a-recipe-how-can-i-fix-that)
        - [I tried all methods of the "Troubleshooting the Build" page and my recipe doesn't build, what can I do?](#i-tried-all-methods-of-the-troubleshooting-the-build-page-and-my-recipe-doesnt-build-what-can-i-do)
        - [When I run "make r.recipe" I get a syntax error, how can I fix that?](#when-i-run-make-rrecipe-i-get-a-syntax-error-how-can-i-fix-that)
        - [When I run "cargo update" on some recipe source it call Rustup to install other Rust toolchain version, how can I fix that?](#when-i-run-cargo-update-on-some-recipe-source-it-call-rustup-to-install-other-rust-toolchain-version-how-can-i-fix-that)
        - [I added the dependency of my program on the "recipe.toml" but the program build system doesn't detect it, then I installed the program dependency on my Linux distribution and it detected, why?](#i-added-the-dependency-of-my-program-on-the-recipetoml-but-the-program-build-system-doesnt-detect-it-then-i-installed-the-program-dependency-on-my-linux-distribution-and-it-detected-why)
    - [QEMU](#qemu)
        - [How can I kill the QEMU process if Redox freezes or get a kernel panic?](#how-can-i-kill-the-qemu-process-if-redox-freezes-or-get-a-kernel-panic)
    - [Real Hardware](#real-hardware)
        - [I got a kernel panic, what can I do?](#i-got-a-kernel-panic-what-can-i-do)
        - [Some driver is not working with my hardware, what can I do?](#some-driver-is-not-working-with-my-hardware-what-can-i-do)

## General Questions

### What is the correct way to update the build system?

- Read [this](./ch08-06-build-system-reference.md#update-the-build-system) page.

### How can I verify if my build system is up-to-date?

- After the `make pull` command, run the `git rev-parse HEAD` command on the build system folders to see if they match the latest commit hash on GitLab.

### When I should rebuild the build system or recipes from scratch?

Sometimes run the `make pull rebuild` command is not enough to update the build system and recipes because of breaking changes, learn what to do on the following changes:

- New relibc functions and fixes (run the `make prefix clean all` command after the `touch relibc` command)
- Dependency changes on recipes (run the `make cr.recipe-name` command)
- Configuration changes on recipes (run the `make cr.recipe-name` command)
- Source code changes on recipes (run the `make ucr.recipe-name` command)
- Changes on the location of the build system artifacts (if the previous location of the build artifacts had contents, you need to download the build system again to avoid confusion or conflicts)

### How can I test my changes on real hardware?

- Read [this](./ch09-02-coding-and-building.md#testing-on-real-hardware) section.

### How can I write a driver?

- Read this [README](https://gitlab.redox-os.org/redox-os/drivers/-/blob/master/README.md).

### How can I port a program?

- Read [this](./ch09-03-porting-applications.md) page.

### How can I debug?

- Read [this](./ch08-05-troubleshooting.md#debug-methods) section.

### How can I insert files to the QEMU image?

- If you use a [recipe](./ch09-02-coding-and-building.md#insert-files-on-the-qemu-image-using-a-recipe) your changes will persist after a `make image` but you can also [mount](./ch09-02-coding-and-building.md#insert-files-on-the-qemu-image) the Redox filesystem.

### How can I change my build variant?

- Insert the `CONFIG_NAME?=your-config-name` environment variable to your `.config` file, read [this](./ch02-07-configuration-settings.md#config) section for more details.

### How can I increase the filesystem size of my QEMU image?

- Change the `filesystem_size` field of your build configuration (`config/ARCH/your-config.toml`) and run `make image`, read [this](./ch02-07-configuration-settings.md#filesystem-size) section for more details.

### How can I change the CPU architecture of my build system?

- Insert the `ARCH?=your-arch-code` environment variable on your `.config` file and run `make all`, read [this](./ch02-07-configuration-settings.md#config) section for more details.

### I only made a small change to my program. What's the quickest way to test it in QEMU?

- If you already added the program recipe to your Cookbook configuration file, run:

```sh
make r.recipe-name image qemu
```

### How can I install the packages needed by recipes without a new download of the build system?

- Download the `bootstrap.sh` script and run:

```sh
./bootstrap.sh -d
```

### How can I use the packages from the CI server on my build system?

- Go to your Cookbook configuration and add the binary variant of the recipe.

```sh
nano config/your-cpu-arch/your-config.toml
```

```toml
[packages]
...
recipe-name = "binary"
...
```

- Run `make rebuild` to download/install the package.

### How can I cross-compile to ARM from a x86-64 computer?

- Insert the `ARCH?=aarch64` environment variable on your `.config` file and run `make all`.

### How can I build the toolchain from source?

- Disable the `PREFIX_BINARY` environment variable inside of your `.config` file.

```sh
nano .config
```

```
PREFIX_BINARY?=0
```

- Wipe the old toolchain binaries and build a new one.

```sh
rm -rf prefix
```

```sh
make prefix
```

- Wipe the old recipe binaries and build again with the new toolchain.

```sh
make clean all
```

### Why does Redox have unsafe Rust code?

It is an important goal for Redox to minimize the amount of `unsafe` Rust code.

In some cases we must use `unsafe`, for example at certain points in the kernel and drivers, these unsafe parts are generally wrapped with a safe interface.

These are the cases where unsafe Rust is mandatory:

- Implementing a foreign function interface (FFI) (for example the relibc API)
- Working with system calls directly (You should use Rust `std::` library or relibc instead)
- Creating or managing processes and threads
- Working with memory mapping and stack allocation
- Working with hardware devices

If you want to use unsafe Rust code on Redox anywhere other than interfacing with system calls, ask for Jeremy Soller's approval before.

### Why does Redox have Assembly code?

[Assembly](https://en.wikipedia.org/wiki/Assembly_language) is the core of low-level because it's a CPU-specific language and deal with things that aren't possible or feasible to do in high-level languages like Rust.

Sometimes required or preferred for accessing hardware, or for carefully optimized hot spots.

Reasons to use Assembly instead of Rust:

- Deal with low-level things (those that can't be handled by Rust)
- Writing constant time algorithms for cryptography
- Optimizations

Places where Assembly is used:

- `kernel` - Interrupt and system call entry routines, context switching, special CPU instructions and registers.
- `drivers` - Port IO need special instructions (x86_64).
- `relibc` - Some parts of the C runtime.

### Why does Redox do cross-compilation?

Read some of the reasons below:

- When developing a new operating system you can't build programs inside of it because the system interfaces are premature. Thus you build the programs on your host system and transfer the binaries to the filesystem of the new OS
- Cross-compilation reduces the porting requirements because you don't need to support the compiler of the program's programming language, the program's build system and build tools. You just need to port the programming language standard library, program libraries or the program source code (dependency-free)
- Some developers prefer to develop from other operating systems like Linux or MacOSX, the same applies for Linux where some developers write code on MacOSX and test their kernel builds in a virtual machine (mostly QEMU) or real hardware

(Interpreted programs and scripts require the programming language interpreter to work on Redox)

### Does Redox support OpenGL and Vulkan?

- Read [this](./ch04-09-graphics-windowing.md#accelerated-graphics) section.

## Porting Questions

### What is a recipe?

- A recipe is a software port on Redox, it does cross-compilation by default if you use Cookbook [templates](./ch09-03-porting-applications.md#templates).

### How to determine if some program is portable to Redox?

- The source code of the program must be available
- The program should use cross-platform libraries (if not, more porting effort is required)
- The program's build system should support cross-compilation (if not, more porting effort is required)
- The program shouldn't directly use the APIs from the Linux kernel on its code (if not, more porting effort is required)
- The program shoudn't use X11 or Wayland directly on its code (if not, more porting effort is required)

Some APIs of the Linux kernel can be ported, while others not because they require a complete Linux kernel (thus the drivers and filesystems code require reverse-engineering to be ported to Redox).

### How to determine the dependencies of some program?

- Read [this](./ch09-03-porting-applications.md#dependencies) section.

### How can I configure the build system of the recipe?

- Read [this](./ch09-03-porting-applications.md#templates) category.

### How can I search for functions on relibc?

- Read [this](./ch09-03-porting-applications.md#search-for-functions-on-relibc) section.

### Which are the upstream requirements to accept my recipe?

- Read [this](./ch09-03-porting-applications.md#package-policy).

## Scheme Questions

### What is a scheme?

- Read [this](./ch05-00-urls-schemes-resources.md) page.

### When does a regular program need to use a scheme?

- Most schemes are used internally by the system or by relibc, you don't need to access them directly. One exception is the pseudoterminal for your command window, which is accessed using the value of `$TTY`, which might have a value of e.g. "pty:18". Some low-level graphics programming might require you to access your display, which might have a value of e.g. "display:3".

### When would I write a program to implement a scheme?

- If you are implementing a service daemon or a device driver, you will need to implement a scheme.

### How do I use a scheme for sandboxing a program?

- The [contain](https://gitlab.redox-os.org/redox-os/contain) program provides a partial implementation of sandboxing using schemes and namespaces.

### How can I see all user-space schemes?

- Read [this](./ch05-03-schemes.md#userspace-schemes) section.

### How can I see all kernel schemes?

- Read [this](./ch05-03-schemes.md#kernel-schemes) section.

### What is the difference between kernel and user-space schemes?

- Read [this](./ch05-03-schemes.md#kernel-vs-userspace-schemes) section.

## User-Space Questions

### How does a user-space daemon provide file-like services?

- When a regular program calls `open`, `read`, `write`, etc. on a file-like resource, the kernel translates that to a message of type `syscall::data::Packet`, describing the file operation, and makes it available for reading on the appropriate daemon's scheme file descriptor. See [this](./ch05-06-scheme-operation.md#providing-a-scheme) section for more information.

## Kernel Questions

### Which CPU architectures the kernel support?

- i686 with limitations
- x86_64
- ARM64 with limitations

### How the system calls are used by user-space daemons?

- All user-space daemons use the system calls through [relibc](https://gitlab.redox-os.org/redox-os/relibc) like any normal program.

## GitLab Questions

### I have a project/program with breaking changes but my merge request was not accepted, can I maintain the project in a separated repository on the Redox GitLab?

- Yes.

### I have a merge request with many commits, should I squash them after merge?

- Yes.

### Should I delete my branch after merge?

- Yes.

### How can I have an anonymous account?

- During the account creation process you should add a fake name on the "First Name" and "Last Name" fields and change it later after your account approval (single name field is supported).

## Troubleshooting Questions

### Scripts

#### I can't download the bootstrap scripts, how can I fix this?

- Verify if you have `curl` installed or download the script from your browser.

#### I tried to run the "bootstrap.sh" and "podman_bootstrap.sh" scripts but got an error, how to fix this?

- Verify if you have the GNU Bash shell installed on your system.

### Build System

#### I called "make all" but it show a "rustup can't be found" message, how can I fix this?

- Run this command:

```sh
source ~/.cargo/env
```

(If you installed Rustup before the first `bootstrap.sh` run, this error doesn't happen)

#### I tried all troubleshooting methods but my build system is still broken, how can I fix that?

- If `make clean pull all` doesn't work, run the `bootstrap.sh` again to download a fresh build system or install Pop OS!, Ubuntu or Debian.

### Recipes

#### I had a compilation error with a recipe, how can I fix that?

- Read [this](./ch08-05-troubleshooting.md#solving-compilation-problems) section.

#### I tried all methods of the "Troubleshooting the Build" page and my recipe doesn't build, what can I do?

- It happens because your system has an environment problem or missing packages, remove the recipe from your build configuration file to workaround this.

All recipes follow this syntax `recipe = {}` below the `[packages]` section, the configuration files is placed at `config/your-arch`.

#### When I run "make r.recipe" I get a syntax error, how can I fix that?

- Verify if your `recipe.toml` has some typo.

#### When I run "cargo update" on some recipe source it call Rustup to install other Rust toolchain version, how can I fix that?

It happens because Cargo is not using the Redox fork of the Rust compiler, to fix that run `make env` from the Redox build system root.

It will import the Redox Makefile environment variables to your active shell (it already does that when you run other `make` commands from the Redox build system root).

#### I added the dependency of my program on the "recipe.toml" but the program build system doesn't detect it, then I installed the program dependency on my Linux distribution and it detected, why?

Read [this](./ch08-05-troubleshooting.md#environment-leakage) section.

### QEMU

#### How can I kill the QEMU process if Redox freezes or get a kernel panic?

- Read [this](./ch08-05-troubleshooting.md#kill-a-frozen-redox-vm) section.

### Real Hardware

#### I got a kernel panic, what can I do?

Read [this](./ch08-05-troubleshooting.md#kernel-panic) section.

#### Some driver is not working with my hardware, what can I do?

Read [this](./ch08-05-troubleshooting.md#debug-methods) section and ask us for instructions in the [Matrix chat](./ch13-01-chat.md).
