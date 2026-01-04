# Advanced Build

In this section, we provide the gory details that may be handy to know if you are contributing to or developing for **Redox**.

Before reading through this section, make sure you have already read:
- [Podman Build](./podman-build.md)
- [Native Build](./building-redox.md)
- [Build System Reference](./build-system-reference.md)

## Setup Your Environment

Advanced users may accomplish the same as the [**native_bootstrap.sh**](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/native_bootstrap.sh) script with the following steps:

- [Clone The Repository](#clone-the-repository)
- [Install The Necessary Packages](#install-the-necessary-packages-and-emulators)
- [Install Rust](#install-rust-stable-and-nightly)
- [Adjust Your Configuration Settings](./configuration-settings.md)
- Build the system

## Clone The Repository

- Create a directory and clone the repository

```sh
mkdir -p ~/tryredox
```

```sh
cd ~/tryredox
```

```sh
git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream
```

```sh
cd redox
```

```sh
make pull
```

Please be patient, this can take minutes to hours depending on the hardware and network you're using.

In addition to installing the various packages needed for building Redox, **native_bootstrap.sh** and **podman_bootstrap.sh** both clone the repository, so if you used either script, you have completed Step 1. 

## Install The Necessary Packages and Emulator

If you cloned the sources *before* running **native_bootstrap.sh**, you can use:

```sh
cd ~/tryredox/redox
```

```sh
./native_bootstrap.sh -d
```

If you can't use the `native_bootstrap.sh` script, you need to install at least:

- Essential compilers: GCC, Rust and Nasm
- GNU search, text, and build tools: `find`, `grep`, `make`, `patch`, `pkg-config`, and `sed`
- Other build tools: `autotools`, `cmake`, `meson`, `perl` and `python3`
- Other file tooling: `curl`, `rsync`, `tar` and `wget`
- Libraries to build GCC: `gmp`, `mpfr` and `mpc`
- Rust tooling: `cbindgen` and `just`
- FUSE (to build an image) and QEMU (to run the image)

Additional programs or libraries might be needed to build more packages. You can attempt to install the necessary packages below.

> ⚠️ **Warning:** The following commands may be outdated

> 📝 **Note:** Always use the latest stable version of the Linux or Unix-like distribution of your choice, as any outdated tools might result in unexpected build errors. Redox cross-compilation is guaranteed to work reliably only in the current Podman environment, which is Debian 13 (Trixie). 

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
sudo apt-get install qemu-system-x86 qemu-kvm qemu-system-arm qemu-system-riscv
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
sudo dnf install qemu-system-x86 qemu-kvm qemu-system-arm qemu-system-riscv
```

- If you want to use VirtualBox, install from the VirtualBox [Linux Downloads](https://www.virtualbox.org/wiki/Linux_Downloads) page.

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
sudo pacman -S qemu-system-x86 qemu-system-arm qemu-system-riscv
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

- If you want to use VirtualBox, install from the VirtualBox [Linux Downloads](https://www.virtualbox.org/wiki/Linux_Downloads) page.

### GNU Guix Users

Rust nightly isn't packaged in Guix currently, so you need a
FHS-enabled container to use rustup:

```sh
guix shell --pure --container --emulate-fhs --network --share=$HOME \
  coreutils bash curl grep gcc-toolchain@14.3.0 nss-certs \
  -- bash -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly'

guix shell --pure --container --emulate-fhs --network --share=$HOME \
  coreutils bash gcc-toolchain@14.3.0 nss-certs zlib glibc \
  -- bash -c 'export LD_LIBRARY_PATH=$(dirname $(gcc -print-file-name=libgcc_s.so.1)):$LD_LIBRARY_PATH && source ~/.cargo/env && cargo install cbindgen'
```

Then you will be able to run the actual build except for the part that
uses FUSE to build the root filesystem. Modify `tryredox/redox` in the
command below to match where your sources are:

```sh
guix shell --pure --container --emulate-fhs --network --share=$HOME \
  coreutils bash curl wget gcc-toolchain@14.3.0 pkg-config fuse nss-certs zlib \
  grep make which findutils sed gawk diffutils tar gzip perl git git-lfs \
  binutils nasm just m4 patch autoconf automake help2man texinfo xz \
  bzip2 mpfr gmp file ncurses readline flex bison python ninja cmake \
  -- bash -c '
export LD_LIBRARY_PATH="/lib64:/lib:$LD_LIBRARY_PATH"
export CI=1
source ~/.cargo/env
cd ~/tryredox/redox
make all PODMAN_BUILD=0 REPO_BINARY=1
'
```

The FUSE portion needs to run outside of a Guix shell container. To
do that, we will patch the Rust executables so they can find
`libgcc_s.so.1` under `/gnu/store` instead of `/lib` :

```sh
LIBGCC_DIR=$(guix shell --container --emulate-fhs gcc-toolchain bash coreutils \
  -- bash -c 'dirname $(readlink -f /lib64/libgcc_s.so.1)')
```

```sh
guix shell patchelf -- patchelf --set-rpath "$LIBGCC_DIR" build/fstools/bin/redox_installer
```

```sh
guix shell patchelf -- patchelf --set-rpath "$LIBGCC_DIR" build/fstools/bin/redoxfs
```

```sh
guix shell patchelf -- patchelf --set-rpath "$LIBGCC_DIR" build/fstools/bin/redoxfs-mkfs
```

Finally, you can run the image building part outside of a container
so that FUSE works and launch qemu:

```sh
guix shell make just nasm qemu -- make qemu PODMAN_BUILD=0
```

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

### MacOS Users

Please read the MacOS warning in [Advanced Podman Build](./advanced-podman-build.md#macos). We recommend you to use the Podman Build if you insist on using MacOS.

#### MacPorts

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

#### Homebrew

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

Install Rust, make the nightly version your default toolchain, list the installed toolchains, then install more Rust tooling:

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
cargo install cbindgen just
```

The `. "$HOME/.cargo/env` command (equivalent to `source ~/.cargo/env`) have been added to your shell start-up file, `~/.bashrc`, but you may wish to add it elsewhere or modify it according to your own environment.

## Customizing C compiler

Redox requires a GCC-compatible compiler for the operating system to build additional host tools. GCC for the host system is searched automatically from `PATH` environment variable with a binary named as `$GNU_TARGET-gcc` (e.g. `x86_64-linux-gnu-gcc`).

If your operating system is not Linux or if you want to use a different compiler, you can export [more environment variables](https://gitlab.redox-os.org/redox-os/redoxer#host-specific-customizations) in the `.config` file:

```sh
export REDOXER_HOST_AR=ar
export REDOXER_HOST_AS=as
export REDOXER_HOST_CC=cc
export REDOXER_HOST_CXX=c++
export REDOXER_HOST_LD=ld
export REDOXER_HOST_NM=nm
export REDOXER_HOST_OBJCOPY=objcopy
export REDOXER_HOST_OBJDUMP=objdump
export REDOXER_HOST_PKG_CONFIG=pkg-config
export REDOXER_HOST_RANLIB=ranlib
export REDOXER_HOST_READELF=readelf
export REDOXER_HOST_STRIP=strip
```

> 📝 **Note:** FreeBSD and MacOS default compiler is Clang, so their support is experimental as also using a GCC version other than 14.x (i.e. the GCC version in Debian 13). Try to set these environment variables if you find any issues in any recipe compilation.

## Prefix

In addition to build tools from the system, building Redox requires additional compilers and tools bootstrapped from your host compilers:

- GCC
- GNU Binutils
- libtool
- Rust
- Relibc

The tools that build Redox are specific to each CPU architecture. These tools are located in the directory `prefix`, in a subdirectory named for the architecture, e.g. `prefix/x86_64-unknown-redox`. If you have problems with these tools, you can remove the subdirectory or even the whole `prefix` directory, which will cause the tools to be re-downloaded or rebuilt. The variable `PREFIX_BINARY` in `mk/config.mk` controls whether they are downloaded or built.

### Prebuilt Prefix

Redox provides a [prebuilt prefix toolchain](https://static.redox-os.org/toolchain/) to make building fast. The prebuilt prefix is only suitable for use inside Podman requiring glibc version 2.41 or newer (as the Podman Build container is based on Debian 13) and not all CPU compiler targets are available for ARM-based Linux.

If your Linux distribution is not using glibc or its version is older than 2.41, you need to set `PREFIX_BINARY=0` and build your own prefix toolchain.

### Prefix: GCC

Redox compiles its own GCC, GNU Binutils and Libtool to create a cross-compilation target to Redox. The whole build takes about a half hour or less if your hardware is relatively powerful. When it's completed it generates the `gcc-install` directory containing these cross-compilers.

### Prefix: Rust

Redox OS is listed as both Tier 2 and Tier 3 [platform support](https://doc.rust-lang.org/nightly/rustc/platform-support/redox.html) on Rust. The x86_64 architecture is listed as Tier 2 target which means that Rust's libstd is available for this target.

Redox compiles its own Rust compiler to be able to build Tier 3 libstd. Fortunately, we can choose to download from rustup instead of building the Rust compiler using the environment variable: `PREFIX_USE_UPSTREAM_RUST_COMPILER` in `mk/config.mk`.

Building Rust takes about 2 hours or more (if your hardware is relatively powerful) as it's also needed to compile LLVM. If you are building for the x86_64 target, downloading Rust from rustup (the official Rust binaries) might be preferable. When it's completed it generates the `rust-install` directory containing both GCC and Rust compiler.

Note that there maybe some patches in [Redox Rust fork](https://gitlab.redox-os.org/redox-os/rust/) that has not been upstreamed, so your experience with using Rust from rustup might be different than building it.

### Prefix: Relibc

[Relibc](https://gitlab.redox-os.org/redox-os/relibc) is the [C standard library](https://en.wikipedia.org/wiki/C_standard_library) written for Redox. Relibc is needed for both GCC and Rust to compile programs.

Relibc is very active in development even with `PREFIX_BINARY=1` it will be compiled anyway so we always have the updated libc. Fortunately, compiling it is very quick. When it's completed it generates the `relibc-install` directory containing GCC and Rust bundled with updated relibc.

## Cookbook

The **Cookbook** system is an essential part of the Redox build system. Each Redox component package  is built and managed by the Cookbook toolset. The variable `REPO_BINARY` in `mk/config.mk` controls if the recipes are compiled from sources or use binary packages from Redox CI server, read the section [REPO_BINARY](./configuration-settings.md#repo_binary) for more details. See the [Including Programs in Redox](./including-programs.md) page for examples of using the Cookbook toolset. If you will be developing recipes to include in Redox.

## Creating a Build Environment Shell

If you are working on specific components of the system, and will be using some of the tools in the `redox` directory and bypassing `make`, you may wish to create a build environment shell. This shell includes the `prefix` tools in your `PATH`. You can do this with:

```sh
make env
```

This command also works with a Podman Build, creating a shell in Podman and setting `PATH` to include the necessary build tools.

## Updating The Sources

If you want to update the build system or if some of the recipes have changed, you can update those parts of the system with `make pull`. However, this will not update the sources of the recipes.

```sh
cd ~/tryredox/redox
```

```sh
make pull
```

If you want to update the source for the recipes, use `make rebuild`, or remove the file `$(BUILD)/fetch.tag` and run `make fetch`

## Changing the Filesystem Size and Contents

You can modify the size and contents of the filesystem for emulation and *livedisk* as described in the [Configuration Settings](./configuration-settings.md) page.

## Next Steps

Once this is all set up, we can finally build! See the [Compiling Redox](./building-redox.md#compiling-redox) section.
