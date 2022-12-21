# Advanced Build

In this section, we provide the gory details that may be handy to know if you are contributing to or developing for **Redox**.

## Setting up your Environment

If you intend on contributing to Redox or its subprojects, please read [Creating a Proper Pull Request](./ch06-10-creating-proper-pull-requests.html) so you understand our use of forks, and set up your repository appropriately. 

Although it is strongly recommended you use the [Building Redox](./ch02-05-building-redox.html) process or [Podman Build](./ch02-08-podman-build.html) instead of the process described here, advanced users may accomplish the same as the **bootstrap.sh** script with the following steps, which are provided by way of example for Pop!_OS/Ubuntu/Debian. For other platforms, have a look at the file [bootstrap.sh](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/bootstrap.sh) to help determine what packages to install for your distro.

Be forewarned, for distros other than Pop!_OS/Ubuntu/Debian, neither `bootstrap.sh` nor this document are fully maintained, as the recommended environment is **Podman**. The core redox-os developers use Pop!_OS to build Redox.  We recommend using Pop!_OS for repeatable zero-painpoint Redox builds.

The steps to perform are 
- [Clone the repository](#clone-the-repository)
- [Install the Pre-requisite packages](#install-pre-requisite-packages-and-emulators)
- [Install Rust](#install-rust-stable-and-nightly)
- Adjust your [Configuration Settings](./ch02-06-configuration-settings.html)
- Build the system

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

### Pop!_OS/Ubuntu/Debian Users:

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

### Arch Linux Users:
```sh
sudo pacman -S cmake fuse git gperf perl-html-parser nasm wget texinfo bison flex po4a rsync inetutils
```

### Fedora/Redhat/Centos Linux Users:

```
sudo dnf install cmake make nasm qemu pkg-config fuse-devel gperf perl-HTML-Parser po4a automake gcc gcc-c++ glibc-devel.i686
sudo dnf install gettext-devel bison flex libtool perl-Pod-Xhtml libpng-devel patch texinfo  perl-FindBin
```

### MacOS Users using MacPorts:

```
sudo port install make nasm qemu qemu-system-x86_64 gcc7 pkg-config osxfuse x86_64-elf-gcc coreutils findutils gcc49 gcc-4.9 nasm pkgconfig osxfuse x86_64-elf-gcc cmake
```

### MacOS Users using Homebrew:

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

The **Cookbook** system is an essential part of the Redox build system. Each Redox component package  is built and managed by the Cookbook toolset. The variable `REPO_BINARY` in `mk/config.mk` controls whether the packages are downloaded or built. See [Including Programs in Redox](./ch05-02-including-programs.html) for examples of using the Cookbook toolset. If you will be developing packages to include in Redox, it is worthwhile to have a look at the tools in the `cookbook` directory.

## Creating a Build Environment Shell

If you are working on specific components of the system, and will be using some of the tools in the `cookbook` directory and bypassing `make`, you may wish to create a build environment shell. This shell includes the `prefix` tools in your path. You can do this with:
```sh
make env
```
This command also works with **Podman Build**, creating a shell in Podman and setting PATH to include the necessary build tools.

## Updating The Sources using make pull

```sh
cd ~/tryredox/redox
make pull
```

## Changing the filesystem size and contents

You can modify the size and contents of the filesystem for emulation and *livedisk* as described in [Configuration Settings](./ch02-06-configuration-settings.html).

## Next steps

Once this is all set up, we can finally Compile! See [Compiling The Entire Redox Project](./ch02-05-building-redox.html#compiling-the-entire-redox-project).
