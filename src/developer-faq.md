# Developer FAQ

The [General FAQ](https://www.redox-os.org/faq/) have questions and answers of/for newcomers and end-users, while this FAQ contain organization, technical questions and answers of/for developers and testers, feel free to suggest new questions and answers.

(If the following questions aren't enough, ask us in the [Chat](./chat.md))

- [General Questions](#general-questions)
    - [Why does Redox have unsafe Rust code?](#why-does-redox-have-unsafe-rust-code)
    - [Why does Redox have Assembly code?](#why-does-redox-have-assembly-code)
    - [Why does Redox do cross-compilation?](#why-does-redox-do-cross-compilation)
    - [Does Redox support OpenGL and Vulkan?](#does-redox-support-opengl-and-vulkan)
    - [How can I port a program?](#how-can-i-port-a-program)
    - [How can I write a driver?](#how-can-i-write-a-driver)
    - [How can I debug?](#how-can-i-debug)
- [Build System Questions](#build-system-questions)
    - [What is the correct way to update the build system?](#what-is-the-correct-way-to-update-the-build-system)
    - [How can I verify if my build system is up-to-date?](#how-can-i-verify-if-my-build-system-is-up-to-date)
    - [What is a recipe?](#what-is-a-recipe)
    - [When I should rebuild the build system or recipes from scratch?](#when-i-should-rebuild-the-build-system-or-recipes-from-scratch)
    - [How can I test my changes on real hardware?](#how-can-i-test-my-changes-on-real-hardware)
    - [How can I insert files to the Redox image?](#how-can-i-insert-files-to-the-redox-image)
    - [How can I change my Redox variant?](#how-can-i-change-my-redox-variant)
    - [How can I increase the filesystem size of my QEMU image?](#how-can-i-increase-the-filesystem-size-of-my-qemu-image)
    - [How can I change the CPU architecture of my build system?](#how-can-i-change-the-cpu-architecture-of-my-build-system)
    - [How can I cross-compile to ARM64 from a x86-64 computer?](#how-can-i-cross-compile-to-arm64-from-a-x86-64-computer)
    - [How can I use a recipe in my Redox image?](#how-can-i-use-a-recipe-in-my-redox-image)
    - [I only made a small change to my program. What's the quickest way to test it in QEMU?](#i-only-made-a-small-change-to-my-program-whats-the-quickest-way-to-test-it-in-qemu)
    - [How can I disable recipe compilation?](#how-can-i-disable-recipe-compilation)
    - [How can I disable recipe compilation except for a specific recipe?](#how-can-i-disable-recipe-compilation-except-for-a-specific-recipe)
    - [How can I install the packages needed by recipes (Native Build) or Podman without a new download of the build system?](#how-can-i-install-the-packages-needed-by-recipes-native-build-or-podman-without-a-new-download-of-the-build-system)
    - [How can I build the toolchain from source?](#how-can-i-build-the-toolchain-from-source)
- [Porting Questions](#porting-questions)
    - [How to determine if some program is portable to Redox?](#how-to-determine-if-some-program-is-portable-to-redox)
    - [How to determine the dependencies of some program?](#how-to-determine-the-dependencies-of-some-program)
    - [How can I configure the build system of the recipe?](#how-can-i-configure-the-build-system-of-the-recipe)
    - [How can I search for functions on relibc?](#how-can-i-search-for-functions-on-relibc)
    - [Which are the upstream requirements to accept my recipe?](#which-are-the-upstream-requirements-to-accept-my-recipe)
    - [What are the possible problems when porting programs and libraries?](#what-are-the-possible-problems-when-porting-programs-and-libraries)
    - [Why C/C++ programs and libraries are hard and time consuming to port?](#why-cc-programs-and-libraries-are-hard-and-time-consuming-to-port)
- [Scheme Questions](#scheme-questions)
    - [What is a scheme?](#what-is-a-scheme)
    - [When does a regular program need to use a scheme?](#when-does-a-regular-program-need-to-use-a-scheme)
    - [When would I write a program to implement a scheme?](#when-would-i-write-a-program-to-implement-a-scheme)
    - [How do I use a scheme for sandboxing a program?](#how-do-i-use-a-scheme-for-sandboxing-a-program)
    - [How can I see all userspace schemes?](#how-can-i-see-all-userspace-schemes)
    - [How can I see all kernel schemes?](#how-can-i-see-all-kernel-schemes)
    - [What is the difference between kernel and userspace schemes?](#what-is-the-difference-between-kernel-and-userspace-schemes)
    - [How does a userspace daemon provide file-like services?](#how-does-a-userspace-daemon-provide-file-like-services)
    - [How the system calls are used by userspace daemons?](#how-the-system-calls-are-used-by-userspace-daemons)
- [GitLab Questions](#gitlab-questions)
    - [How to properly review MRs?](#how-to-properly-review-mrs)
    - [I have a merge request with many commits, should I squash them after merge?](#i-have-a-merge-request-with-many-commits-should-i-squash-them-after-merge)
    - [Should I delete my branch after merge?](#should-i-delete-my-branch-after-merge)
    - [How can I have an anonymous account?](#how-can-i-have-an-anonymous-account)
- [Documentation Questions](#documentation-questions)
    - [How can I write code documentation properly?](#how-can-i-write-code-documentation-properly)
    - [How can I write book documentation properly?](#how-can-i-write-book-documentation-properly)
    - [How can I insert commands or code correctly?](#how-can-i-insert-commands-or-code-correctly)
    - [How can I create diagrams?](#how-can-i-create-diagrams)
- [Troubleshooting Questions](#troubleshooting-questions)
    - [Scripts](#scripts)
        - [I can't download the build system bootstrap scripts, how can I fix this?](#i-cant-download-the-build-system-bootstrap-scripts-how-can-i-fix-this)
        - [I tried to run the "podman_bootstrap.sh" and "native_bootstrap.sh" scripts but got an error, how to fix this?](#i-tried-to-run-the-podman_bootstrapsh-and-native_bootstrapsh-scripts-but-got-an-error-how-to-fix-this)
    - [Build System](#build-system)
        - [I ran "make all" but it show a "rustup can't be found" message, how can I fix this?](#i-ran-make-all-but-it-show-a-rustup-cant-be-found-message-how-can-i-fix-this)
        - [I tried all troubleshooting methods but my build system is still broken, how can I fix that?](#i-tried-all-troubleshooting-methods-but-my-build-system-is-still-broken-how-can-i-fix-that)
    - [Recipes](#recipes)
        - [I had an error with a recipe, how can I fix that?](#i-had-an-error-with-a-recipe-how-can-i-fix-that)
        - [I tried all methods of the "Troubleshooting the Build" page and my recipe still doesn't build, what can I do?](#i-tried-all-methods-of-the-troubleshooting-the-build-page-and-my-recipe-still-doesnt-build-what-can-i-do)
        - [When I run "make r.recipe" I get a syntax error, how can I fix that?](#when-i-run-make-rrecipe-i-get-a-syntax-error-how-can-i-fix-that)
        - [When I run "cargo update" on some recipe source it call Rustup to install other Rust toolchain version, how can I fix that?](#when-i-run-cargo-update-on-some-recipe-source-it-call-rustup-to-install-other-rust-toolchain-version-how-can-i-fix-that)
        - [I added the dependency of my program in the "recipe.toml" file but the program build system doesn't detect it, then I installed the program dependency on my Linux distribution and it detected, why?](#i-added-the-dependency-of-my-program-in-the-recipetoml-file-but-the-program-build-system-doesnt-detect-it-then-i-installed-the-program-dependency-on-my-linux-distribution-and-it-detected-why)
    - [QEMU](#qemu)
        - [How can I kill the QEMU process if Redox freezes or get a kernel panic?](#how-can-i-kill-the-qemu-process-if-redox-freezes-or-get-a-kernel-panic)
    - [Real Hardware](#real-hardware)
        - [I got a kernel panic, what can I do?](#i-got-a-kernel-panic-what-can-i-do)
        - [Some driver is not working with my hardware, what can I do?](#some-driver-is-not-working-with-my-hardware-what-can-i-do)

## General Questions

### Why does Redox have unsafe Rust code?

In some cases we must use `unsafe`, for example at certain parts in the kernel and drivers, these unsafe parts are generally wrapped with a safe interface.

These are the cases where unsafe Rust is mandatory:

- Implementing a foreign function interface (FFI) (for example the relibc API)
- Working with system calls directly (you should use `libredox`, `relibc` or Rust `libstd` library instead of `redox_syscall`)
- Creating or managing processes and threads
- Working with memory mapping and stack allocation
- Working with hardware devices

It is an important goal for Redox to minimize the amount of `unsafe` Rust code. If you want to use unsafe Rust code on Redox anywhere other than interfacing with system calls, ask for Jeremy Soller's approval before.

Unsafe Rust still has most of the compiler verification (thus more safe than C and C++).

Read the following pages to learn more about Unsafe Rust:

- https://doc.rust-lang.org/book/ch20-01-unsafe-rust.html
- https://doc.rust-lang.org/nomicon/meet-safe-and-unsafe.html

### Why does Redox have Assembly code?

[Assembly](https://en.wikipedia.org/wiki/Assembly_language) is the core of low-level because it's a CPU-specific programming language and deal with things that aren't possible or feasible to do in high-level languages like Rust.

Sometimes required or preferred for accessing hardware, or for carefully optimized hot spots.

Reasons to use Assembly instead of Rust:

- Deal with low-level things (those that can't be handled by Rust)
- Writing constant time algorithms for cryptography
- Optimizations

Places where Assembly is used:

- `kernel` - Interrupt and system call entry routines, context switching, special CPU instructions and registers
- `drivers` - Port IO need special instructions (x86_64)
- `relibc` - Some parts of the C runtime

### Why does Redox do cross-compilation?

[Cross-compilation](https://en.wikipedia.org/wiki/Cross_compiler) is when you build a program or library from one CPU architecture to another CPU architecture or one operating system to another operating system, but it require more configuration than native compilation.

Read some of the reasons below:

- When developing a new operating system you can't build programs inside of it because the system interfaces are premature. Thus you need to build the programs from your host system to the new OS and transfer the binaries to the filesystem of the new OS.
- Cross-compilation reduces the porting requirements because you don't need to support the compiler of the program's programming language, the program's build system and build tools. You just need to port the programming language standard library (if used), program libraries or the program source code (dependency-free).
- Some developers prefer to develop from other operating systems like Linux, MacOS, FreeBSD or Windows, the same applies for Linux where some developers write code on MacOS and test their kernel builds in a virtual machine (mostly QEMU) or real hardware.

(Interpreted programs and scripts don't need cross-compilation but the programming language's interpreter or possible compiled dependencies needs to be ported and cross-compiled to Redox)

### Does Redox support OpenGL and Vulkan?

Read the [Software Rendering](./graphics-windowing.md#software-rendering) section.

### How can I port a program?

Read the [Application Porting](./porting-applications.md) page.

### How can I write a driver?

Read the [drivers repository README](https://gitlab.redox-os.org/redox-os/drivers/-/blob/master/README.md).

### How can I debug?

Read the [Debug Methods](./troubleshooting.md#debug-methods) section.

## Build System Questions

### What is the correct way to update the build system?

Read the [Update The Build System](./build-system-reference.md#update-the-build-system) section.

### How can I verify if my build system is up-to-date?

After the `make pull` command, run the `git rev-parse HEAD` command to verify if it match the latest commit hash on [GitLab](https://gitlab.redox-os.org/redox-os/redox/-/commits/master?ref_type=HEADS).

### What is a recipe?

A software port to Redox

### When I should rebuild the build system or recipes from scratch?

Sometimes the execution of the `make pull rebuild` command is not enough to update the build system and recipes because of breaking changes, learn what to do on the following changes:

- New relibc functions and fixes: to allow a recipe to use the new relibc functions you need to rebuilt it with the `make cr.recipe-name` command, sometimes relibc fixes require a complete system rebuild by running the `make c.--all all` command
- Dependency changes on recipes: if the shared objects had symbol changes or the recipe is statically linked, run the `make cr.recipe-name` command
- Configuration changes on recipes: run the `make cr.recipe-name` command
- Source code changes on recipes: if the shared objects had symbol changes or the recipe is statically linked, run the `make ucr.recipe-name` command
- Changes on the location of the build system artifacts: run the `make clean pull all` command to not cause breakage with the previous artifacts locations, if the previous location of the build artifacts had contents you can try to fix manually or download the build system again to avoid confusion or fix difficult breakage

### How can I test my changes on real hardware?

Read the [Testing on Real Hardware](./coding-and-building.md#testing-on-real-hardware) section.

### How can I insert files to the Redox image?

If you use a [recipe](./coding-and-building.md#insert-files-on-the-qemu-image-using-a-recipe) your changes will persist after the `make image` command, but you can also [mount](./coding-and-building.md#insert-files-on-the-qemu-image) the Redox filesystem to insert them directly.

### How can I change my Redox variant?

Insert the `CONFIG_NAME?=your-config-name` environment variable to your `.config` file, read the [config](./configuration-settings.md#config) section for more details.

### How can I increase the filesystem size of my QEMU image?

Change the `filesystem_size` data type of your filesystem configuration at: `config/your-cpu-arch/your-config.toml` and run the `make image` command, read the [Filesystem Size](./configuration-settings.md#filesystem-size) section for more details.

### How can I change the CPU architecture of my build system?

Insert the `ARCH?=your-cpu-arch` environment variable on your `.config` file and run the `make all` command, read the [config](./configuration-settings.md#config) section for more details.

If you want to do it temporarily run the `make all ARCH=your-cpu-arch` command.

If you want to clean the binaries of the previous CPU architecture run the following command:

```sh
make c.--all ARCH=previous-cpu-arch
```

### How can I cross-compile to ARM64 from a x86-64 computer?

Insert the `ARCH?=aarch64` environment variable on your `.config` file and run the `make all` command.

If you want to do it temporarily run the `make all ARCH=aarch64` command.

### How can I use a recipe in my Redox image?

If you want to quickly install the recipe package until the next image creation, run the following command:

```sh
make rp.recipe-name
```

Or (if you want to use a remote package if you want to use it more quickly)

```sh
make rp.recipe-name REPO_BINARY=1
```

If you want to permanently install the recipe on your image, read the following steps.

- Go to your filesystem configuration and add the recipe:

```sh
nano config/your-cpu-arch/your-config.toml
```

```toml
[packages]
...
recipe-name = {}
...
```

Or (for a remote package)

```toml
[packages]
...
recipe-name = "binary"
...
```

- Build the recipe and install in a existing image

```sh
make rp.recipe-name
```

Or (for a remote package)

```sh
make rp.recipe-name REPO_BINARY=1
```

### I only made a small change to my program. What's the quickest way to test it in QEMU?

- Build the recipe, install to an existing image and launch QEMU:

```sh
make rp.recipe-name qemu
```

### How can I disable the recipe compilation?

Insert the `REPO_BINARY?=1` environment variable to your `.config` file, it will download pre-compiled recipe packages from the [build server](https://static.redox-os.org/pkg/) if available.

### How can I disable recipe compilation except for a specific recipe?

After inserting the `REPO_BINARY?=1` environment variable to your `.config` file, go to your filesystem configuration and add the source-based variant of the recipe:

```sh
nano config/your-cpu-arch/your-config.toml
```

```toml
[packages]
...
recipe-name = "source"
...
```

- Install the recipe package in the Redox image

```sh
make rp.recipe-name
```

Or (if the above doesn't work)

```sh
make rebuild
```

### How can I install the packages needed by recipes (Native Build) or Podman without a new download of the build system?

- Run the following command from your build system:

```sh
./native_bootstrap.sh -d
```

(If you are using Podman this process is automatic)

Or (for Podman dependencies)

- Run the following command from your build system:

```sh
./podman_bootstrap.sh -d
```

### How can I build the toolchain from source?

- Disable the `PREFIX_BINARY` environment variable inside of your `.config` file:

```sh
nano .config
```

```
PREFIX_BINARY?=0
```

- Clean the previous toolchain binaries and build new ones:

```sh
rm -rf prefix
```

```sh
make prefix
```

- Clean the previous recipe binaries and build again with the new toolchain:

```sh
make c.--all all
```

## Porting Questions

### How to determine if some program is portable to Redox?

- The source code of the program must be available
- The program should use cross-platform libraries (if not, more porting effort is required)
- The program's build system should support cross-compilation (if not, more porting effort is required)
- The program shouldn't directly use the Linux kernel API on its code (if not, more porting effort is required)

Some APIs of the Linux kernel can be ported while others not, because they require a complete Linux kernel.

### How to determine the dependencies of some program?

Read the [Dependencies](./porting-applications.md#dependencies) section.

### How can I configure the build system of the recipe?

Read the [Templates](./porting-applications.md#templates) section.

### How can I search for functions on relibc?

Read the [Search For Functions on Relibc](./porting-applications.md#search-for-functions-on-relibc) section.

### Which are the upstream requirements to accept my recipe?

Read the [Package Policy](./porting-applications.md#package-policy) section.

### What are the possible problems when porting programs and libraries?

- Missing build tools
- Cross-compilation configuration problems
- Lack of Redox patches
- Missing C, POSIX or Linux library functions in relibc
- Runtime crashes or errors

### Why C/C++ programs and libraries are hard and time consuming to port?

- C/C++ don't have an official, advanced and automatic dependency manager and build system which force programs and libraries to select competing build systems with different configurations (GNU Make, GNU Autotools, CMake, Meson and others), projects like [Conan](https://conan.io/) and [vcpkg](https://vcpkg.io/) tried to solve this problem but weren't adopted by most programs/libraries and lack many libraries
- Programs and libraries need to manually manage the library versions, to workaround this some programs use bundled libraries which can difficult patching when needed
- Some build systems lack a good cross-compilation support which require more tweaks and sometimes hacks
- As libraries are manually managed programs with many dependencies can take hours to port depending on available library documentation/configuration and developer experience
- Some programs and libraries have bad or lacking documentation about build instructions and configuration

## Scheme Questions

### What is a scheme?

Read the [Schemes and Resources](./schemes-resources.md) page.

### When does a regular program need to use a scheme?

Most schemes are used internally by system components or relibc, you don't need to access them directly. One exception is the pseudoterminal for your command window, which is accessed using the value of `$TTY`, which might have a value of e.g. `pty:18`. Some low-level graphics programming might require you to access your display, which might have a value of e.g. `display:3`

### When would I write a program to implement a scheme?

If you are implementing a kernel service, userspace service or a device driver.

### How do I use a scheme for sandboxing a program?

The [contain](https://gitlab.redox-os.org/redox-os/contain) program provides a partial implementation of sandboxing using schemes and namespaces.

### How can I see all userspace schemes?

Read the [Userspace Schemes](./schemes.md#userspace-schemes) section.

### How can I see all kernel schemes?

Read the [Kernel Schemes](./schemes.md#kernel-schemes) section.

### What is the difference between kernel and userspace schemes?

Read the [Kernel vs Userspace Schemes](./schemes.md#kernel-vs-userspace-schemes) section.

### How does a userspace daemon provide file-like services?

When a regular program calls `open`, `read`, `write`, etc. on a file-like resource, the kernel translates that to a message of type `syscall::data::Packet`, describing the file operation, and makes it available for reading on the appropriate daemon's scheme file descriptor. See the [Providing A Scheme](./scheme-operation.md#providing-a-scheme) section for more information.

### How the system calls are used by userspace daemons?

All userspace daemons use the system calls through [relibc](https://gitlab.redox-os.org/redox-os/relibc) like any normal program.

## GitLab Questions

### How to properly review MRs?

It's recommended to use code suggestions for normal text and code to help and save time for developers, that way they can quickly improve or apply the text or code.

You can start a code suggestion by clicking on the file icon with the + symbol when you click to comment in some line of a file.

- The review should be done by one reviewer per time to avoid conflict with other reviewers, each reviewer should warn when it start and finish a review
- Once you finish your review warn to avoid conflict with other reviewers
- **Don't edit your code suggestions without a warning to prevent merge errors and review desynchronization**

### I have a merge request with many commits, should I squash them after merge?

If they don't have relevant informaiton on titles, yes.

### Should I delete my branch after merge?

Yes.

### How can I have an anonymous account?

During the account creation process you can add a fake name on the "First Name" and "Last Name" fields and change it later after your account approval (single name field is supported).

Read the [Anonymous Commits](./coding-and-building.md#anonymous-commits) section if you need more anonymity.

## Documentation Questions

### How can I write code documentation properly?

Read the following pages:

- [Literate programming](./literate-programming.md)
- [Writting Documentation Correctly](./writing-docs-correctly.md)

### How can I write book documentation properly?

- Don't use informal language, like non-formal abbreviations such as "config"
- Don't insert work-in-progress information, it unnecessarily increases maintenance cost
- Use spaces instead of tabs to avoid formatting breakage with different text editor tab configurations
- Use [Oxford commas](https://en.wikipedia.org/wiki/Serial_comma)

### How can I insert commands or code correctly?

Commands or code should be inserted inside Markdown code blocks (using 3 backticks above and below the line of the command), for example:

```
your-command-or-code
```

- Multiple commands should use an unique code block for each command to allow them to be copied with one cursor click
- If you can't use a code block due to incompatible wording in the explanation, you can use the simple code highlighting using 1 backtick before and after the command on the same line

### How can I create diagrams?

For diagrams to this book read [this](https://gohugo.io/content-management/diagrams/) article.

For diagrams to the GitLab web interface the GitLab Markdown has support for some diagram syntaxes, read [this](https://docs.gitlab.com/user/markdown/#diagrams-and-flowcharts) article to learn how to use them.

## Troubleshooting Questions

### Scripts

#### I can't download the build system bootstrap scripts, how can I fix this?

Verify if you have `curl` installed or download the script from your web browser.

#### I tried to run the "podman_bootstrap.sh" and "native_bootstrap.sh" scripts but got an error, how to fix this?

- Verify if you have the GNU Bash shell installed on your system.
- Verify if Podman is supported on your operating system.
- Verify if your operating system is [supported](./building-redox.md#supported-unix-like-distributions-and-podman-build) on the `native_bootstrap.sh` script

### Build System

#### I ran "make all" but it show a "rustup can't be found" message, how can I fix this?

Run the following command:

```sh
source ~/.cargo/env
```

(If you installed rustup before the first `podman_bootstrap.sh` or `native_bootstrap.sh` execution, this error doesn't happen)

#### I tried all troubleshooting methods but my build system is still broken, how can I fix that?

If the `make clean pull container_clean all` command doesn't work download a new build system copy or wait for an upstream fix.

### Recipes

#### I had an error with a recipe, how can I fix that?

Read the [Solving Compilation Problems](./troubleshooting.md#solving-compilation-problems) section.

#### I tried all methods of the "Troubleshooting the Build" page and my recipe still doesn't build, what it can be?

- Missing dependencies
- Environment leakage: when some part of the recipe build system does native Linux compilation instead of cross-compilation to Redox
- Misconfigured cross-compilation
- The recipe needs to be ported to Redox

#### When I run "make r.recipe" I get a syntax error, how can I fix that?

Verify if your `recipe.toml` file has some typo, missing data type or value.

#### When I run "cargo update" on some recipe source it call rustup to install other Rust toolchain version, how can I fix that?

It happens because Cargo is not using the Redox fork of the Rust compiler, to fix that run `make env` from the Redox build system root.

It will import the Redox Makefile environment variables to your active shell (it already does that when you run other `make` commands from the Redox build system root).

#### I added the dependency of my program in the "recipe.toml" file but the program build system doesn't detect it, then I installed the program dependency on my Linux distribution and it detected, why?

Read the [Environment Leakage](./troubleshooting.md#environment-leakage) section.

### QEMU

#### How can I kill the QEMU process if Redox freezes or get a kernel panic?

Read the [Kill A Frozen Redox VM](./troubleshooting.md#kill-a-frozen-redox-vm) section.

### Real Hardware

#### I got a kernel panic, what can I do?

Read the [Kernel Panic](./troubleshooting.md#kernel-panic) section.

#### Some driver is not working with my hardware, what can I do?

Read the [Debug Methods](./troubleshooting.md#debug-methods) section and ask us for instructions in the [Matrix chat](./chat.md).
