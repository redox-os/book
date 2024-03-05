# Advanced Build

In this section, we provide the gory details that may be handy to know if you are contributing to or developing for **Redox**.

## Setting up your Environment

If you intend on contributing to Redox or its subprojects, please read [Creating Proper Pull Requests](./ch12-04-creating-proper-pull-requests.md) so you understand our use of forks, and set up your repository appropriately. 

Although it is strongly recommended you use the [Building Redox](./ch02-05-building-redox.md) process or [Podman Build](./ch02-06-podman-build.md) instead of the process described here, advanced users may accomplish the same as the **bootstrap.sh** script with the following steps, which are provided by way of example for Pop!_OS/Ubuntu/Debian. For other platforms, have a look at the file [bootstrap.sh](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/bootstrap.sh) to help determine what packages to install for your distro.

Be forewarned, for distros other than Pop!_OS/Ubuntu/Debian, neither `bootstrap.sh` nor this document are fully maintained, as the recommended environment is **Podman**. The core redox-os developers use Pop!_OS to build Redox.

The steps to perform are 
- [Clone the repository](#clone-the-repository)
- [Install The Necessary packages](#install-the-necessary-packages-and-emulators)
- [Install Rust](#install-rust-stable-and-nightly)
- Adjust your [Configuration Settings](./ch02-07-configuration-settings.md)
- Build the system

## Clone the repository

Create a directory and clone the repository.

```sh
mkdir -p ~/tryredox
```

```sh
cd ~/tryredox
```

```sh
git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive
```

```sh
cd redox
```

```sh
git submodule update --recursive --init
```

Please be patient, this can take minutes to hours depending on the hardware and network you're running it on.

In addition to installing the various packages needed for building Redox, **bootstrap.sh** and **podman_bootstrap.sh** both clone the repository, so if you used either script, you have completed Step 1. 

## Install The Necessary Packages and Emulators

If you are unable to use [Podman Build](./ch02-06-podman-build.md), you can attempt to install the necessary packages yourself.

If you cloned the source tree *before* running **bootstrap.sh**, you can use:

```sh
cd ~/tryredox/redox
```

```sh
./bootstrap.sh -d
```

to install the build system dependencies without re-fetching any source. If you wish to install the dependencies yourself, some examples are given below.

### Pop!_OS/Ubuntu/Debian Users

Install the build system dependencies:

```sh
sudo apt-get install ant autoconf automake autopoint bison \
build-essential clang cmake curl dos2unix doxygen file flex \
fuse3 g++ genisoimage git gperf intltool libexpat-dev libfuse-dev \
libgmp-dev libhtml-parser-perl libjpeg-dev libmpfr-dev libpng-dev \
libsdl1.2-dev libsdl2-ttf-dev libtool llvm lua5.4 m4 make meson nasm \
ninja-build patch perl pkg-config po4a protobuf-compiler python3 \
python3-mako rsync scons texinfo unzip wget xdg-utils xxd zip zstd
```

- If you want to use QEMU, run:

```sh
sudo apt-get install qemu-system-x86 qemu-kvm
```

- If you want to use VirtualBox, run:

```sh
sudo apt-get install virtualbox
```

### Fedora Users

Install the build system dependencies:

```sh
sudo dnf install autoconf vim bison flex genisoimage gperf \
glibc-devel.i686 expat expat-devel fuse-devel fuse3-devel gmp-devel \
libpng-devel perl perl-HTML-Parser libtool libjpeg-turbo-devel
SDL2_ttf-devel sdl12-compat-devel m4 nasm po4a syslinux \
texinfo ninja-build meson waf python3-mako make gcc gcc-c++ \
openssl patch automake perl-Pod-Html perl-FindBin gperf curl \
gettext-devel perl-Pod-Xhtml pkgconf-pkg-config cmake llvm zip \
unzip lua luajit make clang doxygen ant protobuf-compiler zstd
```

- If you want to use QEMU, run:

```sh
sudo dnf install qemu-system-x86 qemu-kvm
```

- If you want to use VirtualBox, install from VirtualBox [Linux Downloads](https://www.virtualbox.org/wiki/Linux_Downloads) page.

### Arch Linux Users

Install the build system dependencies:

```sh
pacman -S --needed cmake fuse git gperf perl-html-parser nasm \
wget texinfo bison flex po4a autoconf curl file patch automake \
scons waf expat gmp libtool libpng libjpeg-turbo sdl12-compat \
m4 pkgconf po4a syslinux meson python python-mako make xdg-utils \
zip unzip llvm clang perl doxygen lua ant protobuf
```

- If you want to use QEMU, run:

```sh
sudo pacman -S qemu
```

- If you want to use VirtualBox, run:

```sh
sudo pacman -S virtualbox
```

### OpenSUSE Users

Install the build system dependencies:

```sh
sudo zypper install gcc gcc-c++ glibc-devel-32bit nasm make fuse-devel \
cmake openssl automake gettext-tools libtool po4a patch flex gperf autoconf \
bison curl wget file libexpat-devel gmp-devel libpng16-devel libjpeg8-devel \
perl perl-HTML-Parser m4 patch scons pkgconf syslinux-utils ninja meson python-Mako \
xdg-utils zip unzip llvm clang doxygen lua54 ant protobuf
```

- If you want to use QEMU, run:

```sh
sudo zypper install qemu-x86 qemu-kvm
```

### Gentoo Users

Install the build system dependencies:

```sh
sudo emerge dev-lang/nasm dev-vcs/git sys-fs/fuse
```

- If you want to use QEMU, run:

```sh
sudo emerge app-emulation/qemu
```

- If you want to use VirtualBox, install from VirtualBox [Linux Downloads](https://www.virtualbox.org/wiki/Linux_Downloads) page.

### FreeBSD Users

Install the build system dependencies:

```sh
sudo pkg install coreutils findutils gcc nasm pkgconf fusefs-libs3 \
cmake gmake wget openssl texinfo python automake gettext bison gperf \
autoconf curl file flex expat2 gmp png libjpeg-turbo sdl12 sdl2_ttf \
perl5.36 p5-HTML-Parser libtool m4 po4a syslinux ninja meson xdg-utils \
zip unzip llvm doxygen patch automake scons lua54 py-protobuf-compiler
```

- If you want to use QEMU, run:

```sh
sudo pkg install qemu qemu-system-x86_64
```

- If you want to use VirtualBox, run:

```sh
sudo pkg install virtualbox
```

### MacOS Users using MacPorts:

Install the build system dependencies:

```sh
sudo port install coreutils findutils gcc49 gcc-4.9 nasm pkgconfig \
osxfuse x86_64-elf-gcc cmake ninja po4a findutils texinfo autoconf \
openssl3 openssl11 bison curl wget file flex gperf expat gmp libpng \
jpeg libsdl12 libsdl2_ttf libtool m4 ninja meson python311 py37-mako \
xdg-utils zip unzip llvm-16 clang-16 perl5.24 p5-html-parser doxygen \
gpatch automake scons gmake lua protobuf-c
```

- If you want to use QEMU, run:

```sh
sudo port install qemu qemu-system-x86_64
```

- If you want to use VirtualBox, run:

```sh
sudo port install virtualbox
```

If you have some problem, try to install this Perl module:

```sh
cpan install HTML::Entities
```

### MacOS Users using Homebrew:

Install the build system dependencies:

```sh
brew install automake bison gettext libtool make nasm gcc@7 \
gcc-7 pkg-config cmake ninja po4a macfuse findutils texinfo \
openssl@1.1 openssl@3.0 autoconf curl wget flex gperf expat \
gmp libpng jpeg sdl12-compat sdl2_ttf perl libtool m4 ninja \
meson python@3.11 zip unzip llvm doxygen gpatch automake scons \
lua ant protobuf redox-os/gcc_cross_compilers/x86_64-elf-gcc x86_64-elf-gcc
```

- If you want to use QEMU, run:

```sh
brew install qemu qemu-system-x86_64
```

- If you want to use VirtualBox, run:

```sh
brew install virtualbox
```

If you have some problem, try to install this Perl module:

```sh
cpan install HTML::Entities
```

## Install Rust Stable And Nightly

Install Rust, make the nightly version your default toolchain, then list the installed toolchains:

```sh
curl https://sh.rustup.rs -sSf | sh
```

then

```sh
source ~/.cargo/env
```

```sh
rustup default nightly
```

```sh
rustup toolchain list
```

```sh
cargo install --force --version 0.1.1 cargo-config
```

NOTE: `~/.cargo/bin` has been added to your PATH for the running session.

The line `. "$HOME/.cargo/env` (equivalent to `source ~/.cargo/env`) will have been added to your shell start-up file, `~/.bashrc`, but you may wish to add it elsewhere or modify it according to your own environment.

## Prefix

The tools that build Redox are specific to each CPU architecture. These tools are located in the directory `prefix`, in a subdirectory named for the architecture, e.g. `prefix/x86_64-unknown-redox`. If you have problems with these tools, you can remove the subdirectory or even the whole `prefix` directory, which will cause the tools to be re-downloaded or rebuilt. The variable `PREFIX_BINARY` in `mk/config.mk` controls whether they are downloaded or built.

## Cookbook

The **Cookbook** system is an essential part of the Redox build system. Each Redox component package  is built and managed by the Cookbook toolset. The variable `REPO_BINARY` in `mk/config.mk` controls if the recipes are compiled from sources or use binary packages from Redox CI server, read the section [REPO_BINARY](./ch02-07-configuration-settings.md#repo_binary) for more details. See [Including Programs in Redox](./ch09-01-including-programs.md) for examples of using the Cookbook toolset. If you will be developing recipes to include in Redox, it is worthwhile to have a look at the tools in the `cookbook` directory.

## Creating a Build Environment Shell

If you are working on specific components of the system, and will be using some of the tools in the `cookbook` directory and bypassing `make`, you may wish to create a build environment shell. This shell includes the `prefix` tools in your path. You can do this with:

```sh
make env
```

This command also works with **Podman Build**, creating a shell in Podman and setting PATH to include the necessary build tools.

## Updating The Sources

If you want to update the Redox build system or if some of the recipes have changed, you can update those parts of the system with `make pull`. However, this will not update source for the recipes.

```sh
cd ~/tryredox/redox
```

```sh
make pull
```

If you want to update the source for the recipes, use `make rebuild`, or remove the file `$(BUILD)/fetch.tag` then use `make fetch`.

## Changing the filesystem size and contents

You can modify the size and contents of the filesystem for emulation and *livedisk* as described in [Configuration Settings](./ch02-07-configuration-settings.md).

## Next steps

Once this is all set up, we can finally Compile! See [Compiling The Entire Redox Project](./ch02-05-building-redox.md#compiling-the-entire-redox-project).
