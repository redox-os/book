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


### Add Your Own Packages Or Other Packages Before Starting To Build

We'll practice with two small examples **rdxhelloworld** and **rdxhellorocket**

#### rdxhelloworld : Step 1 Create The Default Rust Project And Name It

Open the terminal, and run:
```
cd ~/tryredox/
cargo new rdxhelloworld --bin
```

#### rdxhelloworld : Step 2 Initialize It As A Git Repository

```
cd ~/tryredox/rdxhelloworld
rm -rf .git
git init
```

#### rdxhelloworld : Step 3 Add The Files To The Git Repository

Add all the files by running
```
git add Cargo.toml src/main.rs
```

#### rdxhelloworld : Step 4 Add A bin section to Cargo.toml

Open up Cargo.toml
```
cd ~/tryredox/rdxhelloworld
gedit Cargo.toml &
```

and add the following at the bottom of the file:
```
[[bin]]
name = "rdxhelloworld"
path = "src/main.rs"
```

#### rdxhelloworld : Step 5 Commit The Changes To The Files To The Git Repository

```
git commit -m "Added files to rdxhelloworld" Cargo.toml src/main.rs
```

#### rdxhelloworld : Step 6 Create Your Custom Redox Package recipe.sh

Add a recipe to redox-os cookbook that points where to find the sources to build.
It will fetch them, place them and build them within **~/tryredox/redox/cookbook/recipes/rdxhelloworld/** when "make all" is invoked.

Create a respective package directory and open up a **recipe.sh** file
```
cd ~/tryredox
mkdir -p redox/cookbook/recipes/rdxhelloworld
gedit redox/cookbook/recipes/rdxhelloworld/recipe.sh &
```

and fill it with this:
```
GIT=/home/david/tryredox/rdxhelloworld/
```

#### rdxhelloworld : Step 7 Add Your Package To Redox Filesystem.toml

```
cd ~/tryredox
gedit redox/filesystem.toml &
```

within the packages section add rdxhelloworld like this
```
[packages]
rdxhelloworld = {}
```

Ok we're done.  After the build is done, this package's binary will appear in the redox image as **/bin/rdxhelloworld**

#### rdxhellorocket : Step 1 Create The Default Rust Project And Name It

Let's start again with the rdxhellorocket rust project, git repo, redox cookbook recipe and redox filesystem package to help clarify the pattern.

Open the terminal, and run:
```
cd ~/tryredox/
cargo new rdxhellorocket --bin
```

#### rdxhellorocket : Step 2 Initialize It As A Git Repository

```
cd ~/tryredox/rdxhellorocket
rm -rf .git
git init
```

#### rdxhellorocket : Step 3 Add The Files To The Git Repository

Add all the files by running
```
git add Cargo.toml src/main.rs
```

#### rdxhellorocket : Step 4.1 Add A bin section to Cargo.toml

Open up Cargo.toml
```
cd ~/tryredox/rdxhellorocket
gedit Cargo.toml &
```

and add the following at the bottom of the file:
```
[[bin]]
name = "rdxhellorocket"
path = "src/main.rs"
```

also add Rocket as a dependency:
```
[dependencies]
rocket = "0.4.6"
```

#### rdxhellorocket : Step 4.2 Add Rocket HelloRocket Main Code to src/main.rs

https://rocket.rs/v0.4/guide/getting-started/#hello-world

Open up src/main.rs
```
cd ~/tryredox/rdxhellorocket
gedit src/main.rs &
```

and replace its contents with the following:
```
#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;

#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

fn main() {
    rocket::ignite().mount("/", routes![index]).launch();
}
```

#### rdxhellorocket : Step 5 Commit The Changes To The Files To The Git Repository

```
git commit -m "Added files to rdxhellorocket" Cargo.toml src/main.rs
```

#### rdxhellorocket : Step 6 Create Your Custom Redox Package recipe.sh

Add a recipe to redox-os cookbook that points where to find the sources to build.
It will fetch them, place them and build them within **~/tryredox/redox/cookbook/recipes/rdxhellorocket/** when "make all" is invoked.

Create a respective package directory and open up a **recipe.sh** file
```
cd ~/tryredox
mkdir -p redox/cookbook/recipes/rdxhellorocket
gedit redox/cookbook/recipes/rdxhellorocket/recipe.sh &
```

and fill it with this:
```
GIT=/home/david/tryredox/rdxhellorocket/
```

#### rdxhellorocket : Step 7 Add Your Package To Redox Filesystem.toml

```
cd ~/tryredox
gedit redox/filesystem.toml &
```

within the packages section add rdxhellorocket like this
```
[packages]
rdxhellorocket = {}
```

Ok we're done.  After the build is done, this package's binary will appear in the redox image as **/bin/rdxhellorocket**

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
WIP this section needs more work

** which one should we do first? make pull or make fetch?**

```
cd ~/tryredox/redox
make pull
```
#### How to update package sources using make fetch
WIP this section needs more work

** which one should we do first? make pull or make fetch?**

```
cd ~/tryredox/redox
make fetch
```

### Change Sources To Build ARM 64-bit Redox-Os Image
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

Next steps
----------

Once this is all set up, we can finally [compile Redox](./ch02-05-compiling-redox.md).
