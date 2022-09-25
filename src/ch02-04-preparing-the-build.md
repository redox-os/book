Preparing the build
===================

Woah! You made it this far, all the way to here. Congrats! Now we gotta build Redox.

The build process fetches files from the Redox Gitlab server. From time to time, files in gitlab might be marked private temporarily, which may result in you being asked to provide a username and password during the build process. If this happens and you don't have a Redox gitlab login, try again later, and if it continues to happen, you can let us know through [chat](./ch06-03-chat.html), or send an email to [info@redox-os.org](mailto:info@redox-os.org)

FIRST TIME BUILD (Recommended)
--------------------

### Bootstrap Pre-Requisites And Fetch Sources

If you're on a Linux or macOS computer, you can just run the bootstrapping script, which does the build preparation for you. Run the following commands:

```sh
$ mkdir -p ~/tryredox
$ cd ~/tryredox
$ curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/bootstrap.sh -o bootstrap.sh
$ bash -e bootstrap.sh
```
You will be asked to confirm various installations. Answer in the affirmative (*y* or *1* as appropriate).
The above does the following:
 - creates a parent folder called "tryredox". Within that folder, it will create another folder called "redox" where all the sources will reside.
 - installs the pre-requisite packages using your operating system's package manager(popos/ubuntu/debian apt, redhat/centos/fedora dnf, archlinux pacman).
 - clones the Redox code from GitLab and checks out a redox-team tagged version of the different subprojects intended for the community to test and submit success/bug reports for.

Please be patient, this can take 5 minutes to an hour depending on the hardware and network you're running it on. Once it completes, update your path in the current shell with
```sh
$ source ~/.cargo/env
```

### Tweaking the filesystem size and contents

The filesystem size is specified in MegaBytes.  The default is 256MB.

You might want a bigger size, like 2GB(2048MB). For the *livedisk* system, don't exceed the size of your RAM, and leave room for the system to run.
 - Open with your favourite text editor(vim or emacs) **redox/mk/config.mk**
   ```
   $ cd ~/tryredox/redox
   $ gedit mk/config.mk &
   ```
 - Look for **FILESYSTEM_SIZE** and change the value in MegaBytes
   ```
   FILESYSTEM_SIZE?=2048
   ```

You can add programs to the filesystem by following the instructions [here](./ch05-03-compiling-program.html).

ADVANCED USERS
--------------

Advanced users may accomplish the same as the above bootstrap.sh script with the following steps.

Be forewarned, the documentation can't keep up with the bootstrap.sh script since there are so many distros from which to build Redox: MacOS, Pop!_OS/Ubuntu/Debian, Arch Linux, Redhat/Centos/Fedora.

NOTE:  The core redox-os developers use Pop!_OS to build Redox.  We recommend using Pop!_OS for repeatable zero-painpoint Redox builds.

### Clone the repository

Create a directory and clone the repository.

 ```sh
$ mkdir -p ~/tryredox
$ cd ~/tryredox
$ git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive
$ cd redox
$ git submodule update --recursive --init
 ```
Please be patient this can take 5 minutes to an hour depending on the hardware and network you're running it on.


### Install Pre-Requisite Packages and Emulators

#### Pop!_OS/Ubuntu/Debian Users:

```
$ sudo apt-get install autoconf autopoint bison build-essential cmake curl file flex genisoimage git gperf 
$ sudo apt-get install libc6-dev-i386 libexpat-dev libfuse-dev libgmp-dev libhtml-parser-perl libpng-dev libtool
$ sudo apt-get install m4 nasm pkg-config po4a syslinux-utils texinfo

$ sudo apt-get qemu qemu-system-x86
or
$ sudo apt-get vitualbox
```

#### ArchLinux Users:

```
$ sudo pacman -S cmake make nasm qemu pkg-config libfuse-dev wget gperf libhtml-parser-perl autoconf flex autogen po4a expat openssl automake aclocal
```

#### Fedora/Redhat/Centos Linux Users:

```
$ sudo dnf install cmake make nasm qemu pkg-config libfuse-dev wget gperf libhtml-parser-perl autoconf flex autogen po4a expat openssl automake aclocal
$ sudo dnf install gettext-devel bison flex perl-HTML-Parser libtool perl-Pod-Xhtml gperf libpng-devel patch
$ sudo dnf install perl-Pod-Html
```

#### MacOS Users using MacPorts:

```
$ sudo port install make nasm qemu gcc7 pkg-config osxfuse x86_64-elf-gcc
```

#### MacOS Users using Homebrew:

```
$ brew install automake bison gettext libtool make nasm qemu gcc@7 pkg-config Caskroom/cask/osxfuse
$ brew install redox-os/gcc_cross_compilers/x86_64-elf-gcc
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

NOTE: **~/.cargo/bin** has been added to your PATH for the running session.

The line `. "$HOME/.cargo/env` will have been added to your shell start-up file, ".bashrc", but you may wish to add it elsewhere or modify it according to your own environment.

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

### Change Sources To Build ARM 64-bit Redox OS Image
WIP this section needs more work
```
cd ~/tryredox/redox
make distclean # important to remove x86_64 stuff
git remote update
git fetch
git restore mk/config.mk
git checkout aarch64-rebase
git pull
git submodule update --init --recursive
git rev-parse HEAD
git pull
```

### Install Additional Tools To Build And Run ARM 64-bit Redox OS Image
```
sudo apt-get install u-boot-tools
sudo apt-get install qemu-system-arm qemu-efi
```

### Tweaking the filesystem size and contents

You can modify the size and contents of the filesystem for emulation and liveboot as described in the FIRST-TIME BUILD section above.

Next steps
----------

Once this is all set up, we can finally [compile Redox](./ch02-05-compiling-redox.html).
