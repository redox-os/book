# Building Redox

Congrats on making it this far! Now you will build Redox. This process is for **x86-64** machines (Intel/AMD). There are also similar processes for [i686](./ch08-03-i686.md) and [AArch64/Arm64](./ch08-04-aarch.md).

The build process fetches files from the Redox Gitlab server. From time to time, errors may occur which may result in you being asked to provide a username and password during the build process. If this happens, first check for typos in the `git` URL. If that doesn't solve the problem and you don't have a Redox GitLab login, try again later, and if it continues to happen, you can let us know through [chat](./ch13-01-chat.md).

(Don't forget to read [this](./ch08-06-build-system-reference.md) page to know our build system organization and how it works)

## Supported Unix-like Distributions and Podman Build

The following Unix-like systems are supported:

- Pop_OS!
- Ubuntu
- Debian
- Fedora
- Arch Linux
- OpenSUSE
- Gentoo (basic support)
- FreeBSD
- MacOSX (almost complete)
- Nix (under develoopment)
- Solus (basic support, not maintained)

If you have a weird/hard to fix problem, read the [Podman Build](./ch02-06-podman-build.md) page.

## Preparing the Build

### Bootstrap Prerequisites And Fetch Sources

If you're on a supported Linux distribution, you can just run the build system bootstrap script, which does the build preparation for you. First, ensure that you have the program `curl` installed:

(This command is for Pop!_OS, Ubuntu or Debian, adjust for your system)

```sh
which curl || sudo apt-get install curl
```

Then run the following commands:

```sh
mkdir -p ~/tryredox
```

```sh
cd ~/tryredox
```

```sh
curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/bootstrap.sh -o bootstrap.sh
```

```sh
time bash -e bootstrap.sh
```

You will be asked to confirm some steps. Answer with *y* or *1*.

To know what the `bootstrap.sh` script does, read [this](./ch08-07-build-phases.md#bootstrapsh) section.

Note that `curl -sf` operates silently, so if there are errors, you may get an empty or incorrect version of `bootstrap.sh`. Check for typos in the command and try again. If you continue to have problems, join the [chat](./ch13-01-chat.md) and let us know.

Please be patient, this can take 5 minutes to an hour depending on the hardware and network you're running it on. Once it's done, update your `PATH` environment variable in the current shell with:

```sh
source ~/.cargo/env
```

### Setting Configuration Values

The build system uses several configuration files, which contain settings that you may wish to change. These are detailed in the [Configuration Settings](./ch02-07-configuration-settings.md) page. By default, the build system cross-compile to the `x86_64` CPU architecture, using the `desktop` configuration (at `config/x86_64/desktop.toml`). Set the desired `ARCH` and `CONFIG_FILE` in [.config](./ch02-07-configuration-settings.md#config). There is also a shell script [build.sh](#buildsh) that will allow you to choose the architecture and filesystem contents easily, although it is only a temporary change.

## Compiling Redox

Now we have:

 - Downloaded the sources
 - Tweaked the settings to our liking
 - Probably added our recipe to the filesystem

We are ready to build the Redox operating system image. Skip ahead to [Configuration Settings](./ch02-07-configuration-settings.md) if you want to build for a different CPU architecture or with different filesystem contents.

### Build all system components and programs

To build all the components, and the packages to be included in the filesystem.

```sh
cd ~/tryredox/redox
```

```sh
time make all
```

This will make the target `build/x86_64/desktop/hardrive.img`, which you can run with a virtual machine.

Give it a while. Redox is big. Read [this](./ch08-07-build-phases.md#make-all-first-run) section to know what the `make all` command does.

Note that the filesystem parts are merged using the [FUSE](https://github.com/libfuse/libfuse). `bootstrap.sh` install `libfuse`. If you have problems with the final image of Redox, verify if `libfuse` is installed and you are able to use it.

### build.sh

`build.sh` is a shell script that allows you to easily specify the CPU architecture you are building for, and the filesystem contents. When you are doing Redox development, you should set them in `.config` (see [Configuration Settings](./ch02-07-configuration-settings.md)). But if you are just trying things out, use `build.sh` to run `make` for you. e.g.:

- `./build.sh -a i686 -c server live` - Run `make` for an i686 (32-bits Intel/AMD) CPU architecture, using the `server` configuration, `config/i686/server.toml`. The resulting image is `build/i686/server/livedisk.iso`, which can be used for installation from a USB.

- `./build.sh -f config/aarch64/desktop.toml qemu` - Run `make` for an ARM64 (AArch64) CPU architecture, using the `desktop` configuration, `config/aarch64/desktop.toml`. The resulting image is `build/aarch64/desktop/harddrive.img`, which is then run in the emulator **QEMU**.

If you use `build.sh`, it's recommended that you do so consistently, as `make` will not be aware of which version of the system you previously built with `build.sh`. Details of `build.sh` and other settings are described in [Configuration Settings](./ch02-07-configuration-settings.md).

### Run in a virtual machine

You can immediately run your image `build/x86_64/desktop/harddrive.img` in a virtual machine with the following command:

```sh
make qemu
```

Note that if you built the system using `build.sh` to change the CPU architecture or filesystem contents, you should also use it to run the virtual machine.

```sh
./build.sh -a i686 -c server qemu
```

will build `build/i686/server/harddrive.img` (if it does not exist) and run it in the **QEMU** emulator.

The emulator will display the Redox GUI (Orbital). See [Using the emulation](./ch02-01-running-vm.md#using-the-emulation) for general instructions and [Trying out Redox](./ch02-04-trying-out-redox.md) for things to try.

#### Run without a GUI

To run the virtual machine without a GUI, use:

```sh
make qemu vga=no
```

If you want to capture the terminal output, read [this](./ch08-05-troubleshooting.md#debug-methods) section.

If you have problems running the virtual machine, you can try `make qemu kvm=no` or `make qemu iommu=no` to turn off various virtualization features. These can also be used as arguments to `build.sh`.

#### QEMU Tap For Network Testing

Expose Redox to other computers within a LAN. Configure QEMU with a "TAP" which will allow other computers to test Redox client/server/networking capabilities.

Join the [chat](./ch13-01-chat.md) if this is something you are interested in pursuing.

### Building A Redox Bootable Image

Read [this](./ch09-02-coding-and-building.md#testing-on-real-hardware) section.

## Note

If you intend on contributing to Redox or its subprojects, please read the [CONTRIBUTING.md](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/CONTRIBUTING.md) document, so you understand how our build system works and setup your repository fork appropriately. You can use `./bootstrap.sh -d` in the `redox` folder to install the prerequisite packages if you have already done a `git clone` of the sources.

If you encounter any bugs, errors, obstructions, or other annoying things, please join the [chat](./ch13-01-chat.md) or [report the issue](./ch12-03-creating-proper-bug-reports.md) to the [Redox repository](https://gitlab.redox-os.org/redox-os/redox) or a proper repository for the component. Thanks!
