# Advanced Build

If you intend on contributing to Redox or its subprojects, please read [Creating a Proper Pull Request](./ch06-10-creating-proper-pull-requests.html) so you understand our use of forks and set up your repository appropriately. In addition to installing the various packages needed for building Redox, **bootstrap.sh** clones the repository, so if you used **bootstrap.sh**, you have completed Step 1. If you cloned the source tree before running **bootstrap.sh**, you can use
```sh
cd ~/tryredox/redox
./bootstrap.sh -d
```
to install the package dependencies without re-fetching any source.

Although it is strongly recommended you use the [Building Redox](./ch02-05-building-redox.html) process, advanced users may accomplish the same as the **bootstrap.sh** script with the following steps, which are provided by way of example for Pop!_OS/Ubuntu/Debian. For other platforms, please use the [Building Redox](./ch02-05-building-redox.html) instructions, or have a look at the file [bootstrap.sh](https://gitlab.redox-os.org/redox-os/redox/raw/master/bootstrap.sh) to determine what packages to install for your distro.

Be forewarned, the documentation can't keep up with the bootstrap.sh script since there are so many distros from which to build Redox: MacOS, Pop!_OS/Ubuntu/Debian, Arch Linux, Redhat/Centos/Fedora.

The core redox-os developers use Pop!_OS to build Redox.  We recommend using Pop!_OS for repeatable zero-painpoint Redox builds.

The steps to perform are 1 - [Clone the repository](#clone-the-repository), 2 - [Install the Pre-requisite packages](#install-pre-requisite-packages-and-emulators), and 3 - [Install Rust](#install-rust-stable-and-nightly).

### Clone the repository

Create a directory and clone the repository.

 ```sh
mkdir -p ~/tryredox
cd ~/tryredox
git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive
cd redox
git submodule update --recursive --init
 ```
Please be patient this can take 5 minutes to an hour depending on the hardware and network you're running it on.


### Install Pre-Requisite Packages and Emulators

#### Pop!_OS/Ubuntu/Debian Users:

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
sudo apt-get install vitualbox
```

If you intend to include **Rust** in your filesystem config, or any of the games with graphics,
```sh
sudo apt-get install libsdl1.2-dev ninja-build meson python3-mako
```

#### Arch Linux Users:
```sh
sudo pacman -S cmake fuse git gperf perl-html-parser nasm wget texinfo bison flex po4a rsync inetutils
```

#### Fedora/Redhat/Centos Linux Users:

```
sudo dnf install cmake make nasm qemu pkg-config fuse-devel gperf perl-HTML-Parser po4a automake gcc gcc-c++ glibc-devel.i686
sudo dnf install gettext-devel bison flex libtool perl-Pod-Xhtml libpng-devel patch texinfo  perl-FindBin
```

#### MacOS Users using MacPorts:

```
sudo port install make nasm qemu qemu-system-x86_64 gcc7 pkg-config osxfuse x86_64-elf-gcc coreutils findutils gcc49 gcc-4.9 nasm pkgconfig osxfuse x86_64-elf-gcc cmake
```

#### MacOS Users using Homebrew:

```
brew install automake bison gettext libtool make nasm qemu gcc@7 pkg-config Caskroom/cask/osxfuse
brew install redox-os/gcc_cross_compilers/x86_64-elf-gcc
```

### Install Rust Stable And Nightly

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

NOTE: **xargo** allows redox-os to have a custom `libstd`

NOTE: `~/.cargo/bin` has been added to your PATH for the running session.

The line `. "$HOME/.cargo/env` (equivalent to `source ~/.cargo/env`) will have been added to your shell start-up file, `~/.bashrc`, but you may wish to add it elsewhere or modify it according to your own environment.

### Updating The Sources

#### How to update submodules using make pull

```
cd ~/tryredox/redox
make pull
```

#### How to update package sources using make fetch

```
cd ~/tryredox/redox
make fetch
```

### Tweaking the filesystem size and contents

You can modify the size and contents of the filesystem for emulation and *livedisk* as described in [Setting Config Values](./ch02-05-building-redox.html#setting-config-values).

Note that you can also set configuration values on the `make` command line, for those values that are set in `mk/config.mk` using the "?=" operator. However, do this with caution as `make` will not keep track of these changes as it would with editing `mk/config.mk`, so you may not get the result you are expecting. If you are confident that this is what you want, you can for example, do:
```sh
FILESYSTEM_SIZE=1024 FILESYSTEM_CONFIG=config/x86_64/server.toml make rebuild
```

Next steps
----------

Once this is all set up, we can finally Compile! See [Compiling The Entire Redox Project](./ch02-05-building-redox.html#compiling-the-entire-redox-project).
