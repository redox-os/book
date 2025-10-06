# Build System

The build system downloads and creates several files that you may want to know about. There are also several `make` commands mentioned below, and a few extras that you may find useful. Here's a quick summary. All file paths are relative to your `redox` base directory.

- [Build System Organization](#build-system-organization)
  - [Root Folder](#root-folder)
  - [GNU Make Configuration](#gnu-make-configuration)
  - [Podman Configuration](#podman-configuration)
  - [Filesystem Configuration](#filesystem-configuration)
  - [Cookbook](#cookbook)
  - [Build System Files](#build-system-files)
- [GNU Make Commands](#gnu-make-commands)
  - [Build System](#build-system-1)
  - [Recipes](#recipes)
  - [QEMU/VirtualBox](#qemuvirtualbox)
- [Environment Variables](#environment-variables)
- [Scripts](#scripts)
- [Component Separation](#component-separation)
- [Pinned Commits](#pinned-commits)
  - [Current Pinned Submodules](#current-pinned-submodules)
  - [Manual Submodule Update](#manual-submodule-update)
- [Git Auto-checkout](#git-auto-checkout)
  - [Submodules](#submodules)
- [Update The Build System](#update-the-build-system)
- [Update Relibc](#update-relibc)
- [Fix Breaking Changes](#fix-breaking-changes)
  - [All Recipes](#all-recipes)
  - [One Recipe](#one-recipe)
- [Configuration](#configuration)
  - [Format](#format)
  - [Filesystem Customization](#filesystem-customization)
- [Cross-Compilation](#cross-compilation)
- [Build Phases](#build-phases)

## Build System Organization

### Root Folder

- `podman_bootstrap.sh` - The script used to configure the Podman build
- `native_bootstrap.sh` - The script used to configure the Native build
- `Makefile` - The main Makefile of the build system, it loads all the other Makefiles.
- `.config` - Where you override your build system settings. It is loaded by the Makefile (it is ignored by `git`).

### GNU Make Configuration

- `mk/config.mk` - The build system settings are here. You can override these settings in your `.config`, don't change them here to avoid conflicts in the `make pull` command.
- `mk/*.mk` - The rest of the Makefiles. You should not need to change them.

### Podman Configuration

- `podman/redox-base-containerfile` - The file used to create the image used by the Podman build. The installation of Ubuntu packages needed for the build is done here. See the [Adding Packages to the Build](./advanced-podman-build.md#adding-packages-to-the-build) section if you need to add additional Ubuntu packages.

### Filesystem Configuration

- `config` - This folder contains all filesystem configurations.
- `config/*.toml` - Filesystem templates used by the CPU target configurations (a template can use other template to reduce duplication)
- `config/your-cpu-arch/your-config.toml` - The filesystem configuration of the QEMU image to be built, e.g. `config/x86_64/desktop.toml`
- `config/your-cpu-arch/server.toml` - The variant with system components (without Orbital) and some important tools. Aimed for servers, low-end computers, testers and developers.

(Try this config if you have boot problems on QEMU or real hardware).

- `config/your-cpu-arch/desktop.toml` - The variant with system components, the Orbital desktop environment and some important programs (this is the default configuration of the build system). Aimed for end-users, gamers, testers and developers.
- `config/your-cpu-arch/dev.toml` - The variant with development tools included. Aimed for developers.
- `config/your-cpu-arch/demo.toml` - The variant with a complete system and optional programs and games. Aimed for end-users, gamers, testers and developers.
- `config/your-cpu-arch/desktop-minimal.toml` - The minimal `desktop` variant for low-end computers and embedded hardware. Aimed for servers, low-end computers, embedded hardware and developers.
- `config/your-cpu-arch/minimal.toml` - The variant without network support and Orbital. Aimed for low-end computers, embedded hardware, testers and developers.
- `config/your-cpu-arch/minimal-net.toml` - The variant without Orbital and tools. Aimed for low-end computers, embedded hardware, testers and developers.
- `config/your-cpu-arch/resist.toml` - The variant with the `resist` POSIX test suite. Aimed for developers.
- `config/your-cpu-arch/acid.toml` - The variant with the `acid` general-purpose test suite. Aimed for developers.
- `config/your-cpu-arch/ci.toml` - The continuous integration variant, recipes added here become packages on the [build server](https://static.redox-os.org/pkg/). Aimed for packagers and developers.
- `config/your-cpu-arch/jeremy.toml` - The build of [Jeremy Soller](https://soller.dev/) (creator/BDFL of Redox) with the recipes that he is testing at the moment.

### Cookbook

- `prefix/*` - Tools used by the Cookbook system. They are normally downloaded during the first system build.

(If you are having a problem with the build system, you can remove the `prefix` directory and it will be recreated during the next build)

- `cookbook/*` - Part of the Cookbook system, these scripts and tools will build your recipes.
- `cookbook/repo` - Contains all packaged recipes.
- `cookbook/recipes/recipe-name` - A recipe (software port) directory (represented as `recipe-name`), this directory holds the `recipe.toml` file.
- `cookbook/recipes/recipe-name/recipe.toml` - The recipe configuration file, this configuration contains instructions for downloading Git repositories or tarballs, then creating executables or other files to include in the Redox filesystem. Note that a recipe can contain dependencies that cause other recipes to be built, even if the dependencies are not otherwise part of your Redox build.

(To learn more about the recipe system read the [Porting Applications using Recipes](./porting-applications.md) page)

- `cookbook/recipes/recipe-name/recipe.sh` - The old recipe configuration format (can't be used as dependency of a recipe with a TOML syntax).
- `cookbook/recipes/recipe-name/source.tar` - The tarball of the recipe (renamed).
- `cookbook/recipes/recipe-name/source` - The directory where the recipe source is extracted or downloaded.
- `cookbook/recipes/recipe-name/target` - The directory where the recipe binaries are stored.
- `cookbook/recipes/recipe-name/target/${TARGET}` - The directory for the recipes binaries of the CPU architecture (`${TARGET}` is the environment variable of your CPU architecture).
- `cookbook/recipes/recipe-name/target/${TARGET}/build` - The directory where the recipe build system run its commands.
- `cookbook/recipes/recipe-name/target/${TARGET}/stage` - The directory where recipe binaries go before the packaging, after `make all`, `make rebuild` and `make image` the [installer](https://gitlab.redox-os.org/redox-os/installer) will extract the recipe package on the QEMU image, generally at `/usr/bin` or `/usr/lib` in a Redox filesystem hierarchy.
- `cookbook/recipes/recipe-name/target/${TARGET}/sysroot` - The folder where recipe build dependencies (libraries) goes, for example: `library-name/src/example.c`
- `cookbook/recipes/recipe-name/target/${TARGET}/stage.pkgar` - Redox package file.
- `cookbook/recipes/recipe-name/target/${TARGET}/stage.sig` - Signature for the `tar` package format.
- `cookbook/recipes/recipe-name/target/${TARGET}/stage.tar.gz` - Legacy `tar` package format, produced for compatibility reasons as we are working to make the package manager use the `pkgar` format.
- `cookbook/recipes/recipe-name/target/${TARGET}/stage.toml` - Contains the runtime dependencies of the package and is part of both package formats.

### Build System Files

- `build` - The directory where the build system will place the final image. Usually `build/$(ARCH)/$(CONFIG_NAME)`, e.g. `build/x86_64/desktop`
- `build/your-cpu-arch/your-config/harddrive.img` - The Redox image file, to be used by QEMU or VirtualBox for virtual machine execution on a Unix-like host.
- `build/your-cpu-arch/your-config/livedisk.iso` - The Redox bootable image file, to be used on real hardware for testing and possible installation.
- `build/your-cpu-arch/your-config/fetch.tag` - An empty file that, if present, tells the build system that the downloading of recipe sources is done.
- `build/your-cpu-arch/your-config/repo.tag` - An empty file that, if present, tells the build system that all recipes required for the Redox image have been successfully built. **The build system will not check for changes to your code when this file is present.** Use `make rebuild` to force the build system to check for changes.
- `build/podman` - The directory where Podman Build places the container user's home directory, including the container's Rust installation. Use `make container_clean` to remove it. In some situations, you may need to remove this directory manually, possibly with root privileges.
- `build/container.tag` - An empty file, created during the first Podman build, so a Podman build knows when a reusable Podman image is available. Use `make container_clean` to force a rebuild of the Podman image on your next `make rebuild` run.
  
## GNU Make Commands

You can combine `make` commands, but order is significant. For example, `make r.games image` will build the `games` recipe and create a new Redox image, but `make image r.games` will make the Redox image before the recipe building, thus the new recipe binary will not be included on your Redox filesystem.

### Build System

- `make pull` - Update the source code of the build system without building.
- `make all` - Builds the entire system, checking for changes and only building as required. Only use this for the first build. If the system was successfully built previously, this command may report `Nothing to be done for 'all'`, even if some recipes have changed. Use `make rebuild` instead.
- `make rebuild` - Update all binaries from recipes with source code changes (it don't detect changes on the Redox toolchain), it should be your normal `make` target.
- `make prefix` - Download the Rust/GCC forks and build relibc (it update the relibc binary with source code changes after the `make pull`, `touch relibc` and `make prefix` commands).
- `make fstools` - Build the image builder (installer), Cookbook and RedoxFS (after `touch installer` or `touch redoxfs`).
- `make fstools_clean` - Clean the image builder, Cookbook and RedoxFS binaries.
- `make fetch` - Update recipe sources, according to each recipe, without building them. Only the recipes that are included in your `(CONFIG_NAME).toml` are downloaded. Does nothing if `$(BUILD)/fetch.tag` is present. You won't need this.
- `make clean` - Clean all recipe binaries (Note that `make clean` may require some tools to be built).
- `make unfetch` - Clean all recipe sources.
- `make distclean` - Clean all recipe sources and binaries (**please backup or submit your source changes before the execution of this command**).
- `make repo` - Package the recipe binaries, according to each recipe. Does nothing if `$(BUILD)/repo.tag` is present. You won't need this.
- `make live` - Creates a bootable image, `build/livedisk.iso`. Recipes are not usually rebuilt.
- `make popsicle` - Flash the Redox bootable image on your USB device using the [Popsicle](https://github.com/pop-os/popsicle) tool (the program executable must be present on your shell `$PATH` environment variable, you can get the executable by extracting the AppImage, installing from the package manager or building from source)
- `make env` - Creates a shell with a build environment configured to use the Redox toolchain. If you are using Podman Build it will change your current terminal shell to the container shell, you can use it to update crates of Rust programs or debug build issues such as missing packages (if you are using the Podman Build you can only use this command in one terminal shell, because it will block the build system directory access from other Podman shell)
- `make container_shell` - Open the GNU Bash shell of the Podman container as the active shell of your terminal, it's logged as the `podman` user without `root` privileges (don't use this command to replace the `make env` command because it don't setup the Redox toolchain in the Podman container shell)
- `make container_su` - Open the GNU Bash shell of the Podman container as the active shell of your terminal, it's logged as the `root` user (don't use this command to replace the `make env` command because it don't setup the Redox toolchain in the Podman container shell)
- `make container_clean` - This will discard images and other files created by Podman.
- `make container_touch` - If you have removed the file `build/container.tag`, but the container image is still usable, this will recreate the `container.tag` file and avoid rebuilding the container image.
- `make container_kill` - If you have started a build using Podman Build, and you want to stop it, `Ctrl-C` may not be sufficient. Use this command to terminate the most recently created container.

### Recipes

- `make f.recipe-name` - Download the recipe source.
- `make r.recipe-name` - Build a single recipe, checking if the recipe source has changed, and creating the executable, etc. e.g. `make r.games` (you can't use this command to replace the `make all`, `make fstools` and `make prefix` commands because it don't trigger them, make sure to run them before to avoid errors)

  The package is built even if it is not in your filesystem configuration.

  (This command will continue where you stopped the build process, it's useful to save time if you had a compilation error and patched a crate)

- `make p.recipe-name` - Add the recipe to an existing Redox image
- `make c.recipe-name` - Clean the recipe binaries.
- `make u.recipe-name` - Clean the recipe source code (**please backup or submit your source changes before the execution of this command**).
- `make uc.recipe-name` - A shortcut for `make u.recipe c.recipe`
- `make cr.recipe-name` - A shortcut for `make c.recipe r.recipe`
- `make ucr.recipe-name` - A shortcut for `make u.recipe c.recipe r.recipe` (**please backup or submit your source changes before the execution of this command**).
- `make rp.recipe-name` - A shortcut for `make r.recipe p.recipe`

All recipe commands (f, r, c, u, cr, ucr) can be run with multiple recipes, just separate them with a comma. for example: `make f.recipe1,recipe2` will download the sources of `recipe1` and `recipe2`

### QEMU/VirtualBox

- `make image` - Builds a new QEMU image, `build/harddrive.img`, without checking if any recipes have changed. It can save you some time if you are just updating one recipe with `make r.recipe-name`
- `make mount` - Mounts the Redox image as a filesystem at `$(BUILD)/filesystem`. **Do not use this if QEMU is running**, and remember to use `make unmount` as soon as you are done. This is not recommended, but if you need to get a large file onto or off of your Redox image, this is available as a workaround.
- `make unmount` - Unmounts the Redox image filesystem. Use this as soon as you are done with `make mount`, and **do not start QEMU** until this is done.
- `make qemu` - If a `build/harddrive.img` file exists, QEMU will run using that image. If you want to force a rebuild first, use `make rebuild qemu`. Sometimes `make qemu` will detect changes and rebuild, but this is not typical. If you are interested in a particular combination of QEMU command line options, have a look through `mk/qemu.mk`
- `make qemu gpu=no` - Start QEMU without a GUI (Orbital is disabled).
- `make qemu gpu=virtio` - Start QEMU with the VirtIO GPU driver.
- `make qemu audio=no` - Disable all sound drivers.
- `make qemu usb=no` - Disable all USB drivers.
- `make qemu uefi=yes` - Enable the UEFI boot loader (it supports more screen resolutions).
- `make qemu live=yes` - Fully load the Redox image to RAM.
- `make qemu disk=nvme` - Boot Redox from a NVMe interface (SSD emulation).
- `make qemu disk=usb` - Boot Redox from a virtual USB device.
- `make qemu disk=cdrom` - Boot Redox from a virtual CD-ROM disk.
- `make qemu kvm=no` - Start QEMU without the Linux KVM acceleration.
- `make qemu iommu=no` - Start QEMU without IOMMU.
- `make qemu gdb=yes` - Start QEMU with GDB support (you need to add the `gdbserver` recipe on your filesystem configuration before, then run the `make gdb` command in another shell)
- `make gdb` - Connects the GDB from Linux/BSD/MacOSX to the GDB server (gdbserver) on Redox in QEMU.
- `make qemu option1=value option2=value` - Cumulative QEMU options are supported.
- `make virtualbox` - The same as `make qemu`, but for VirtualBox (it requires the VirtualBox service to be running, run `systemctl status vboxdrv.service` to verify or `akmods; systemctl restart vboxdrv.service` to enable on systems using systemd).

## Environment Variables

- `$(BUILD)` - Represents the `build` folder.
- `$(ARCH)` - Represents the CPU architecture folder at `build`
- `${TARGET}` - Represents the CPU architecture folder at the `cookbook/recipes/recipe-name/target` folder
- `$(CONFIG_NAME)` - Represents your filesystem configuration folder at `build/your-cpu-arch`

We recommend that you use these variables with the `"` symbol to clean any spaces on the path, spaces are interpreted as command separators and will break the commands.

Example:

```
"${VARIABLE_NAME}"
```

If you have a folder inside the variable folder you can call it with:

```
"${VARIABLE_NAME}"/folder-name
```

Or

```
"${VARIABLE_NAME}/folder-name"
```

## Scripts

You can use these scripts to perform actions not implemented as `make` commands in the build system.

- To run a script use the following command:

```sh
scripts/script-name.sh input-text
```

The "input-text" is the word used by the script.

### Changelog

- `scripts/changelog.sh` - Show the changelog of all Redox components.

### Recipe Files

Show all files installed by a recipe.

```sh
scripts/find-recipe.sh recipe-name
```

### Recipe Categories

Run `make` options on some recipe category.

```sh
scripts/category.sh -x category-name
```

Where `x` is your `make` option, it can be `f`, `r`, `c`, `u`, `cr`, `ucr`, `uc` or `ucf`

### Include Recipes

Create a list with `recipe-name = {} #TODO` for quick testing of WIP recipes.

```sh
scripts/include-recipes.sh "TODO.text"
```

You will insert the text after the `#TODO` in the `text` part, it can be found on the `recipe.toml` file of the recipe.

If you want to add recipes to the `ci.toml` filesystem configuration to be available on the package build server, the recipe names must be sorted in alphabetical order, to do this from the output of this script use the following command:

```sh
scripts/include-recipes.sh "TODO.text" | sort
```

### Recipe Analysis

Show the folders and files on the `stage` and `sysroot` folders of some recipe (to identify packaging issues or violations).

```sh
scripts/show-package.sh recipe-name
```

### Recipe Commit Hash

Show the current Git branch and commit of the recipe source.

```sh
scripts/commit-hash.sh recipe-name
```

### Package Size

Show the package size of the recipes (`stage.pkgar` and `stage.tar.gz`), it must be used by package maintainers to enforce the [library linking size policy](https://gitlab.redox-os.org/redox-os/cookbook#library-linking).

```sh
scripts/pkg-size.sh recipe-name
```

### Recipe Location

Show the location of the written recipe.

```sh
scripts/recipe-path.sh recipe-name
```

### Recipe Match

Search some text inside the `recipe.toml` of all recipes and show their content.

(Require `bat` and `ripgrep` installed, run `cargo install bat ripgrep` to install)

```sh
scripts/recipe-match.sh "recipe-name"
```

### Print Recipe

Show the content of the recipe configuration.

```sh
scripts/print-recipe.sh recipe-name
```

### Recipe Executables

List the recipe executables to find duplicates and conflicts.

- By default the script will only verify duplicates, if the `-a` option is used it will print the executable names of all compiled recipes
- The `-arm64` option will show the ARM64 recipe executables
- The `-i686` option will show the i686 recipe executables

```sh
scripts/executables.sh
```

### Cargo Update

Download the recipe source and run `cargo update`

```sh
scripts/cargo-update.sh recipe-name
```

### Dual Boot

- `scripts/dual-boot.sh` - Install Redox in the free space of your storage device and add a boot entry (if you are using the [systemd-boot](https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/) boot loader).

### Ventoy

- `scripts/ventoy.sh` - Create and copy the Redox bootable image to an [Ventoy](https://www.ventoy.net/en/index.html)-formatted device.

### Recipe Debugging (Rust)

- `scripts/backtrace.sh` - Allow the user to copy a Rust backtrace from Redox and retrieve the symbols (use the `-h` option to show the "Usage" message).

## Component Separation

- `relibc` - The cross-compiled recipes will link to the relibc of this folder (build system submodule)
- `redoxfs` - The FUSE driver of RedoxFS (build system submodule, to run on Linux)
- `cookbook/recipes/relibc` - The relibc recipe to be installed inside of Redox for static or dynamic linking of binaries (for native compilation)
- `cookbook/recipes/redoxfs` - The RedoxFS user-space daemon that run inside of Redox (recipe)

## Pinned Commits

The build system pin the last working commit of the submodules, if some submodule is broken because of some commit, the pinned commit avoid the fetch of this broken commit, thus pinned commits increase the development stability (broken changes aren't passed for developers and testers).

(When you run `make pull` the build system update the submodule folders based on the last pinned commit)

### Current Pinned Submodules

- `cookbook`
- `installer`
- `redoxfs`
- `relibc`
- `rust`

### Manual Submodule Update

Whenever a fix or new feature is merged on the submodules, the upstream build system must update the commit hash, to workaround this you can run `git pull` on the folder of the submodule directly, example:

```sh
make pull
```

```sh
cd submodule-folder-name
```

```sh
git checkout master
```

```sh
git pull
```

```sh
cd ..
```

## Git Auto-checkout

The `make rebuild` and `make r.recipe` commands will Git checkout (change the active branch) of the recipe source to `master` (only recipes that fetch Git repositories are affected, thus all Redox components).

If you are working in a separated branch on the recipe source you can't build your changes, to avoid this comment out the `[source]` and `git =` fields from your `recipe.toml` :

```
#[source]
#git = "some-repository-link"
```

### Submodules

The `make pull` command will Git checkout the [submodules](#current-pinned-submodules) active branches to `master` and pin a commit in `HEAD`, if you are working on the build system submodules don't run this command, to keep the build system using your changes.

To update the build system while you have out-of-tree changes in some submodule, run these commands:

- This command will only update the root build system files

```sh
git pull
```

- Now you need to manually update each submodule folder without your changes

```sh
cd submodule-name
```

```sh
git checkout master
```

```sh
git pull
```

```sh
cd ..
```

## Update The Build System

This is the recommended way to update your build system/recipe sources and binaries.

```sh
make pull rebuild
```

If the `make pull` command download new commits of the `relibc` submodule, you will need to run the commands of the [Update relibc](#update-relibc) section.

(The Podman container is updated automatically if upstream add new packages to the Containerfile, but you can also force the container image to be updated with the `make container_clean` command)

## Update Relibc

An outdated relibc copy can contain bugs (already fixed on recent commits) or missing APIs, to update the relibc sources and build it, run:

```sh
make pull
```

```sh
touch relibc
```

```sh
make prefix
```

## Fix Breaking Changes

To learn how to fix breaking changes before and after build system updates read [this](./troubleshooting.md#fix-breaking-changes) section.

### All recipes

To pass the new relibc changes for all recipes (programs are the most common case) you will need to rebuild all recipes, unfortunately it's not possible to use `make rebuild` because it can't detect the relibc changes to trigger a complete rebuild.

To clean all recipe binaries and trigger a complete rebuild, run:

```sh
make clean all
```

### One Recipe

To pass the new relibc changes to one recipe, run:

```sh
make cr.recipe-name
```

## Configuration

You can find the global settings on the [Configuration Settings](./configuration-settings.md) page.

### Format

The Redox configuration files use the [TOML](https://toml.io/en/) format, it has a very easy syntax and is very flexbile.

You can see what the format supports on the [TOML](https://toml.io/en/v1.0.0) website.

### Filesystem Customization

Read the [Filesystem Customization](./configuration-settings.md#filesystem-customization) section.

## Cross-Compilation

The Redox build system is an example of [cross-compilation](https://en.wikipedia.org/wiki/Cross_compiler). The Redox [toolchain](https://static.redox-os.org/toolchain/) runs on Linux, and produces Redox executables. Anything that is installed with your package manager is just part of the toolchain and does not go on Redox.

In the background, the `make all` command downloads the Redox toolchain to build all recipes (patched forks of rustc, GCC and LLVM).

If you are using Podman, the `podman_bootstrap.sh` script will download an Ubuntu container and `make all` will install the Redox toolchain, all recipes will be compiled in the container.

The recipes produce Redox-specific executables. At the end of the build process, these executables are installed inside the QEMU image.

The `relibc` (Redox C Library) provides the Redox [system calls](https://docs.rs/redox_syscall/latest/syscall/) to any software.

- [OSDev article about cross-compilation](https://wiki.osdev.org/Why_do_I_need_a_Cross_Compiler%3F)

## Build Phases

Every build system command/script has phases, read this page to know them.

- [Build Phases](./build-phases.md)
