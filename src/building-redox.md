# Native Build

This page explains how to build Redox in your operating system's native environment. Keep in mind that it's possible to encounter issues with the native build that don't occur with the Podman build, so this method is only recommended where Podman cannot be used.

> 📝 **Note:** be sure to read the [Build System](./build-system-reference.md) page for an explanation of the build system's organization and functionality.

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
- MacOSX (require [workarounds](./advanced-build.md#macos-users))
- Nix (under development)
- Solus (basic support, not maintained)

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
    mkdir -p ~/tryredox
    ```

    ```sh
    cd ~/tryredox
    ```

    ```sh
    curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/native_bootstrap.sh -o native_bootstrap.sh
    ```

    ```sh
    time bash -e native_bootstrap.sh
    ```

    You will be asked to confirm some steps: answer with `y` or `1`.

    For an explanation of what the `native_bootstrap.sh` script does, read [this](./build-phases.md#native_bootstrapsh) section.

    Note that `curl -sf` operates silently, so if there are errors, you may get an empty or incorrect version of `native_bootstrap.sh`. Check for typos in the command and try again. If you continue to have problems, join the [chat](./chat.md) and let us know.

    Please be patient. The bootstrapping process can take anywhere from 5 minutes to an hour depending on the hardware and network it's being run on.

 3. After bootstrapping is completed, update the `PATH` environment variable for the current shell:

    ```sh
    source ~/.cargo/env
    ```

### Setting Configuration Values

The build system uses several configuration files, which contain settings that you may wish to change. These are detailed in the [Configuration Settings](./configuration-settings.md) page. By default the build system cross-compile to the `x86_64` CPU architecture, using the `desktop` configuration (at `config/x86_64/desktop.toml`). Set the desired `ARCH` and `CONFIG_FILE` in [.config](./configuration-settings.md#config).

The [build.sh](#buildsh) script also allows the user to specify the CPU architecture and filesystem contents to be used in the build, although these settings be re-specified every time the script is run.

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
