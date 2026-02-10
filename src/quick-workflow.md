# Quick Workflow

This page contains the most quick testing/development workflow for people that want an direct list to do things.

**You need to fully understand the build system to use this workflow, as it don't give a detailed explanation of each command to save time and space**

- [Install Rust Nightly](#install-rust-nightly)
- [Update Rust](#update-rust)
- [Download a new build system copy without the bootstrap script](#download-a-new-build-system-copy-without-the-bootstrap-script)
- [Install the required dependencies for the build system](#install-the-required-dependencies-for-the-build-system)
- [Download and run the "podman_bootstrap.sh" script](#download-and-run-the-podman_bootstrapsh-script)
- [Build the system](#build-the-system)
- [Update the build system and its submodules](#update-the-build-system-and-its-submodules)
- [Update the toolchain and relibc](#update-the-toolchain-and-relibc)
- [Update recipes and Redox image](#update-recipes-and-redox-image)
- [Update everything](#update-everything)
- [Wipe the toolchain and download again](#wipe-the-toolchain-and-download-again)
- [Wipe the toolchain/recipe binaries and download/build them again](#wipe-the-toolchainrecipe-binaries-and-downloadbuild-them-again)
- [Wipe toolchain/recipe binaries and Podman container, update build system source and rebuild the system](#wipe-toolchainrecipe-binaries-and-podman-container-update-build-system-source-and-rebuild-the-system)
- [Wipe all recipe sources/binaries and download/build them again](#wipe-all-recipe-sourcesbinaries-and-downloadbuild-them-again)
- [Use the "myfiles" recipe to insert your files on Redox image](#use-the-myfiles-recipe-to-insert-your-files-on-redox-image)
- [Disable a recipe on the filesystem configuration](#disable-a-recipe-on-the-filesystem-configuration)
- [Create logs](#create-logs)
- [Temporarily build the toolchain from source](#temporarily-build-the-toolchain-from-source)
- [Build some filesystem configuration for some CPU architecture](#build-some-filesystem-configuration-for-some-cpu-architecture)
- [Build some filesystem configuration for some CPU architecture (using pre-built packages from the build server)](#build-some-filesystem-configuration-for-some-cpu-architecture-using-pre-built-packages-from-the-build-server)
- [Boot Redox on QEMU from a NVMe device](#boot-redox-on-qemu-from-a-nvme-device)
- [Boot Redox on QEMU from a NVMe device with a custom number of CPU threads](#boot-redox-on-qemu-from-a-nvme-device-with-a-custom-number-of-cpu-threads)
- [Boot Redox on QEMU from a NVMe device, a custom number of CPU threads and memory](#boot-redox-on-qemu-from-a-nvme-device-a-custom-number-of-cpu-threads-and-memory)

#### Install Rust Nightly

```sh
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly
```

Use Case: Configure the host system without the build system bootstrap scripts.

#### Update Rust

```sh
rustup update
```

Use Case: Try to fix Rust problems.

#### Download a new build system copy without the bootstrap script

```sh
git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream
```

Use Case: Commonly used when a big build system breakage was not prevented before an update or wipe leftovers.

### Install the required dependencies for the build system

```sh
curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/podman_bootstrap.sh -o podman_bootstrap.sh
```

```sh
bash -e podman_bootstrap.sh -d
```

Use Case: Install new build tools or update the existing ones.

#### Download and run the "podman_bootstrap.sh" script

```sh
curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/podman_bootstrap.sh -o podman_bootstrap.sh
```

```sh
bash -e podman_bootstrap.sh
```

Use Case: Commonly used when a big build system breakage was not prevented before an update and install new build tools or update the existing ones.

#### Build the system

```sh
cd redox
```

```sh
make all
```

Use Case: Build the system from a clean build system copy.

#### Update the build system and its submodules

```sh
make pull
```

Use Case: Keep the build system up-to-date.

#### Update the toolchain and relibc

```sh
make prefix r.relibc
```

Use Case: Keep the toolchain up-to-date.

#### Update recipes and Redox image

```sh
make rebuild
```

Use Case: Keep the Redox image up-to-date.

#### Update everything

Install the `topgrade` tool to update your system packages (you can install it with `cargo install topgrade`)

```sh
topgrade
```

```sh
make pull
```

```sh
make prefix rebuild
```

Use Case: Try to fix most problems caused by outdated recipes, toolchain and build system configuration.

#### Wipe the toolchain and download again

```sh
rm -rf prefix
```

```sh
make prefix
```

Use Case: Commonly used to fix problems.

#### Wipe the toolchain/recipe binaries and download/build them again

```sh
make clean all
```

Use Case: Commonly used to fix breaking changes on recipes.

#### Wipe toolchain/recipe binaries and Podman container, update build system source and rebuild the system

```sh
make clean container_clean pull all
```

Use Case: Full build system binary cleanup and update to avoid most configuration breaking changes

#### Wipe all recipe sources/binaries and download/build them again

```sh
make distclean all
```

Use Case: Fix source/binary breaking changes on recipes or save space.

#### Use the "myfiles" recipe to insert your files on Redox image

```sh
mkdir recipes/other/myfiles/source
```

```sh
nano config/$ARCH/your-config.toml
```

```toml
[packages]
myfiles = {}
```

```sh
make rp.myfiles
```

Use Case: Quickly insert files on the Redox image or keep files between rebuilds.

#### Disable a recipe on the filesystem configuration

```sh
nano config/$ARCH/your-config.toml
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

#### Temporarily build the toolchain from source

```sh
make prefix PREFIX_BINARY=0
```

Use Case: Test toolchain fixes.

#### Build some filesystem configuration for some CPU architecture

```sh
make all CONFIG_NAME=your-config ARCH=$ARCH
```

Use Case: Quickly build Redox variants without manual intervention on configuration files.

#### Build some filesystem configuration for some CPU architecture (using pre-built packages from the build server)

(Much faster than the option above)

```sh
make all REPO_BINARY=1 CONFIG_NAME=your-config ARCH=$ARCH
```

Use Case: Quickly build Redox variants without system compilation and manual intervention on configuration files.

#### Boot Redox on QEMU from a NVMe device

```sh
make qemu disk=nvme
```

#### Boot Redox on QEMU from a NVMe device with a custom number of CPU threads

```sh
make qemu disk=nvme QEMU_SMP=number
```

#### Boot Redox on QEMU from a NVMe device, a custom number of CPU threads and memory

```sh
make qemu disk=nvme QEMU_SMP=number QEMU_MEM=number-in-mb
```
