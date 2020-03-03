Preparing the build
===================

Woah! You made it so far, all the way to here. Congrats! Now we gotta build Redox.

Using the bootstrap Script
--------------------------

If you're on a Linux or macOS computer, you can just run the bootstrapping script, which does the build preparation for you. Change to the folder where you want the source code to live and run the following command:

```sh
$ curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/bootstrap.sh -o bootstrap.sh && bash -e bootstrap.sh
```

This script fetches build dependencies using a package manager for your platform and clones the Redox code from GitLab. It checks whether you might already have a dependency and skips the installation in this case. On some systems this is simply done by checking whether the binary exists and doesn't take into account which version of the program you have. This can lead to build errors if you have old versions already installed. In this case, please install the skipped dependencies manually.

Manual Setup
------------

### Cloning the repository

Change to the folder where you want your copy of Redox to be stored and issue the following command:

 ```sh
 $ git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive && \
    cd redox && git submodule update --recursive --init
 ```

 Give it a while. Redox is big.


### Installing the build dependencies

I assume you have a package manager, which you know how to use (if not, you have to install the build dependencies even more manually). We need the following deps: `make` (probably already installed), `nasm` (the assembler, we use in the build process), `qemu` (the hardware emulator, we will use. If you want to run Redox on real hardware, you should read the `fun` chapter):)

Linux Users:

```
$ [your package manager] install cmake make nasm qemu pkg-config libfuse-dev wget gperf libhtml-parser-perl autoconf flex autogen
```

MacOS Users using MacPorts:

```
$ sudo port install make nasm qemu gcc7 pkg-config osxfuse x86_64-elf-gcc
```

MacOS Users using Homebrew:

```
$ brew install automake bison gettext libtool make nasm qemu gcc@7 pkg-config Caskroom/cask/osxfuse
$ brew install redox-os/gcc_cross_compilers/x86_64-elf-gcc
```

Setting Up Nightly Rust
-----------------------

The following step is not required _if_ you already have a functioning Rust nightly installation. Nightly is required.

We will use `rustup` to manage our Rust versions:

```sh
$ curl https://sh.rustup.rs -sSf | sh
```

You may need to run rustup to install the recommended nightly version.

There is one more tool we need from Rust to install Redox. It is called Xargo. Xargo allows us to have a custom `libstd`
```sh
$ cargo install xargo
```

Once it is installed, add its install directory to your path by running the following
```sh
$ export PATH=${PATH}:~/.cargo/bin
```
This line can be added to your shell start-up file, like .bashrc, so that it is automatically set up for you in future.

Next steps
----------

Once this is all set up, we can finally [compile Redox](./ch02-05-compiling-redox.md).
