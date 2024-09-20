# Native Build

This page explains how to build Redox in the native environment of your operating system. Keep in mind that you can have problems that doesn't happen on the Podman build, thus only use this method if you can't use Podman.

(Don't forget to read [this](./build-system-reference.md) page to know our build system organization and how it works)

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
- Nix (under develoopment)
- Solus (basic support, not maintained)

If you have a weird or hard problem to fix, test the [Podman Build](./podman-build.md) and verify if the problem happens there.

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

To know what the `bootstrap.sh` script does, read [this](./build-phases.md#bootstrapsh) section.

Note that `curl -sf` operates silently, so if there are errors, you may get an empty or incorrect version of `bootstrap.sh`. Check for typos in the command and try again. If you continue to have problems, join the [chat](./chat.md) and let us know.

Please be patient, this can take 5 minutes to an hour depending on the hardware and network you're running it on. Once it's done, update your `PATH` environment variable in the current shell with:

```sh
source ~/.cargo/env
```

### Setting Configuration Values

The build system uses several configuration files, which contain settings that you may wish to change. These are detailed in the [Configuration Settings](./configuration-settings.md) page. By default, the build system cross-compile to the `x86_64` CPU architecture, using the `desktop` configuration (at `config/x86_64/desktop.toml`). Set the desired `ARCH` and `CONFIG_FILE` in [.config](./configuration-settings.md#config). There is also a shell script [build.sh](#buildsh) that will allow you to choose the architecture and filesystem contents easily, although it is only a temporary change.

## Compiling Redox

Now we have:

 - Downloaded the sources
 - Tweaked the settings to our liking
 - Probably added our recipe to the filesystem

We are ready to build the Redox operating system image. Skip ahead to [Configuration Settings](./configuration-settings.md) if you want to build for a different CPU architecture or with different filesystem contents.

### Build all system components and programs

To build all the components, and the packages to be included in the filesystem.

```sh
cd ~/tryredox/redox
```

```sh
time make all
```

This will make the target `build/x86_64/desktop/harddrive.img`, which you can run with a virtual machine.

Give it a while. Redox is big. Read [this](./build-phases.md#make-all-first-run) section to know what the `make all` command does.

Note that the filesystem parts are merged using the [FUSE](https://github.com/libfuse/libfuse). `bootstrap.sh` install `libfuse`. If you have problems with the final image of Redox, verify if `libfuse` is installed and you are able to use it.
