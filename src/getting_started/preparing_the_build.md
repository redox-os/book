Preparing the build.
====================

Woah! You made it so far, all the way to here. Congrats! Now we gotta build Redox.

Using the bootstrap Script
--------------------------

If you're on a Linux or Mac OS computer, you can just run the bootstrapping script, which does the build preparation for you. Change to the folder where you want the source code to live and run the following command:

```sh
$ curl -sf https://raw.githubusercontent.com/redox-os/redox/master/bootstrap.sh -o bootstrap.sh && bash -e bootstrap.sh
```

This script fetches build dependencies using a package manager for your platform and clones the Redox code from Github. It checks whether you might already have a dependency and skips the installation in this case. On some systems this is simply done by checking whether the binary exists and doesn't take into account which version of the program you have. This can lead to build errors if you have old versions already installed. In this case, please install the skipped dependencies manually.

Manual Setup
------------

### Cloning the repository

Change to the folder where you want your copy of Redox to be stored and issue the following command:

 ```sh
 $ git clone https://github.com/redox-os/redox.git --origin upstream --recursive && \
    cd redox && git submodule update --recursive --init
 ```

 Give it a while. Redox is big.


### Installing the build dependencies

I assume you have a package manager, which you know how to use (if not, you have to install the build dependencies even more manually). We need the following deps: `make` (probably already installed), `nasm` (the assembler, we use in the build process), `qemu` (the hardware emulator, we will use. If you want to run Redox on real hardware, you should read the `fun` chapter):)

Linux Users:

```
$ [your package manager] install make nasm qemu pkg-config libfuse-dev
```

MacOS Users using MacPorts:

```
$ sudo port install make nasm qemu gcc49 pkg-config osxfuse x86_64-elf-gcc
```

MacOS Users using Homebrew:

```
$ brew install make nasm qemu gcc49 pkg-config Caskroom/cask/osxfuse
$ brew tap glendc/gcc_cross_compilers
$ brew install glendc/gcc_cross_compilers/x64-elf-binutils glendc/gcc_cross_compilers/x64-elf-gcc
```

Setting Up Nightly Rust
-----------------------

While the following step is not _required_, it is recommended. If you already have a functioning Rust nightly installation, you can skip this step:

We will use `rustup` to manage our Rust versions:

```sh
$ curl https://sh.rustup.rs -sSf | sh
```

Rustup will install the `stable` version of Rust. To run Redox, you have to install the `nightly` version of Rust, like this:

```sh
$ rustup toolchain install nightly
$ rustup override set nightly
```
