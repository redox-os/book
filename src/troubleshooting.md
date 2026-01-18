# Troubleshooting the Build

This page covers all troubleshooting methods and tips for our build system.

(You must read the [Build System](./build-system-reference.md) page before)

- [Setup](#setup)
    - [Podman](#podman)
        - [Manual Configuration](#manual-configuration)
    - [Native Build](#native-build)
    - [Git](#git)
- [Building the System](#building-the-system)
    - [.config and mk/config.mk](#config-and-mkconfigmk)
    - [Prefix](#prefix)
    - [Filesystem Configuration](#filesystem-configuration)
    - [Fetch](#fetch)
    - [Cookbook](#cookbook)
    - [Create the Image with FUSE](#create-the-image-with-fuse)
- [Solving Compilation Problems](#solving-compilation-problems)
    - [Environment Leakage](#environment-leakage)
    - [Update Your Build System](#update-your-build-system)
    - [Update Relibc](#update-relibc)
    - [Prevent and Fix Breaking Changes](#prevent-and-fix-breaking-changes)
    - [Update Your Branch](#update-your-branch)
    - [Update Crates](#update-crates)
    - [Verify The Dependency Tree](#verify-the-dependency-tree)
- [Debug Methods](#debug-methods)
- [Kill A Frozen Redox VM](#kill-a-frozen-redox-vm)
- [Kernel Panic](#kernel-panic)
    - [QEMU](#qemu)
    - [Real Hardware](#real-hardware)

## Setup

When you run `podman_bootstrap.sh` or `native_bootstrap.sh`, the Linux tools and libraries required to support the toolchain and build all recipes are installed. Then the `redox` project is downloaded from the Redox GitLab server. The `redox` project does not contain the system component sources, it only contains the build system.

### Podman

If your build appears to be missing libraries, have a look at the [Debugging Your Podman Build Process](./advanced-podman-build.md#debugging-your-build-process) section.
If your Podman environment becomes broken, you can use `podman system reset` and `rm -rf build/podman`. In some cases, you may need to run the `sudo rm -rf build/podman` command.

If any command ask your to choose an image repository (after the `make container_clean` command execution) select the first item, it will give an error and you need to run the `time make all` command again

#### Manual Configuration

If you have problems setting Podman to rootless mode, do the following steps:

(These commands were taken from the official [Podman rootless wiki](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md) and [Shortcomings of Rootless Podman](https://github.com/containers/podman/blob/main/rootless.md), thus it could be broken/wrong in the future, read the wiki to see if the commands match, we will try to update the method to work with everyone)

- Install the `podman`, `crun`, `slirp4netns` and `fuse-overlayfs` packages on your system.
- `podman ps -a` - This command will show all your Podman containers, if you want to remove all of them, run `podman system reset`
- Follow [this step](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md#cgroup-v2-support) if necessary (if the Podman of your distribution use cgroups V2), you will need to edit the `containers.conf` file at `/etc/containers` or your user folder at `~/.config/containers`, change the line `runtime = "runc"` to `runtime = "crun"`
- Execute the `cat /etc/subuid` and `cat /etc/subgid` commands to see user/group IDs (UIDs/GIDs) available for Podman.

If you don't want to edit the file, you can use this command:

```sh
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 your-user
```

You can use the values `100000-165535` for your user, just edit the two text files, we recommend `sudo nano /etc/subuid` and `sudo nano /etc/subgid`, when you finish, press Ctrl+X to save the changes.

- After the change on the UID/GID values, execute this command:

```sh
podman system migrate
```

- If you have a network problem on the container, this command will allow connections on the port 443 (without root):

```sh
sudo sysctl net.ipv4.ip_unprivileged_port_start=443
```

- Hopefully, you have a working Podman build now.

(If you still have problems with Podman, read the [Troubleshooting](./troubleshooting.md) chapter or join us on the [chat](./chat.md))

Let us know if you have improvements for Podman troubleshooting on the [chat](./chat.md).

### Native Build

Not all Linux distributions are supported by `native_bootstrap.sh`, so if you have frequent compilation problems try the `podman_bootstrap.sh` script for [Podman](https://podman.io/) builds.

If you want to support your Unix-like system without Podman, you can try to install the Debian/Ubuntu package equivalents for your system from your package manager/software store, you can see them on the `ubuntu()` function of the [native_bootstrap.sh](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/native_bootstrap.sh) script.

The `native_bootstrap.sh` script and `redox-base-containerfile` covers the build system packages needed by the recipes at the [demo.toml](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/config/x86_64/demo.toml) filesystem configuration.

(Note that some systems may have build environment problems hard and time consuming to fix, on these systems Podman will fix most headaches)

### Git

If you did not use `podman_bootstrap.sh` or `native_bootstrap.sh` to setup your environment, you can download the sources with:

```sh
git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream
```

- Ensure that all the libraries and packages required by Redox are installed by running `./podman_bootstrap.sh -d` or, if you will be using the Podman build run the `./podman_bootstrap.sh -d` command.

## Building The System

When you run `make all`, the following steps occur.

### .config and mk/config.mk

- `make` scans [.config](./configuration-settings.md#config) and [mk/config.mk](./configuration-settings.md#mkconfigmk) for settings, such as the CPU architecture, configuration name, and whether to use **Podman** during the build process. Read through the [Configuration Settings](./configuration-settings.md) page to make sure you have the settings that are best for you.

### Prefix

The Redox toolchain, referred to as **prefix** because it is prefixed with the CPU architecture name, is downloaded and/or built. Modified versions of `cargo`, `rustc`, `gcc` and many other tools are created. They are placed in the `prefix` directory. 

If you have a problem with the toolchain, try the `rm -rf prefix` and `make prefix` or `make clean all` (if `make prefix` is not enough) commands.

### Filesystem Configuration

The list of Redox recipes to be built is read from the [filesystem configuration](./configuration-settings.md#filesystem-configuration) file, which is specified in [.config](./configuration-settings.md#config) or `mk/config.mk`. If your recipe is not being included in the build, verify if you have set the `CONFIG_NAME` or `FILESYSTEM_CONFIG` in the `.config` file.

### Fetch

Each recipe source is downloaded using `git` or `curl`, according to the `[source]` section of the `recipe.toml` file. Source is placed at `recipes/recipe-name/source`

(Some recipes still use the old `recipe.sh` format, they need to be converted to TOML)

If you are doing work on a recipe, you may want to comment out the `[source]` section of the recipe. To discard your changes to the source for a recipe, or to update to the latest version, uncomment the `[source]` section of the recipe, and use `make uc.recipe-name` in the recipe directory to remove both the source and any compiled code.

After all recipes are fetched, a tag file is created as `build/$ARCH/$CONFIG_NAME/fetch.tag`, e.g. `build/x86_64/desktop/fetch.tag`. If this file is present, fetching is skipped. You can remove it manually, or use `make rebuild`, if you want to force refetching.

### Cookbook

Each recipe is built according to the `recipe.toml` file. The recipe binaries or library objects are placed in the `target` directory, in a subdirectory named based on the CPU architecture.

If you have a problem with a recipe you are building, try the `make c.recipe-name` command. A common problem when building on unsupported systems is that certain recipes will fail to build due to missing dependencies. Try using the [Podman Build](./podman-build.md) or manually installing the recipe dependencies.

After all recipes are cooked, a tag file is created as `build/$ARCH/$CONFIG_NAME/repo.tag`. If this file is present, cooking is skipped. You can remove it manually, or use `make rebuild`, which will force refetching and rebuilding.

### Create the Image with FUSE

To build the final Redox image, `redox_installer` uses [FUSE](https://github.com/libfuse/libfuse), creating a virtual filesystem and copying the recipe packages into it. This is done outside of Podman, even if you are using Podman Build.

On some Linux distributions, FUSE may not be permitted for some users, or `podman_bootstrap.sh` and `native_bootstrap.sh` might not install it correctly. Investigate whether you can address your FUSE issues, or join the [chat](./chat.md) if you need advice.

## Solving Compilation Problems

- Verify your Rust version (run `make env` and `cargo --version`, then `exit`), make sure you have **the latest version of Rust nightly!**.

    - [rustup.rs](https://www.rustup.rs) is recommended for managing Rust versions. If you already have it, run the `rustup` command.

- Verify if your `make` and `nasm` are up-to-date.
- Verify if the build system is using the latest commit by running the `git branch -v` command.
- Verify if the submodules are using the latest pinned commit, to do this run:

```sh
cd submodule-name
```

```sh
git branch -v
```

- Verify if the recipe source is using the latest commit of the default branch, to do this run:

```sh
cd recipes/some-category/recipe-name/source
```

```sh
git branch -v
```

- Run `make clean pull fetch` to remove all your compiled binaries and update all sources.
- Sometimes there are merge requests that briefly break the build, so check the [Chat](./chat.md) if anyone else is experiencing your problems.
- Sometimes both the source and the binary of some recipe is wrong, run `make ur.recipe-name` and verify if it fix the problem.

#### Environment Leakage

Environment leakage is when some program or library is not fully cross-compiled to Redox, thus its dependency chain has Linux references that don't work on Redox.

It usually happens when the program or library get objects from outside the Redox build system PATH.

- The Redox build system PATH only read at `/usr/bin` and `/bin` to use the host system build tools
- The program build system must use the host system build tools and the Cookbook recipe dependencies, not the host system libraries.
- The most common way to detect this is to install the `*-dev` dependency package equivalent to the program recipe dependency, for example:

The program named "my-program" needs to use the OpenSSL library, thus you add the `openssl` recipe on the `recipe.toml` of the program, but the program don't detect the OpenSSL source code.

Then you install the `libssl-dev` package on your Ubuntu system and rebuild the program with the `make cr.my-program` command, then it finish the build process successfully.

But when you try to open the executable of the program inside of Redox, it doesn't work. Because it contain Linux references.

To fix this problem you need to find where the program build system get the OpenSSL source code and patch it with `${COOKBOOK_SYSROOT}` environment variable (where the `openssl` recipe contents were copied)

### Update Your Build System

Sometimes your build system can be outdated because you forgot to run `make pull` before other commands, read [this](./build-system-reference.md#update-the-build-system) section to learn the complete way to update the build system.

### Update Relibc

An outdated relibc copy can contain bugs (already fixed on recent versions) or missing APIs, read [this](./build-system-reference.md#update-relibc) section to learn how to update it.

### Prevent and Fix Breaking Changes

Sometimes build system or recipe breaking changes are merged (you need to monitor the Dev room in our [chat](./chat.md) to know if some commit or MR containing breaking changes were merged) and you need to cleanup your recipe or build system tooling binaries before the recipe or build system source updates to avoid conflicts with the new configuration.

#### Build System Breakage Prevention

The following methods can prevent a build system breakage after updates that change file configuration behavior.

- Wipe all recipe binaries, update build system source and rebuild the system (most common prevention)

```sh
make clean pull all
```

- Wipe all recipe binaries and Podman container, update build system source and rebuild the system

```sh
make clean container_clean pull all
```

- Wipe all recipe binaries/sources, update build system source and rebuild the system (least common prevention)

```sh
make distclean pull all
```

#### Build System Fixing

If the breaking change affect multiple recipes or any recipe can't be built, read the following instructions:

- Wipe the build system binaries and build the system (most common fix)

```sh
make clean all
```

Check if the compilation or runtime error continues after this command, if the error continues run the command below:

- Wipe and rebuild the filesystem tooling

```sh
make fstools_clean fstools
```

Check if the compilation or runtime error continues after this command, if the error continues run the command below:

- Wipe the Podman container (not common fix)

```sh
make container_clean
```

Check if the compilation or runtime error continues after this command, if the error continues it doesn't happen because of breaking changes on the build system.

#### Recipe Fixing

Some types of recipe errors can be backwards-incompatible build system, system component or relibc changes after the `make pull rebuild` command execution. Run the following tests to verify if the recipe error is an isolated problem or a breaking change:

- Rebuild the recipe binaries

```sh
make cr.recipe-name
```

Check if the compilation or runtime error continues after this command, if the error continues run the following command:

- Wipe the recipe sources and binaries and rebuild

```sh
make ur.recipe-name
```

Check if the compilation or runtime error continues after this command, if the error continues run the following command:

- Update relibc and rebuild the recipe

```sh
touch relibc
```

```sh
make prefix cr.recipe-name
```

Check if the compilation or runtime error continues after this command, if the error continues run the following command:

- Reconfigure the Redox toolchain and rebuild the recipe

```sh
rm -rf prefix
```

```sh
make prefix cr.recipe-name
```

Check if the compilation or runtime error continues after this command, if the error continues run the following command:

- Wipe all recipe binaries and rebuild the system (run this command if the binaries of multiple recipes are broken)

```sh
make c.--all
```

Check if the compilation or runtime error continues after this command, if the error continues run the following command:

- Wipe all recipe sources and binaries and rebuild the system (run this command if the sources and binaries of multiple recipes are broken)

```sh
make u.--all
```

Check if the compilation or runtime error continues after this command, if the error continues read the section below.

#### New Build System Copy

If the methods above doesn't work you need to download a new copy of the build system by running the `podman_bootstrap.sh` or `native_bootstrap.sh` scripts or using the following commands:

```sh
git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream
```

```sh
cd redox
```

```sh
make all
```

### Update Your Branch

If you are doing local changes on the build system, probably you left your branch active on the folder (instead of `master` branch).

New branches don't sync automatically with `master`, thus if the `master` branch receive new commits, you wouldn't use them because your branch is outdated.

To fix this, run:

```sh
git checkout master
```

```sh
git pull
```

```sh
git checkout your-branch
```

```sh
git merge master
```

Or

```sh
git checkout master
```

```sh
git pull
```

```sh
git merge your-branch master
```

If you want an anonymous merge, read the [Anonymous Commits](./coding-and-building.md#anonymous-commits) section.

### Update Crates

Sometimes a Rust program use an old crate version lacking Redox support, read [this](./porting-applications.md#update-crates) section to learn how to update them.

### Verify The Dependency Tree

Some crates take a long time to do a new release (years in some cases), thus these releases will hold old versions of other crates, versions where the Redox support is not available (causing errors during the program compilation).

The `redox_syscall` crate is the most affected by this, some crates hold a very old version of it and will require patches (`cargo update -p` alone doesn't work).

To identify which crates are using old versions of Redox crates you will need to verify the dependency tree of the program, inside the program source directory, run:

```sh
cargo tree --target=x86_64-unknown-redox
```

(If you aren't building Redox to x86_64 change `x86_64` in `x86_64-unknown-redox` to the CPU code that you are using)

This command will draw the dependency tree and you will need to find the crate name on the tree.

If you don't want to find it, you can use the `grep` tool with a pipe to see all crate versions used in the tree, sadly `grep` don't preserve the tree hierarchy, thus it's only useful to see versions and if some patched crate works (if the patched crate works all crate matches will report the most recent version).

To do this, run:

```sh
cargo tree --target=x86_64-unknown-redox | grep crate-name
```

## Debug Methods

- Read [this](https://en.wikipedia.org/wiki/Debugging#Techniques) Wikipedia section to learn about debugging techniques

- Use the `dmesg` command to read the kernel and userspace daemons log

- If Orbital hangs you need to verify if the system also freezed by pressing Super+F1 to see the boot log or Super+F2 to switch to other `tty`, login as `root` and run `dmesg` to read the system log ("Super" is the key with Windows logo)

- You can start the QEMU with the `make qemu gpu=no` command to easily copy the terminal text

- You can write to the `debug:` scheme, which will output on the console, but you must be the `root` user. This is useful if you are debugging an program where you need to use Orbital but still want to capture messages

- Currently, the build system strips function names and other symbols from programs, as support for symbols is not implemented yet

- To use GDB add the `gdbserver` recipe in your filesystem configuration, run the `make qemu gdb=yes` command in one shell, start the `gdbserver` program on QEMU and run the `make gdb` command in another shell

- Use the following command for advanced logging:

```sh
make some-command 2>&1 | tee file-name.log
```

### Recipes

You will see the available debug methods for recipes on this section.

- If you change the recipe build mode (`release` to `debug` or the opposite) while debugging, don't forget to rebuild with `make cr.recipe-name` because the build system may not detect the changes.

#### Rust

Rust programs can carry assertions, checking and symbols, but they are disabled by default.

- `REPO_DEBUG` - This environment variable will build the Rust program with assertions, checking and symbols.

(Debugging with symbols inside of Redox is not supported yet)

To enable them you can use the following commands or scripts:

- Permanently enable `REPO_DEBUG` for all recipes by adding the following text to your `.config` file:

```
REPO_DEBUG?=1
```

- Enable the `REPO_DEBUG` environment variable for one command, rebuild/package a recipe and add to the Redox image:

```sh
REPO_DEBUG=1 make cr.recipe-name image
```

- Enable the `REPO_DEBUG` environment variable for multiple commands, rebuild/package a recipe and add to the Redox image:

```sh
export REPO_DEBUG=1
```

```sh
make cr.recipe-name image
```

- Enable the `COOKBOOK_DEBUG` and `COOKBOOK_NOSTRIP` (they are equivalent to `REPO_DEBUG` environment variable) inside the `recipe.toml` :

```toml
template = "custom"
script = """
COOKBOOK_DEBUG=true
COOKBOOK_NOSTRIP=true
cookbook_cargo
"""
```

- Backtrace

A backtrace helps you to detect bugs that happen with not expected input parameters, you can trace back through the callers to see where the bad data is coming from.

You can see how to use it below:

- Start QEMU with logging:

```sh
make qemu 2>&1 | tee file-name.log
```

- Enable this environment variable globally (on Redox):

```sh
export RUST_BACKTRACE=full
```

- Run the program and repeat the bug (capturing a backtrace in the log file)
- Close QEMU
- Open the log file, copy the backtrace and paste in an empty text file

- Run the `backtrace.sh` script in the `redox` directory (on Linux):

```sh
scripts/backtrace.sh -r recipe-name -b your-backtrace.txt
```

It will print the file and line number for each entry in the backtrace.

(This is the most simple example command, use the `-h` option of the `backtrace.sh` script to see more combinations)

#### GDB On QEMU

Use the following instructions to debug a recipe with GDB:

- Build or rebuild the recipe with assertions/checking/symbols and install into the Redox image:

```sh
make crp.recipe-name REPO_DEBUG=1
```

If you want to permanently enable debug binaries add the following environment variable to your `.config` file:

```
REPO_DEBUG?=1
```

- Build and install the GDB server into the Redox image

```sh
make rp.gdbserver
```

- Start QEMU with the GDB configuration enabled:

```sh
make qemu kvm=no QEMU_SMP=1 gdb=yes
```

If the recipe has one executable, run the following command:

```sh
make debug.recipe-name
```

If the recipe has multiple executables use the following command:

```sh
make debug.recipe-name DEBUG_BIN=executable-name
```

## Kill A Frozen Redox VM

Sometimes Redox can freeze or rarely get a kernel panic, to kill the QEMU process run this command:

```sh
pkill qemu-system
```

## Kernel Panic

A kernel panic is when some bug avoid the safe execution of the kernel code, thus the system needs to be restarted to avoid memory corruption.

We use the following kernel panic message format:

```
KERNEL PANIC: panicked at some-path/file-name.rs:line-number:character-position:
the panic description goes here
```

- You can use the following command to search it in a big log:

```sh
grep -nw "KERNEL PANIC" --include "file-name.log"
```

### QEMU

If you get a kernel panic in QEMU, copy the terminal text or capture a screenshot and send to us on [Matrix](./chat.md) or create an issue on [GitLab](https://gitlab.redox-os.org/redox-os/kernel/-/issues).

### Real Hardware

If you get a kernel panic in real hardware, capture a photo and send to us on [Matrix](./chat.md) or create an issue on [GitLab](https://gitlab.redox-os.org/redox-os/kernel/-/issues).
