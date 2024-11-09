# Building Redox

Congrats on making it this far! Now you will build Redox. This process is for **x86-64** machines (Intel/AMD). There are also similar processes for [i686](./i686.md) and [AArch64/Arm64](./aarch64.md).

The build process fetches files from the Redox Gitlab server. From time to time, errors may occur which may result in you being asked to provide a username and password during the build process. If this happens, first check for typos in the `git` URL. If that doesn't solve the problem and you don't have a Redox GitLab login, try again later, and if it continues to happen, you can let us know through [chat](./chat.md).

To avoid bugs from different build environments (operating systems) we are using **Rootless Podman** for major parts of the build. **Podman** is invoked automatically and transparently within the Makefiles.

The TL;DR version is [here](#tldr---new-or-existing-working-directory). More details are available in [Advanced Podman Build](./advanced-podman-build.md).

You can find out more about Podman [here](https://docs.podman.io/en/latest/Introduction.html).

(Don't forget to read [this](./build-system-reference.md) page to know our build system organization and how it works)

## Podman Build Overview

**Podman** is a **container manager** that creates **containers** to execute a Linux distribution **image**. In our case, we are creating an **Debian** image, with a **Rust** installation and all the dependencies needed to build the system and programs.

The build process is performed in your normal working directory, e.g. `~/tryredox/redox`. Compilation of the Redox components is performed in the container, but the final Redox image (`build/$ARCH/$CONFIG/harddrive.img` or `build/$ARCH/$CONFIG/livedisk.iso`) is constructed using [FUSE](https://github.com/libfuse/libfuse) running directly on your host machine.

Setting `PODMAN_BUILD` to 1 in [.config](./configuration-settings.md#config), on the `make` command line (e.g. `make PODMAN_BUILD=1 all`) or in the environment (e.g. `export PODMAN_BUILD=1; make all`) will enable Podman.

First, a **base image** called `redox_base` will be constructed, with all the necessary packages for the build system. A "home" directory will also be created in `build/podman`. This is the home directory of your container alter ego, `poduser`. It will contain the `rustup` install, and the `.bashrc`. This takes some time, but is only done when necessary. The *tag* file [build/container.tag](./advanced-podman-build.md#buildcontainertag) is also created at this time to prevent unnecessary image builds.

Then, various `make` commands are executed in **containers** built from the **base image**. The files are constructed in your working directory tree, just as they would for a non-Podman build. In fact, if all necessary packages are installed on your host system, you can switch Podman on and off relatively seamlessly, although there is no benefit of doing so.

The build process is using **Podman**'s `keep-id` feature, which allows your regular User ID to be mapped to `poduser` in the container. The first time a container is built, it takes some time to set up this mapping. After the first container is built, new containers can be built almost instantly.

## TL;DR - [New](#new-working-directory) or [Existing](#existing-working-directory) Working Directory

### New Working Directory 

If you have already read the [Building Redox](./building-redox.md) instructions, but you wish to use **Podman Build**, follow these steps.

- Make sure you have the `curl` command. e.g. for Pop!_OS/Ubuntu/Debian:

```sh
which curl || sudo apt-get install curl 
```

- Make a directory, get a copy of `podman_bootstrap.sh` and run it. This will clone the repository and install **Podman**.

```sh
mkdir -p ~/tryredox
```

```sh
cd ~/tryredox
```

```sh
curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/podman_bootstrap.sh -o podman_bootstrap.sh
```

```sh
time bash -e podman_bootstrap.sh
```

- You may be asked which QEMU installation you want. Please select `full`.
- You may be asked which Podman container runtime you want to use, `crun` or `runc`. Choose `crun`, but `runc` will also work.
- Update your path to include `cargo` and the Rust compiler.

```sh
source ~/.cargo/env
```

- Change to the `redox` directory.

```sh
cd ~/tryredox/redox
```

- Build the system. This will take some time.

```sh
time make all
```

### Existing Working Directory

If you already have the build system, you can do the following steps:

- Change to your working directory

```sh
cd ~/tryredox/redox
```

- Update the build system and wipe all binaries

```sh
make pull clean
```

- Install Podman. If your Linux distribution is not supported please check the [installation instructions](./advanced-podman-build.md#installation) to know what dependencies are needed. Or, run the following in your `redox` base` directory:

```sh
./podman_bootstrap.sh -d
```

- Enable Podman. The first container setup can take 15 minutes or more, but it is comparable in speed to native build after that.

```sh
nano .config
```

```
PODMAN_BUILD?=1
```

- Build Redox

```sh
make all
```

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

The emulator will display the Redox GUI (Orbital). See [Using the emulation](./running-vm.md#using-the-emulation) for general instructions and [Trying out Redox](./trying-out-redox.md) for things to try.

#### Run without a GUI

To run the virtual machine without a GUI, use:

```sh
make qemu gpu=no
```

If you want to capture the terminal output, read [this](./troubleshooting.md#debug-methods) section.

If you have problems running the virtual machine, you can try `make qemu kvm=no` or `make qemu iommu=no` to turn off various virtualization features. These can also be used as arguments to `build.sh`.

#### QEMU Tap For Network Testing

Expose Redox to other computers within a LAN. Configure QEMU with a "TAP" which will allow other computers to test Redox client/server/networking capabilities.

Join the [chat](./chat.md) if this is something you are interested in pursuing.

### Building A Redox Bootable Image

Read [this](./coding-and-building.md#testing-on-real-hardware) section.

## Note

If you intend on contributing to Redox or its subprojects, please read the [CONTRIBUTING.md](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/CONTRIBUTING.md) document, so you understand how our build system works and setup your repository fork appropriately. You can use `./bootstrap.sh -d` in the `redox` folder to install the prerequisite packages if you have already done a `git clone` of the sources.

If you encounter any bugs, errors, obstructions, or other annoying things, please join the [chat](./chat.md) or [report the issue](./creating-proper-bug-reports.md) to the [Redox repository](https://gitlab.redox-os.org/redox-os/redox) or a proper repository for the component. Thanks!

### build.sh

`build.sh` is a shell script that allows you to easily specify the CPU architecture you are building for, and the filesystem contents. When you are doing Redox development, you should set them in `.config` (see [Configuration Settings](./configuration-settings.md)). But if you are just trying things out, use `build.sh` to run `make` for you. e.g.:

- `./build.sh -a i686 -c server live` - Run `make` for an i686 (32-bits Intel/AMD) CPU architecture, using the `server` configuration, `config/i686/server.toml`. The resulting image is `build/i686/server/livedisk.iso`, which can be used for installation from a USB.

- `./build.sh -f config/aarch64/desktop.toml qemu` - Run `make` for an ARM64 (AArch64) CPU architecture, using the `desktop` configuration, `config/aarch64/desktop.toml`. The resulting image is `build/aarch64/desktop/harddrive.img`, which is then run in the emulator **QEMU**.

If you use `build.sh`, it's recommended that you do so consistently, as `make` will not be aware of which version of the system you previously built with `build.sh`. Details of `build.sh` and other settings are described in [Configuration Settings](./configuration-settings.md).
