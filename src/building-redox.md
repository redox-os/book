# Native Build

This page explains how to build Redox in your operating system's native environment, without Podman. Building in native environment may useful in some environment, such as platforms where Podman support is poor or isolated such as inside CI or Nix.

> ⚠️ **Warning:** Building outside Podman requires experience with toolchain and is not guaranteed to succeed. Unless you have problems using Podman, we recommend you to use the [Podman Build](./podman-build.md) before trying the Native Build to avoid build environment bugs.

## Support Matrix for Native Build

The following section explain how well supported an operating system support will be to use Native Build.

| Operating System | Status | [Prebuilt Toolchain](./advanced-build.md#prefix) |
|---|---|---|
| Debian | Supported | Version >= 13 |
| Ubuntu | Supported | Version >= 24 |
| Fedora | Supported | Version >= 42 |
| RHEL | Supported | No support |
| Arch Linux | Supported | Supported |
| OpenSUSE | Supported | Rolling only |
| Gentoo | No Support[^3] | Supported |
| Void Linux | No Support[^3] | Supported |
| Solus | No Support[^3] | Supported |
| FreeBSD | Experimental | No support |
| MacOS | No Support[^1] | No support |
| Windows | No Support[^2] | No support |
| Nix | Experimental | No support |
| Redox OS | Experimental[^4] | Supported |

[^1]: MacOS native build cannot work. See [workarounds](./advanced-build.md#macos-users)
[^2]: Windows require WSL 2, which then depends on the WSL operating system
[^3]: It may work, but the `native_bootstrap` script does not support it. We welcome contribution!
[^4]: See [Self hosted development](./self-hosted.md)

If you encounter a weird or difficult-to-fix problem, test the [Podman Build](./podman-build.md) to determine if the problem occurs there as well.

## Preparing the Build

### Bootstrap Prerequisites and Fetch Sources

On supported Linux distributions, build system preparation can be performed automatically via the build system's bootstrap script:

 1. Ensure you have the `curl` program installed. e.g., for Pop!_OS/Ubuntu/Debian:

    ```sh
    which curl || sudo apt-get install curl
    ```

 2. Create a new directory and run the `native_bootstrap.sh` script in it.

    ```sh
    mkdir -p ~/tryredox && cd $_
    ```

    ```sh
    curl -sSf https://gitlab.redox-os.org/redox-os/redox/raw/master/native_bootstrap.sh -o native_bootstrap.sh
    ```

    ```sh
    time bash -e native_bootstrap.sh
    ```

    You will be asked to confirm some steps: answer with `y` or `1`.

    For an explanation of what the `native_bootstrap.sh` script does, read [this](./build-phases.md#native_bootstrapsh) section.

    Please be patient. The bootstrapping process can take anywhere from 5 minutes to an hour depending on the hardware and network it's being run on.

    If the `native_bootstrap.sh` script does not work for you, please try reading the [Advanced Build](./advanced-build.md) page to install the right packages for your operating system.

 3. After bootstrapping is completed, update the `PATH` environment variable for the current shell:

    ```sh
    source ~/.cargo/env
    ```

### Setting Configuration Values

The build system uses several configuration files, which contain settings that you may wish to change. These are detailed in the [Configuration Settings](./configuration-settings.md) page. For the Native Build we recommend setting these in the `.config` file:

- `ARCH=x86_64`
- `CONFIG_NAME=desktop`
- `PODMAN_BUILD=0` to disable Podman Build
- `PREFIX_BINARY=0` to disable prebuilt toolchain [if not supported](#support-matrix-for-native-build)
- `PREFIX_USE_UPSTREAM_RUST_COMPILER=1` to [avoid compiling Rust compiler](./advanced-build.md#prefix-rust)

The [build.sh](./configuration-settings.md#buildsh) script also allows the user to specify the CPU architecture and filesystem contents to be used in the build, although these settings needs to be written again every time the script is executed.

Building with `PREFIX_BINARY=0` can add hours into the build time because it has to compile GCC, Rust and Clang. [See Advanced Build: Prefix Toolchain](./advanced-build.md#prefix) for more information about the process.

## Compiling Redox

At this point we have:

- Downloaded the sources
- Tweaked the settings to our liking
- Probably added our recipe to the filesystem

We are ready to build the Redox operating system image. Skip ahead to [Configuration Settings](./configuration-settings.md) if you want to build for a different CPU architecture or with different filesystem contents.

### Build all system components and programs

To build all the components and packages to be included in the filesystem.

```sh
cd ~/tryredox/redox
```

```sh
time make all
```

This will build the target `build/x86_64/desktop/harddrive.img`, which can be run in a virtual machine.

Give it a while. Redox is big. Read the [`make all` (first run)](./build-phases.md#make-all-first-run) section for an explanation of what the `make all` command does.

> 💡 **Tip:** the filesystem parts are merged into the final system image using the [FUSE](https://github.com/libfuse/libfuse) library. The `bootstrap.sh` script installs `libfuse` automatically. If you encounter problems with the final Redox image, verify `libfuse` is installed and that you are able to use it.
