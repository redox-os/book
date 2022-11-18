# Working with AArch64/Arm64

The Redox Build system now supports building for multiple processor architectures in the same directory tree. Building for `i686` or `aarch64` only requires that you set the `ARCH` Make variable to the correct value. Normally, you would do this in `mk/config.mk`, but you can also do this temporarily in the environment (`export ARCH=aarch64`) or you can use [build.sh](./ch02-06-configuration-settings.html#buildsh).

AArch64 has limited support in this release (0.8.0), proceed at your own risk.

## FIRST TIME BUILD

### Bootstrap Pre-Requisites And Fetch Sources

Follow the instructions for running **bootstrap.sh** to set up your environment - [Building Redox](./ch02-05-building-redox.html) or [Podman Build](./ch02-08-podman-build.html).

### Install Emulator Package

The **aarch64** emulator is not installed by `bootstrap.sh`. You can add it like this:  
Pop!_OS/Ubuntu/Debian)
```sh
sudo apt-get install qemu-system-aarch64
```

### Install Additional Tools To Build And Run ARM 64-bit Redox OS Image
```sh
sudo apt-get install u-boot-tools
sudo apt-get install qemu-system-arm qemu-efi
```

### Config Values

Before your first build, be sure to set the `ARCH` variable in `mk/config.mk` to your architecture type, in this case `aarch64`. You can change several other configurable settings, such as the filesystem contents, etc. See [Configuration Settings](./ch02-06-configuration-settings.html).

### Add packages to the filesystem.

You can add programs to the filesystem by following the instructions [here](./ch05-03-including-programs.html).

### ADVANCED USERS

For more details on the build process, please read [Advanced Build](./ch02-07-advanced-build.html).

## Compiling The Entire Redox Project

Now we have:
 - fetched the sources
 - set the `ARCH` to `aarch64`
 - selected a filesystem config, e.g. `desktop`
 - tweaked the settings to our liking
 - possibly added our very own source/binary package to the filesystem

We are ready to build the entire Redox Operating System Image.

### Building an image for emulation
```sh
cd ~/tryredox/redox
time make all
```
will make the target, e.g. `build/aarch64/desktop/hardrive.img`, which you can run with an emulator. See [Running Redox](#running-redox).

Give it a while. Redox is big.

The main target, e.g. `build/aarch64/desktop/harddrive.img` will do the following:
- fetch some sources for the core tools from the redox-os gitlab servers, then builds them; as it progressively cooks each package, it fetches the respective package's source and builds it
- creates a few empty files holding different parts of the final image filesystem
- using the newly built core tools, it builds the non-core packages into one of those filesystem parts
- fills the remaining filesystem parts appropriately with stuff built by the core tools to help boot Redox
- merges the the different filesystem parts into a final Redox Operating System image ready to run in Qemu.

### Cleaning Previous Build Cycles

#### Cleaning Intended For Rebuilding Core Packages And Entire System

When you need to rebuild core-packages like relibc, gcc and related tools, clean the entire previous build cycle with:
```
cd ~/tryredox/redox/
rm -rf prefix/aarch64-unknown-redox/relibc-install/ cookbook/recipes/gcc/{build,sysroot,stage*} build/aarch64/*/{harddrive.img,livedisk.iso}
```

#### Cleaning Intended For Only Rebuilding Non-Core Package(s)

If you're only rebuilding a non-core package, you can partially clean the previous build cycle just enough to force the rebuilding of the Non-Core Package:
```
cd ~/tryredox/redox/
rm build/aarch64/*/{fetch.tag,harddrive.img}
```

## Running Redox

To run Redox, do:
```sh
make qemu kvm=no vga=no
```
This should boot to Redox. The desktop GUI will be disabled, but you will be prompted to login to the Redox console.

### Running The Redox Console With A Qemu Tap For Network Testing

Expose Redox to other computers within a LAN. Configure Qemu with a "TAP" which will allow other computers to test Redox client/server/networking capabilities.

Join the [Redox chat](./ch06-03-chat.html) if this is something you are interested in pursuing.

### Note

If you encounter any bugs, errors, obstructions, or other annoying things, please report the issue to the [Redox repository]. Thanks!

[Redox repository]: https://gitlab.redox-os.org/redox-os/redox
