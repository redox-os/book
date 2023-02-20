# Advanced Build

In this section, we provide the gory details that may be handy to know if you are contributing to or developing for **Redox**.

## Setting up your Environment

If you intend on contributing to Redox or its subprojects, please read [Creating Proper Pull Requests](./ch12-04-creating-proper-pull-requests.md) so you understand our use of forks, and set up your repository appropriately. 

Although it is strongly recommended you use the [Building Redox](./ch02-05-building-redox.md) process or [Podman Build](./ch02-06-podman-build.md) instead of the process described here, advanced users may accomplish the same as the **bootstrap.sh** script with the following steps, which are provided by way of example for Pop!_OS/Ubuntu/Debian. For other platforms, have a look at the file [bootstrap.sh](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/bootstrap.sh) to help determine what packages to install for your distro.

Be forewarned, for distros other than Pop!_OS/Ubuntu/Debian, neither `bootstrap.sh` nor this document are fully maintained, as the recommended environment is **Podman**. The core redox-os developers use Pop!_OS to build Redox.

The steps to perform are 
- [Clone the repository](#clone-the-repository)
- [Install the Pre-requisite packages](#install-pre-requisite-packages-and-emulators)
- [Install Rust](#install-rust-stable-and-nightly)
- Adjust your [Configuration Settings](./ch02-07-configuration-settings.md)
- Build the system

## Understanding Cross-Compilation for Redox

Redox build is an example of [cross-compilation](https://en.wikipedia.org/wiki/Cross_compiler). The Redox toolchain runs on Linux, and produces Redox executables. When you see `apt-get libxxx-dev`, this is a case of the toolchain needing library source so it can compile a recipe into a Redox executable. Anything that is installed with apt-get but is not libxxx-dev is just part of the toolchain, and does not go on Redox.

In the background, `bootstrap.sh` downloads the Redox toolchain, then recipes are compiled using the Redox toolchain and the library sources (`libxxx-dev` packages).

If you are using Podman, the `podman_bootstrap.sh` will download an Ubuntu image and install the Redox toolchain. The recipes will be compiled in the container using the Redox toolchain and library sources (`libxxx-dev` packages).

The recipes produce Redox-specific executables. At the end of the build process, these executables are installed inside the QEMU image.

If your software is written in Rust, it will use Xargo (Redox-aware Cargo) and rustc.

If your software is written in C/C++ or is a non-Rust program, it will use relibc (Redox C library) to link your program to Redox system calls.

- [OSDev article on cross-compiling](https://wiki.osdev.org/Why_do_I_need_a_Cross_Compiler%3F)

## Clone the repository

Create a directory and clone the repository.

 ```sh
mkdir -p ~/tryredox
cd ~/tryredox
git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive
cd redox
git submodule update --recursive --init
 ```
Please be patient, this can take 5 minutes to an hour depending on the hardware and network you're running it on.

In addition to installing the various packages needed for building Redox, **bootstrap.sh** and **podman_bootstrap.sh** both clone the repository, so if you used either script, you have completed Step 1. 

## Install Pre-Requisite Packages and Emulators

If you cloned the source tree *before* running **bootstrap.sh**, you can use
```sh
cd ~/tryredox/redox
./bootstrap.sh -d
```
to install the package dependencies without re-fetching any source. If you wish to install the dependencies yourself, some examples are given below.

### Pop!_OS/Ubuntu/Debian Users

Install the package dependencies:
```sh
sudo apt-get install autoconf autopoint bison build-essential cmake curl file \
        flex genisoimage git gperf m4 nasm pkg-config po4a \
        libc6-dev-i386 libexpat-dev libfuse-dev libgmp-dev \
        libhtml-parser-perl libpng-dev libtool syslinux-utils texinfo
```

Install an emulator:
```sh
sudo apt-get install qemu-system-x86
```
or
```sh
sudo apt-get install virtualbox
```

If you intend to include **Rust** in your filesystem config, or any of the games with graphics,
```sh
sudo apt-get install libsdl1.2-dev ninja-build meson python3-mako
```

### Arch Linux Users

If you are unable to use [Podman Build](./ch02-06-podman-build.md), you can attempt to install the prerequisite packages yourself. Some of them are listed here.

```sh
sudo pacman -S cmake fuse git gperf perl-html-parser nasm wget texinfo bison flex po4a rsync inetutils
```

### Fedora/Redhat/Centos Linux Users

If you are unable to use [Podman Build](./ch02-06-podman-build.md), you can attempt to install the prerequisite packages yourself. Some of them are listed here.

```
sudo dnf install cmake make nasm qemu pkg-config fuse-devel gperf perl-HTML-Parser po4a automake gcc gcc-c++ glibc-devel.i686
sudo dnf install gettext-devel bison flex libtool perl-Pod-Xhtml libpng-devel patch texinfo  perl-FindBin
```

### MacOS Users using MacPorts:

If you are unable to use [Podman Build](./ch02-06-podman-build.md), you can attempt to install the prerequisite packages yourself. Some of them are listed here.

```
sudo port install make nasm qemu qemu-system-x86_64 gcc7 pkg-config osxfuse x86_64-elf-gcc coreutils findutils gcc49 gcc-4.9 nasm pkgconfig osxfuse x86_64-elf-gcc cmake
```

### MacOS Users using Homebrew:

If you are unable to use [Podman Build](./ch02-06-podman-build.md), you can attempt to install the prerequisite packages yourself. Some of them are listed here.

```
brew install automake bison gettext libtool make nasm qemu gcc@7 pkg-config Caskroom/cask/osxfuse
brew install redox-os/gcc_cross_compilers/x86_64-elf-gcc
```

## Install Rust Stable And Nightly

Install Rust, make the nightly version your default toolchain, then list the installed toolchains:

```sh
curl https://sh.rustup.rs -sSf | sh
```
then
```sh
source ~/.cargo/env
rustup default nightly
rustup toolchain list
cargo install --force --version 0.3.20 xargo
cargo install --force --version 0.1.1 cargo-config
```

NOTE: **xargo** allows Redox to have a custom `libstd`

NOTE: `~/.cargo/bin` has been added to your PATH for the running session.

The line `. "$HOME/.cargo/env` (equivalent to `source ~/.cargo/env`) will have been added to your shell start-up file, `~/.bashrc`, but you may wish to add it elsewhere or modify it according to your own environment.

## Prefix

The tools that build Redox are specific to each processor architecture. These tools are located in the directory `prefix`, in a subdirectory named for the architecture, e.g. `prefix/x86_64-unknown-redox`. If you have problems with these tools, you can remove the subdirectory or even the whole `prefix` directory, which will cause the tools to be re-downloaded or rebuilt. The variable `PREFIX_BINARY` in `mk/config.mk` controls whether they are downloaded or built.

## Cookbook

The **Cookbook** system is an essential part of the Redox build system. Each Redox component package  is built and managed by the Cookbook toolset. The variable `REPO_BINARY` in `mk/config.mk` controls whether the packages are downloaded or built. See [Including Programs in Redox](./ch09-01-including-programs.md) for examples of using the Cookbook toolset. If you will be developing packages to include in Redox, it is worthwhile to have a look at the tools in the `cookbook` directory.

## Creating a Build Environment Shell

If you are working on specific components of the system, and will be using some of the tools in the `cookbook` directory and bypassing `make`, you may wish to create a build environment shell. This shell includes the `prefix` tools in your path. You can do this with:
```sh
make env
```
This command also works with **Podman Build**, creating a shell in Podman and setting PATH to include the necessary build tools.

## Updating The Sources

If you want to update the Redox build system or if some of the recipes have changed, you can update those parts of the system with `make pull`. However, this will not update source for the packages.

```sh
cd ~/tryredox/redox
make pull
```

If you want to update the source for the packages, use `make rebuild`, or remove the file `$(BUILD)/fetch.tag` then use `make fetch`.

## Changing the filesystem size and contents

You can modify the size and contents of the filesystem for emulation and *livedisk* as described in [Configuration Settings](./ch02-07-configuration-settings.md).

## Next steps

Once this is all set up, we can finally Compile! See [Compiling The Entire Redox Project](./ch02-05-building-redox.md#compiling-the-entire-redox-project).

## Build System Quick Reference

The build system creates and/or uses several files that you may want to know about. There are also several `make` targets mentioned above, and a few extras that you may find useful. Here's a quick summary. All file paths are relative to your `redox` base directory.

### Build System Files

  - `Makefile` - The main makefile for the system, it loads all the other makefiles.
  - `.config` - Where you change your build system settings. It is loaded by the Makefile. It is ignored by `git`.
  - `mk/config.mk` - The build system's own settings are here. You can override these settings in your `.config`, don't change them here.
  - `mk/*.mk` - The rest of the makefiles. You should not need to change them.
  - `podman/redox-base-containerfile` - The file used to create the image used by Podman Build. The installation of Ubuntu packages needed for the build is done here. See [Adding Libraries to the Build](./ch08-02-advanced-podman-build.md#adding-libraries-to-the-build) if you need to add additional Ubuntu packages.
  - `config/$(ARCH)/$(CONFIG_NAME).toml` - The packages to be included in the Redox image that will be built, e.g. `config/x86_64/desktop.toml`.
  - `cookbook/recipes/PACKAGE/recipe.toml` - For each Redox package (represented here as `PACKAGE`), there is a directory that contains its recipe, usually `recipe.toml`, but in some older recipes, `recipe.sh` is used. The recipe contains instructions for obtaining sources via download or git, then creating executables or other files to include in the Redox filesystem. Note that a recipe can contain dependencies that cause other packages to be built, even if the dependencies are not otherwise part of your Redox build.
  - `cookbook/*` - Part of the cookbook system, these scripts and utilities help build the recipes.
  - `prefix/*` - Tools used by the cookbook system. They are normally downloaded during the first system build. If you are having a problem with the build system, you can remove the `prefix` directory and it will be recreated during the next build.
  - `$(BUILD)` - The directory where the build system will place the final image. Usually `build/$(ARCH)/$(CONFIG_NAME)`, e.g. `build/x86_64/desktop`.
  - `$(BUILD)/harddrive.img` - The Redox image file, to be used by QEMU or VirtualBox for virtual machine execution on a Linux host.
  - `$(BUILD)/livedisk.iso` - The Redox bootable image file, to be copied to a USB drive or CD for live boot and possible installation.
  - `$(BUILD)/fetch.tag` - An empty file that, if present, tells the build system that fetching of package sources has been done.
  - `$(BUILD)/repo.tag` - An empty file that, if present, tells the build system that all packages required for the Redox image have been successfully built. **The build system will not check for changes to your code when this file is present.** Use `make rebuild` to force the build system to check for changes.
  - `build/podman` - The directory where Podman Build places the container user's home directory, including the container's Rust installation. Use `make container_clean` to remove it. In some situations, you may need to remove this directory manually, possibly with root privileges.
  - `build/container.tag` - An empty file, created during the first Podman Build, so Podman Build knows a reusable Podman image is available. Use `make container_clean` to force a rebuild of the Podman image on your next `make rebuild`.
  
### Make Targets

You can combine `make` targets, but order is significant. For example, `make r.games image` will build the `games` package and create a new Redox image, but `make image r.games` will make the Redox image before it builds the package.

  - `make all` - Builds the entire system, checking for changes and only building as required. Only use this for the first build. If the system was successfully built previously, this command may report `Nothing to be done for 'all'`, even if some packages have changed. Use `make rebuild` instead.
  - `make rebuild` - Builds the entire system. Forces a check of package recipes for changes. This may include downloading changes from gitlab. This should be your normal `make` target.
  - `make qemu` - If a `$(BUILD)/harddrive.img` file exists, QEMU is run using that image. If you want to force a rebuild first, use `make rebuild qemu`. Sometimes `make qemu` will detect a change and rebuild, but this is not typical. If you are interested in a particular combination of QEMU command line options, have a look through `mk/qemu.mk`.
  - `make virtualbox` - The same as `make qemu`, but for [VirtualBox](https://www.virtualbox.org/).
  - `make live` - Creates a bootable image, `$(BUILD)/livedisk.iso`. Packages are not usually rebuilt. 
  - `make r.PACKAGE` - Executes a single package recipe, checking if the package source has changed, and creating the executable, etc. Substitute the name of the package for PACKAGE, e.g. `make r.games`. The package is built even if it is not in your filesystem config.
  - `make image` - Builds a new image, `$(BUILD)/harddrive.img`, without checking if any packages have changed. Not recommended, but it can save you some time if you are just updating one package with `make r.PACKAGE`.
  - `make clean` - Removes all build output, except for some build tools and files specific to Podman Build. Note that `make clean` may require some tools to be built.
  - `make c.PACKAGE` - Removes build output for the package `PACKAGE`.
  - `make pull` - Updates the sources for the build system and the recipes, but not for the packages.
  - `make fetch` - Gets package sources, according to each recipe, without building them. Only the packages that are included in your `(CONFIG_NAME).toml` are fetched. Does nothing if `$(BUILD)/fetch.tag` is present. You won't need this.
  - `make repo` - Builds the package sources, according to each recipe. Does nothing if `$(BUILD)/repo.tag` is present. You won't need this.
  - `make gdb` - Connects `gdb` to the Redox image in QEMU. Join us on [chat](./ch13-01-chat.md) if you want to use this.
  - `make mount` - Mounts the Redox image as a filesystem at `$(BUILD)/filesystem`. **Do not use this if QEMU is running**, and remember to use `make unmount` as soon as you are done. This is not recommended, but if you need to get a large file onto or off of your Redox image, this is available as a workaround.
  - `make unmount` - Unmounts the Redox image filesystem. Use this as soon as you are done with `make mount`, and **do not start QEMU** until this is done.
  - `make env` - Creates a shell with the build environment initialized. If you are using Podman Build, the shell will be inside the container, and you can use it to debug build issues such as missing packages.
  - `make container_su` - After creating a container shell using `make env`, and while that shell is still running, use `make container_su` to enter the same container as `root`. See [Debugging your Build Process](./ch08-02-advanced-podman-build.md#debugging-your-build-process).
  - `make container_clean` - If you are using Podman Build, this will discard images and other files created by it.
  - `make container_touch` - If you have removed the file `build/container.tag`, but the container image is still usable, this will recreate the `container.tag` file and avoid rebuilding the container image.
  - `make container_kill` - If you have started a build using Podman Build, and you want to stop it, `Ctrl-C` may not be sufficient. Use this command to terminate the most recently created container.
