# Working with AArch64/Arm64

If you are working with multiple architecture targets, e.g. x86_64 and AArch64, it is recommended that you have a separate clone of the repository for each architecture. This will help avoid fiddling with config values and build objects, which can result in hard to debug problems. Remember to set your **Config Values** (see below) before starting your first build.

AArch64 has limited support in this release (0.8.0), proceed at your own risk.

## FIRST TIME BUILD

### Bootstrap Pre-Requisites And Fetch Sources

Run the following commands, as with the x86_64 preparation:

```sh
$ sudo apt-get install curl
$ mkdir -p ~/redox-aarch64
$ cd ~/redox-aarch64
$ curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/bootstrap.sh -o bootstrap.sh
$ time bash -e bootstrap.sh
```

You will be asked to confirm various installations. Answer in the affirmative (*y* or *1* as appropriate).
The above does the following:
 - creates a parent folder called "redox-aarch64". Within that folder, it will create another folder called "redox" where all the sources will reside.
 - installs the pre-requisite packages using your operating system's package manager(Pop!_OS/Ubuntu/Debian apt, Redhat/Centos/Fedora dnf, Arch Linux pacman).
 - clones the Redox code from GitLab and checks out a redox-team tagged version of the different subprojects intended for the community to test and submit success/bug reports for.

Please be patient, this can take 5 minutes to an hour depending on the hardware and network you're running it on. Once it completes, update your path in the current shell with
```sh
$ source ~/.cargo/env
```

### Install Emulator Package

The **aarch64** emulator is not installed by bootstrap.sh. You can add it like this:
```sh
$ sudo apt-get install qemu-system-aarch64
```

### Config Values

Before your first build, be sure to set the **ARCH** variable to your architecture type, in this case **aarch64**.

You can also adjust the **FILESYSTEM_SIZE** for the emulation or the *livedisk* in-memory filesystem. The filesystem size is specified in MegaBytes.  The default is 256MB. You might want a bigger size, like 2GB(2048MB). For the *livedisk* system, don't exceed the size of your RAM, and leave room for the system to run.

The set of packages to be installed in the filesystem is determined by **FILESYSTEM_CONFIG**. which points to a `.toml` file in the folder `config/$ARCH`, e.g. `config/$(ARCH)/desktop.toml`. There are a few samples provided. Set it to point to your preferred filesystem contents, or copy one and edit it to create your own.

 - Open with your favourite text editor(vim or emacs) **redox/mk/config.mk**, and search for each of these values.
   ```
   $ cd ~/redox-aarch64/redox
   $ gedit mk/config.mk &
   
   ARCH?=aarch64
   ...
   FILESYSTEM_CONFIG=config/$(ARCH)/desktop.toml
   ...
   FILESYSTEM_SIZE?=2048
   ...

   ```

There are several other settings you can modify, have a look at **redox/mk/config.mk** to see what applies to you. 

### Add packages to the filesystem.

You can add programs to the filesystem by following the instructions [here](./ch05-03-compiling-program.html).

ADVANCED USERS
--------------

Although it is strongly recommended you use the FIRST TIME BUILD process above, advanced users may accomplish the same as the **bootstrap.sh** script with the following steps. If you have problems, you can run `bootstrap.sh -d` to try to resolve missing package dependencies.

The steps to perform are 1 - **Clone the repository**, 2 - **Install the Pre-requisite packages**, and 3 - **Install Rust**.

### Clone the repository

Create a directory and clone the repository.

 ```sh
$ mkdir -p ~/redox-aarch64
$ cd ~/redox-aarch64
$ git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive
$ cd redox
$ git submodule update --recursive --init
 ```
Please be patient this can take 5 minutes to an hour depending on the hardware and network you're running it on.

After cloning the repository, change your **Config Values** as described above, and in particular, set **ARCH** to **aarch64** before your first make.


### Install Pre-Requisite Packages and Emulators

#### Pop!_OS/Ubuntu/Debian Users:

```sh
$ sudo apt-get install autoconf autopoint bison build-essential cmake curl file 
$ sudo apt-get install flex genisoimage git gperf m4 nasm pkg-config po4a 
$ sudo apt-get install libc6-dev-i386 libexpat-dev libfuse-dev libgmp-dev 
$ sudo apt-get install libhtml-parser-perl libpng-dev libtool syslinux-utils texinfo

$ sudo apt-get install qemu-system-aarch
or
$ sudo apt-get install vitualbox
```


### Install Rust Stable And Nightly

Install Rust, make the nightly version your default toolchain, the list the installed toolchains:

```sh
$ curl https://sh.rustup.rs -sSf | sh
$ source ~/.cargo/env
$ rustup default nightly
$ rustup toolchain list
$ cargo install --force --version 0.3.20 xargo
$ cargo install --force --version 0.1.1 cargo-config
```

NOTE: **xargo** allows redox-os to have a custom `libstd`

NOTE: `~/.cargo/bin` has been added to your PATH for the running session.

The line `. "$HOME/.cargo/env` will have been added to your shell start-up file, `~/.bashrc`, but you may wish to add it elsewhere or modify it according to your own environment.

### Updating The Sources

#### How to update submodules using make pull

```
cd ~/redox-aarch64/redox
make pull
```

#### How to update package sources using make fetch

```
cd ~/redox-aarch64/redox
make fetch
```

### Install Additional Tools To Build And Run ARM 64-bit Redox OS Image
```
sudo apt-get install u-boot-tools
sudo apt-get install qemu-system-arm qemu-efi
```

### Tweaking the filesystem size and contents

You can modify the size and contents of the filesystem for emulation and *livedisk* as described in the FIRST-TIME BUILD section above.

Compiling The Entire Redox Project
--------------------------------

Now we have:
 - set the **ARCH** to **aarch64**
 - fetched the sources
 - tweaked the settings to our liking
 - possibly added our very own source/binary package to the filesystem

We are ready to build the entire Redox Operating System Image.

### Build Redox images

#### Building an image for emulation
```sh
$ cd ~/redox-aarch64/redox
$ time ./bootstrap.sh -d
$ time make all
```
will make the target `build/hardrive.img`, which you can run with an emulator. See **Running Redox** below.

Give it a while. Redox is big.
- The two main targets `build/harddrive.img` and `build/livedisk.iso` fetch some sources for the core tools from the Redox-os source servers, then builds them.  As it progressively cooks each package, it fetches the respective package's sources and builds it.
- creates a few empty files holding different parts of the final image filesystem.
- using the newly built core tools, it builds the non-core packages into one of those filesystem parts
- fills the remaining filesystem parts appropriately with stuff built by the core tools to help boot Redox.
- merges the the different filesystem parts into a final Redox Operating System respective image ready-to-run in Qemu.

#### Building Redox for **aarch64/arm64**
```sh
$ cd ~/redox-aarch64/redox/
$ time ./bootstrap.sh -d
$ time ARCH=aarch64 make kvm=no vga=no qemu
```

#### Cleaning Previous Build Cycles

##### Cleaning Intended For Rebuilding Core Packages And Entire System

When you need to rebuild core-packages like relibc, gcc and related tools, clean the entire previous build cycle with:
```
$ cd ~/redox-aarch64/redox/
$ rm -rf prefix/x86_64-unknown-redox/relibc-install/ cookbook/recipes/gcc/{build,sysroot,stage*} build/harddrive.img
```

or try touching:
```
$ cd ~/redox-aarch64/redox/
$ touch initfs.toml
$ touch filesystem.toml
```

##### Cleaning Intended For Only Rebuilding Non-Core Package(s)
If you're only rebuilding a non-core package,
you partially clean the previous build cycle just enough to force rebuilding the Non-Core Package:
```
$ cd ~/redox-aarch64/redox/
$ rm build/harddrive.img
```

or try touching:
```
$ cd ~/redox-aarch64/redox/
$ touch filesystem.toml
```

Running Redox
-------------

#### Running The Redox Desktop

To run Redox, do:
```sh
$ make qemu kvm=no vga=no
```
This should boot to Redox. The desktop GUI will be disabled, but you will be prompted to login to the Redox console.

#### Running The Redox Console With A Qemu Tap For Network Testing

Expose Redox to other computers within a LAN. Configure Qemu with a "TAP" which will allow other computers to test Redox client/server/networking capabilities.

Here are the steps to configure Qemu Tap:
**WIP**

Note
----

If you encounter any bugs, errors, obstructions, or other annoying things, please report the issue to the [Redox repository]. Thanks!

[Redox repository]: https://gitlab.redox-os.org/redox-os/redox
