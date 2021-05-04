Preparing the build
===================

Woah! You made it so far, all the way to here. Congrats! Now we gotta build Redox.

FIRST-TIME BEGINNERS
--------------------

### Bootstrap Pre-Requisites And Fetch Sources

If you're on a Linux or macOS computer, you can just run the bootstrapping script, which does the build preparation for you. Run the following commands:

```sh
$ mkdir -p ~/tryredox
$ cd ~/tryredox
$ curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/bootstrap.sh -o bootstrap.sh
$ bash -e bootstrap.sh
```

The above does the following:
 - creates a parent folder called "tryredox". Within that folder, it will create another folder called "redox" where all the sources will reside.
 - installs the pre-requisite packages using your operating system's package manager(popos/ubuntu/debian apt, redhat/centos/fedora dnf, archlinux pacman).
 - clones the Redox code from GitLab and checks out a redox-team tagged version of the different subprojects intended for the community to test and submit success/bug reports for.

Please be patient this can take 5 minutes to an hour depending on the hardware and network you're running it on.

### Tweaking the filesystem size

The filesystem size is specified in MegaBytes.  The default is 256MB.

You probably might want a bigger size like 20GB(20480MB).
 - Open with your favourite text editor(vim or emacs) **redox/mk/config.mk**
   ```
   cd ~/tryredox/
   gedit redox/mk/config.mk &
   ```
 - Look for **FILESYSTEM_SIZE** and change the value in MegaBytes
   ```
   FILESYSTEM_SIZE?=20480
   ```

### Customize Settings In config.mk Before Starting To Build

WIP this section needs more work.

Open with your favourite text editor(vim or emacs) **redox/mk/config.mk**

**What are the interesting settings users might want to change?**

Advanced Users
--------------

Advanced users may accomplish the same as the above bootstrap.sh script with the following steps.

Be forewarned, the documentation can't keep up with the bootstrap.sh script since there are so many distros from which to build Redox-Os from: MacOS, PopOS, Archlinux, Redhat/Centos/Fedora.

NOTE:  The core redox-os developers use PopOs to build Redox-Os.  We recommend to use PopOs for repeatable zero-painpoint Redox-os builds.

### Clone the repository

Change to the folder where you want your copy of Redox to be stored and issue the following command:

 ```sh
$ mkdir -p ~/tryredox
$ cd ~/tryredox
$ git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive
$ cd redox
$ git submodule update --recursive --init
 ```
Please be patient this can take 5 minutes to an hour depending on the hardware and network you're running it on.


### Install Pre-Requisite Packages

#### Linux Users:

```
$ [your package manager] install cmake make nasm qemu pkg-config libfuse-dev wget gperf libhtml-parser-perl autoconf flex autogen po4a expat
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

Install Rust Stable And Nightly
-------------------------------

Install Rust, make the nightly version your default toolchain, the list the installed toolchains:

```sh
$ curl https://sh.rustup.rs -sSf | sh
$ rustup default nightly
$ rustup toolchain list
$ cargo install --force --version 0.3.20 xargo
```

NOTE: **xargo** allows redox-os to have a custom `libstd`

NOTE: **~/.cargo/bin** has been added to your PATH for the running session.

Add the following line to your shell start-up file, like ".bashrc" or ".bash_profile" for future rust sessions:
```
export PATH=${PATH}:~/.cargo/bin
```

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

Next steps
----------

Once this is all set up, we can finally [compile Redox](./ch02-05-compiling-redox.md).
