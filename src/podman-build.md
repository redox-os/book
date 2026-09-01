# Building Redox

Congrats on making it this far! Now you will build Redox. This process is mainly for creating images targeting **x86-64** machines (Intel/AMD). The process is similar when targeting i586, [ARM64](./aarch64.md) and RISC-V.

Redox build system is using **Rootless Podman**. **Podman** is used to avoid bugs from different build environments (operating systems). You can find out more about Podman on the [Official Podman documentation](https://docs.podman.io/en/latest/Introduction.html).

## Podman Build Overview

**Podman** is a **container manager** that creates **containers** to execute a Linux distribution **image**. In our case, we are creating an **Debian** image, with a **Rust** installation and all the dependencies needed to build the system and programs.

### New Working Directory

> 📝 **Note:** If you have cloned our official repository, go to [Existing Working Directory](#existing-working-directory).

 1. Open a terminal and ensure you have the `curl` program installed. You can use `apt`, `dnf` or `apk` depending on your operating system.

    ```sh
    which curl || sudo apt-get install curl
    ```

 2. Create a new directory and run `podman_bootstrap.sh` inside of it. This will clone the repository, install **Podman** and extra software such as **Rust**, **Git** and **QEMU**. It's a good practice to check the content of [the script](https://gitlab.redox-os.org/redox-os/redox/raw/master/podman_bootstrap.sh) before lauching it.

    ```sh
    mkdir -p ~/tryredox && cd $_
    ```

    ```sh
    curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/podman_bootstrap.sh -o podman_bootstrap.sh
    ```

    ```sh
    time bash -e podman_bootstrap.sh
    ```

    The installation may take about 15 minutes on good network condition. You may be asked for some question and sudo prompt along the installation.

 3. Update your path to include `cargo` and the Rust compiler.

    ```sh
    source ~/.cargo/env
    ```

 4. Navigate to the `redox` directory.

    ```sh
    cd ~/tryredox/redox
    ```

 5. Create a configuration file and take a moment to read our [Build Configuration Settings](./configuration-settings.md). The build configuration is written to `.config`, and we recommend to start with `REPO_BINARY=1` to speed up image build by downloading prebuilt programs instead of compiling them.

    ```sh
    nano .config
    ```

    ```sh
    REPO_BINARY=1
    ```

 5. Build the system. For the first time, it may take about 20 minutes depending on network condition.

    ```sh
    time make all
    ```

### Existing Working Directory

If you already have the build system, simply perform the following steps:

 1. Change to your working directory

    ```sh
    cd ~/tryredox/redox
    ```

 2. Update the build system and wipe all compiled binaries

    ```sh
    make clean pull
    ```

 3. Install Podman. If your Linux distribution is not supported, check the [installation instructions](./advanced-podman-build.md#installation) to determine which dependencies are needed. Or, run the following in your `redox` base` directory:

    ```sh
    ./podman_bootstrap.sh -d
    ```

 4. Make sure the configuration for podman build stays enabled

    ```sh
    nano .config
    ```

    ```sh
    PODMAN_BUILD?=1
    ```

 5. Build the Redox image.

    ```sh
    make all
    ```

### Run in a virtual machine

You can immediately run the new image (`build/x86_64/desktop/harddrive.img`) in a virtual machine with the following command:

```sh
make qemu
```

The emulator will display the Redox GUI (Orbital). See [Using the emulation](./running-vm.md#using-the-emulation) for general instructions and [Trying out Redox](./trying-out-redox.md) for things to try.

#### Run without a GUI

To run the virtual machine without a GUI, use:

```sh
make qemu gpu=no
```

If you want to capture the terminal output, read the [Debug Methods](./troubleshooting.md#debug-methods) section.

> 💡 **Tip:** if you encounter problems running the virtual machine, try turning off various virtualization features with `make qemu kvm=no` or `make qemu iommu=no`. These same arguments can also be used with `build.sh`.

#### QEMU Tap For Network Testing

Expose Redox to other computers in the same local network. Configure QEMU with a "TAP" which will allow other computers to test Redox client/server/networking capabilities.

Please join the [chat](./chat.md) if this is something you are interested in pursuing.

## Using build.sh script

`build.sh` is a shell script for quickly invoking `make` for a specified variant, CPU architecture, and output file. It is created for quick one-off command to build everything without changing settings from `.config` file.

> 💡 **Tip:** for doing Redox development, such settings should usually be configured in the `.config` file (see the [Configuration Settings](./configuration-settings.md) page). But for users who are just trying things out, the `build.sh` script can be used to run `make` for you.

You can also provide  `qemu` option to run the virtual machine:

   ```sh
   ./build.sh -a i586 -c demo qemu
   ```

This will build `build/i586/demo/harddrive.img` (if it doesn't already exist) and run it in the QEMU emulator.


#### Example 1

The following builds the `server` variant of Redox for the `i586` (32-bit Intel/AMD) CPU architecture (defined in `config/i586/server.toml`):

```
./build.sh -a i586 -c server live
```

The resulting image is `build/i586/server/livedisk.iso`, which can be used to install Redox from a USB device.

#### Example 2

The following builds the `desktop` variant of Redox for the `aarch64` (64-bit ARM) CPU architecture (defined in `config/aarch64/desktop.toml`).

```
./build.sh -f config/aarch64/desktop.toml qemu
```

The resulting image is `build/aarch64/desktop/harddrive.img`, which is then run in the QEMU emulator upon completion of the build.

#### More options


Details of `build.sh` and other settings are described in the [Configuration Settings](./configuration-settings.md) page.

> 💡 **Tip:** The script's underlying `make` command doesn't keep any record of the build settings used between `build.sh` runs. If you are going to use `build.sh` repeatedly, it's recommended that you do so *consistently*.

## Next Step

- The [Build System Reference](./build-system-reference.md) page to know our build system organization, the Makefile commands and how it works.
- The [Testing on Real Hardware](./coding-and-building.md#testing-on-real-hardware) section contains guide for creating a bootable image into real hardware.
- The [Advanced Podman Build](./advanced-podman-build.md) contains more information about how the podman build works and how manual installation can be performed.
- The build process fetches files from the [Redox Gitlab server](https://gitlab.redox-os.org). If this happens, first check for typos in the `git` URL. If that doesn't solve the problem, try again later, and if it continues to happen, you can let us know through the [chat](./chat.md).

## Contributor Note

If you intend to contribute to Redox or its subprojects, please read the [CONTRIBUTING](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/CONTRIBUTING.md) document to understand how the Redox build system works, and how to set up your repository fork appropriately.

If you encounter any bugs, errors, obstructions, or other annoying things, please join the [chat](./chat.md) or [report the issue](./creating-proper-bug-reports.md) to the [build system repository](https://gitlab.redox-os.org/redox-os/redox) or a proper repository for the component. Thanks!
