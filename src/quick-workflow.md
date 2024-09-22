# Quick Workflow

This page will describe the most quick testing/development workflow for people that want an unified list to do things.

**You need to fully understand the build system to use this workflow, as it don't give detailed explanation of each command to save time and space**

- [Install Rust Nightly](#install-rust-nightly)
- [Update Rust](#update-rust)
- [Download a new build system copy](#download-a-new-build-system-copy)
- [Install the required packages for the build system](#install-the-required-packages-for-the-build-system)
- [Download and run the "podman_bootstrap.sh" script](#download-and-run-the-podman_bootstrapsh-script)
- [Download and build the toolchain and recipes](#download-and-build-the-toolchain-and-recipes)
- [Update the build system and its submodules](#update-the-build-system-and-its-submodules)
- [Update the toolchain and relibc](#update-the-toolchain-and-relibc)
- [Update recipes and the QEMU image](#update-recipes-and-the-qemu-image)
- [Update everything](#update-everything)
- [Wipe the toolchain and build again](#wipe-the-toolchain-and-build-again)
- [Wipe all sources/binaries of the build system and download/build them again](#wipe-all-sourcesbinaries-of-the-build-system-and-downloadbuild-them-again)
- [Use the "myfiles" recipe to insert your files on the QEMU image](#use-the-myfiles-recipe-to-insert-your-files-on-the-qemu-image)
- [Comment out a recipe from the build configuration](#comment-out-a-recipe-from-the-build-configuration)
- [Create logs](#create-logs)
- [Enable a source-based toolchain](#enable-a-source-based-toolchain)
- [Build the toolchain from source](#build-the-toolchain-from-source)
- [Download and build some Cookbook configuration for some CPU architecture](#download-and-build-some-cookbook-configuration-for-some-cpu-architecture)
- [Boot Redox on QEMU from a NVMe device](#boot-redox-on-qemu-from-a-nvme-device)
- [Boot Redox on QEMU from a NVMe device with more CPU cores](#boot-redox-on-qemu-from-a-nvme-device-with-more-cpu-cores)
- [Boot Redox on QEMU from a NVMe device, more CPU cores and memory](#boot-redox-on-qemu-from-a-nvme-device-more-cpu-cores-and-memory)

#### Install Rust Nightly

```sh
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly
```

Use Case: Configure the host system without the `podman_bootstrap.sh` script.

#### Update Rust

```sh
rustup update
```

Use Case: Try to fix Rust problems.

#### Download a new build system copy

```sh
git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive
```

Use Case: Commonly used when breaking changes on upstream require a new build system copy.

### Install the required packages for the build system

```sh
curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/podman_bootstrap.sh -o podman_bootstrap.sh
```

```sh
bash -e podman_bootstrap.sh -d
```

Use Case: Install new build tools for recipes or configure the host system without the `bootstrap.sh` script.

#### Download and run the "podman_bootstrap.sh" script

```sh
curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/podman_bootstrap.sh -o podman_bootstrap.sh
```

```sh
bash -e podman_bootstrap.sh
```

Use Case: Commonly used when breaking changes on upstream require a new build system copy.

#### Download and build the toolchain and recipes

```sh
cd redox
```

```sh
make all
```

Use Case: Create a new build system copy after a breaking change on upstream.

#### Update the build system and its submodules

```sh
make pull
```

Use Case: Keep the build system up-to-date.

#### Update the toolchain and relibc

```sh
touch relibc
```

```sh
make prefix
```

Use Case: Keep the toolchain up-to-date.

#### Update recipes and the QEMU image

```sh
make rebuild
```

Use Case: Keep the build system up-to-date.

#### Update everything

Install the `topgrade` tool to update your system packages (you can install it with `cargo install topgrade`)

```sh
topgrade
```

```sh
rustup update
```

```sh
make pull
```

```sh
touch relibc
```

```sh
make prefix rebuild
```

Use Case: Try to fix any problem caused by outdated programs, toolchain and build system sources.

#### Wipe the toolchain and build again

```sh
rm -rf prefix
```

```sh
make prefix
```

Use Case: Commonly used to fix problems.

#### Wipe the toolchain/recipe binaries and build them again

```sh
make clean all
```

Use Case: Commonly used to fix unknown problems or update the build system after breaking changes on upstream.

#### Wipe all sources/binaries of the build system and download/build them again

```sh
make distclean all
```

Use Case: Commonly used to fix unknown problems or update the build system after breaking changes.

#### Use the "myfiles" recipe to insert your files on the QEMU image

```sh
mkdir cookbook/recipes/other/myfiles/source
```

```sh
nano config/your-cpu-arch/your-config.toml
```

```toml
[packages]
myfiles = {}
```

```sh
make myfiles image
```

Use Case: Quickly insert files on the QEMU image or keep files between rebuilds.

#### Comment out a recipe from the build configuration

```sh
nano config/your-cpu-arch/your-config.toml
```

```
#recipe-name = {}
```

Use Case: Mostly used if some default recipe is broken.

#### Create logs

```sh
make some-command 2>&1 | tee file-name.log
```

Use Case: Report errors.

#### Enable a source-based toolchain

```sh
echo "PREFIX_BINARY?=0" >> .config
```

```sh
make prefix
```

Use Case: Build the latest toolchain sources or fix toolchain errors.

#### Build the toolchain from source

```sh
make prefix PREFIX_BINARY=0
```

Use Case: Test the toolchain sources.

#### Download and build some Cookbook configuration for some CPU architecture

```sh
make all CONFIG_NAME=your-config ARCH=your-cpu-arch
```

Use Case: Quickly build Redox variants without manual intervention on configuration files.

#### Boot Redox on QEMU from a NVMe device

```sh
make qemu disk=nvme
```

#### Boot Redox on QEMU from a NVMe device with more CPU cores

```sh
make qemu disk=nvme QEMU_SMP=number
```

#### Boot Redox on QEMU from a NVMe device, more CPU cores and memory

```sh
make qemu disk=nvme QEMU_SMP=number QEMU_MEM=number-in-mb
```
