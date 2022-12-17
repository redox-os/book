# Building Redox

Congrats on making it this far! Now we gotta build Redox. This process is for **x86_64** machines. There are also similar processes for [i686](./ch02-09-i686.html) and [AArch64/Arm64](./ch02-10-aarch.html).

The build process fetches files from the Redox Gitlab server. From time to time, errors may occur which may result in you being asked to provide a username and password during the build process. If this happens, first check for typos in the `git` URL. If that doesn't solve the problem and you don't have a Redox gitlab login, try again later, and if it continues to happen, you can let us know through [chat](./ch06-03-chat.html), or send an email to [info@redox-os.org](mailto:info@redox-os.org)

## Supported Distros and Podman Build

This build process for the current release (0.8.0) is for Pop!_OS/Ubuntu/Debian. The recommended build environment for other distros is our [Podman Build](./ch02-08-podman-build.html). Please follow those instructions instead. There is partial support for non-Debian distros in `bootstrap.sh`, but it is not maintained.

## Preparing the Build

### Bootstrap Prerequisites And Fetch Sources

If you're on a supported Linux distro, you can just run the bootstrap script, which does the build preparation for you. First, ensure that you have the program `curl` installed:

```sh
which curl || sudo apt-get install curl # Pop!_OS/Ubuntu/Debian - adjust for your system
```

Then run the following commands:
```
mkdir -p ~/tryredox
cd ~/tryredox
curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/bootstrap.sh -o bootstrap.sh
time bash -e bootstrap.sh
```

You will be asked to confirm various installations. Answer in the affirmative (*y* or *1* as appropriate).
The above does the following:
 - installs the program `curl` if it is not already installed
 - creates a parent folder called `tryredox`. Within that folder, it will create another folder called `redox` where all the sources will reside.
 - installs the pre-requisite packages using your operating system's package manager(Pop!_OS/Ubuntu/Debian `apt`, Redhat/Centos/Fedora `dnf`, Arch Linux `pacman`).
 - clones the Redox code from GitLab and checks out a redox-team tagged version of the different subprojects intended for the community to test and submit success/bug reports for.

Note that `curl -sf` operates silently, so if there are errors, you may get an empty or incorrect version of bootstrap.sh. Check for typos in the command and try again. If you continue to have problems, join the [chat](./ch06-03-chat.html) and let us know.

Please be patient, this can take 5 minutes to an hour depending on the hardware and network you're running it on. Once it completes, update your path in the current shell with
```sh2048
source ~/.cargo/env
```

### Setting Config Values

The build system uses several configuration files, which contain settings that you may wish to change. These are detailed in [Configuration Files](./ch02-06-configuration-settings.html). By default, the system builds for an `x86_64` architecture, using the `desktop` configuration (`config/x86_64/desktop.toml`). There is a shell script [build.sh](#buildsh) that will allow you to choose the architecture and filesystem contents easily.

## Compiling The Entire Redox Project

Now we have:
 - fetched the sources
 - tweaked the settings to our liking
 - possibly added our very own source/binary package to the filesystem

We are ready to build the entire Redox Operating System Image. Skip ahead to [build.sh](#buildsh) if you want to build for a different architecture or with different filesystem contents.

### Build all the components and packages

To build all the components, and the packages to be included in the filesystem.

```sh
cd ~/tryredox/redox
time make all
```
This will make the target `build/x86_64/desktop/hardrive.img`, which you can run with an emulator.

Give it a while. Redox is big. This will do the following:
- fetch some sources for the core tools from the Redox source servers, then build them. As it progressively cooks each package, it fetches the package's sources and builds it.
- create a few empty files holding different parts of the final image filesystem.
- using the newly built core tools, build the non-core packages into one of those filesystem parts.
- fill the remaining filesystem parts appropriately with stuff built by the core tools to help boot Redox.
- merge the different filesystem parts into a final Redox Operating System image ready-to-run in an emulator.

Note that the filesystem parts are merged using the [FUSE](https://github.com/libfuse/libfuse). Bootstrap.sh installs `libfuse`. If you have problems with the final assembly of Redox, check that `libfuse` is installed and you are able to use it.

### build.sh

`build.sh` is a shell script that allows you to easily specify the architecture you are building for, and the filesystem contents. When you are doing Redox development, you should set them in `mk/config.mk` (see [Configuration Settings](./ch02-06-configuration-settings.md)). But if you are just trying things out, use `build.sh` to run `make` for you. e.g.:

- `./build.sh -a i686 -c server live` - Run `make` for an `i686` architecture, using the `server` configuration, `config/i686/server.toml`. The resulting image is `build/i686/server/livedisk.iso`, which can be used for installation from a USB.

- `./build.sh -f config/aarch64/desktop.toml all` - Run `make` for an `arm64/AArch64` architecture, using the `desktop` configuration, `config/aarch64/desktop.toml`. The resulting image is `build/aarch64/desktop/harddrive.img`, which can be run in an emulator such as **QEMU**.

Details of `build.sh` and other settings are described in [Configuration Settings](./ch02-06-configuration-settings.html).

### Run in an emulator

You can immediately run your image `build/x86_64/desktop/harddrive.img` in an emulator with the following command.
```sh
make qemu
```

Note that if you built the system using `build.sh` to change architecture or filesystem contents, you should also use it to run the emulator.
```sh
./build.sh -a i686 -c server qemu
```
will build `build/i686/server/harddrive.img` (if it does not exist) and run it in the **QEMU** emulator.

The emulator will display the Redox GUI. See [Using the emulation](./ch02-02-running-vm.html#using-the-emulation) for general instructions and [Trying out Redox](./ch02-11-trying-out-redox.html) for things to try.

#### Run with no GUI

To run the emulation with no GUI, use
```
script ~/my_log.txt
make qemu vga=no
exit
```
Running with no GUI is the recommended method of capturing console and debug output from the system or from your text-only program. The `script` command creates a new shell, capturing all input and output from the text console to the log file with the given name. Remember to type `exit` after the emulation terminates, in order to properly flush the output to the log file and terminate `script`'s shell.

If you have problems running the emulation, you can try `make qemu kvm=no` or `make qemu iommu=no` to turn off various virtualization features. These can also be used as arguments to `build.sh`.

#### Running The Redox Console With A Qemu Tap For Network Testing

Expose Redox to other computers within a LAN. Configure Qemu with a "TAP" which will allow other computers to test Redox client/server/networking capabilities.

Join the [Redox chat](./ch06-03-chat.html) if this is something you are interested in pursuing.

### Building Redox Live CD/USB Image

For a *livedisk* or installable image, use:
```sh
cd ~/tryredox/redox
time make live
```
This will make the target `build/x86_64/desktop/livedisk.iso`, which can be copied to a USB drive or CD for booting or installation. See [Creating a bootable USB drive or CD](./ch02-03-real-hardware.html#creating-a-bootable-usb-drive-or-cd) for instructions on creating a USB drive and booting from it.


## Note

If you intend on contributing to Redox or its subprojects, please read [Creating a Proper Pull Request](./ch06-10-creating-proper-pull-requests.html) so you understand our use of forks and set up your repository appropriately. You can use `./bootstrap.sh -d` in the `redox` folder to install the prerequisite packages if you have already done a `git clone` of the sources.

If you encounter any bugs, errors, obstructions, or other annoying things, please join the [Redox chat](./ch06-03-chat.html) or report the issue to the [Redox repository]. Thanks!

[Redox repository]: https://gitlab.redox-os.org/redox-os/redox
