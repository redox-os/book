# ARM64

The build system supports building for multiple CPU architectures in the same directory tree. Building for `i686` or `aarch64` only requires that you set the `ARCH` environment variable to the correct value. Normally, you would do this in [.config](./ch02-07-configuration-settings.md#config), but you can also do this temporarily with the `make ARCH=aarch64` command, in the shell environment (`export ARCH=aarch64`) or with the [build.sh](./ch02-07-configuration-settings.md#buildsh) script.

ARM64 has limited support on this release (0.8.0).

## First Time Build

### Bootstrap Pre-Requisites and Download Sources

Follow the instructions for running **bootstrap.sh** to setup your environment, read the [Building Redox](./ch02-05-building-redox.md) page or the [Podman Build](./ch02-06-podman-build.md) page.

### Install QEMU

The **ARM64** emulator is not installed by `bootstrap.sh`. You can add it like this:  
Pop!_OS/Ubuntu/Debian)

```sh
sudo apt-get install qemu-system-aarch64
```

### Install Additional Tools To Build And Run ARM 64-bit Redox OS Image

```sh
sudo apt-get install u-boot-tools qemu-system-arm qemu-efi
```

### Configuration Values

Before your first build, be sure to set the `ARCH` variable in [.config](./ch02-07-configuration-settings.md#config) to your CPU architecture type, in this case `aarch64`. You can change several other configurable settings, such as the filesystem contents, etc. See [Configuration Settings](./ch02-07-configuration-settings.md).

### Add packages to the filesystem.

You can add programs to the filesystem by following the instructions [here](./ch09-01-including-programs.md).

### Advanced Users

For more details on the build process, please read the [Advanced Build](./ch08-01-advanced-build.md) page.

## Compiling Redox

Now we have:

 - Downloaded the sources
 - Set the `ARCH` to `aarch64`
 - Selected a filesystem config, e.g. `desktop`
 - Tweaked the settings to our liking
 - Probably added our recipe to the filesystem

We are ready to build the a Redox image.

### Building an image for emulation

```sh
cd ~/tryredox/redox
```

This command will create the image, e.g. `build/aarch64/desktop/hardrive.img`, which you can run with an emulator. See [Running Redox](#running-redox).

```sh
time make all
```

Give it a while. Redox is big.

Read [this](./ch08-07-build-phases.md#make-all-first-run) section to know what the command above does.

### Cleaning Previous Build Cycles

#### Cleaning Intended For Rebuilding Core Packages And Entire System

When you need to rebuild core-packages like relibc, gcc and related tools, clean the entire previous build cycle with:

```sh
cd ~/tryredox/redox/
```

```sh
rm -rf prefix/aarch64-unknown-redox/relibc-install/ cookbook/recipes/gcc/{build,sysroot,stage*} build/aarch64/*/{harddrive.img,livedisk.iso}
```

#### Cleaning Intended For Only Rebuilding Non-Core Package(s)

If you're only rebuilding a non-core package, you can partially clean the previous build cycle just enough to force the rebuilding of the Non-Core Package:

```sh
cd ~/tryredox/redox/
```

```sh
rm build/aarch64/*/{fetch.tag,harddrive.img}
```

## Running Redox

To open QEMU, run:

```sh
make qemu kvm=no vga=no
```

This should boot to Redox. The desktop GUI will be disabled, but you will be prompted to login to the Redox console.

### QEMU Tap For Network Testing

Expose Redox to other computers within a LAN. Configure QEMU with a "TAP" which will allow other computers to test Redox client/server/networking capabilities.

Join the [chat](./ch13-01-chat.md) if this is something you are interested in pursuing.

### Note

If you encounter any bugs, errors, obstructions, or other annoying things, please send a message in the [chat](./ch13-01-chat.md) or [report the issue on GitLab](./ch12-03-creating-proper-bug-reports.md). Thanks!