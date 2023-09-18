# Build System Quick Reference

The build system downloads/creates several files that you may want to know about. There are also several `make` targets mentioned above, and a few extras that you may find useful. Here's a quick summary. All file paths are relative to your `redox` base directory.

- [Build System Organization](#build-system-organization)
  - [Root Folder](#root-folder)
  - [Make Configuration](#make-configuration)
  - [Podman Configuration](#podman-configuration)
  - [Build System Configuration](#build-system-configuration)
  - [Cookbook](#cookbook)
  - [Build System Files](#build-system-files)
- [Make Commands](#make-commands)
  - [Build System](#build-system)
  - [Recipes](#recipes)
  - [QEMU/VirtualBox](#qemuvirtualbox)
- [Environment Variables](#environment-variables)
- [Scripts](#scripts)
- [Crates](#crates)
  - [Current projects with crates](#current-projects-with-crates)
  - [Manual patching](#manual-patching)
- [Pinned commits](#pinned-commits)
  - [Current pinned submodules](#current-pinned-submodules)
  - [Manual submodule update](#manual-submodule-update)
- [Update the build system](#update-the-build-system)
- [Update relibc](#update-relibc)
  - [All recipes](#all-recipes)
  - [One recipe](#one-recipe)
  - [Update relibc crates](#update-relibc-crates)
- [Configuration](#configuration)
- [Cross-Compilation](#cross-compilation)
- [Build Phases](#build-phases)

## Build System Organization

### Root Folder

- `Makefile` - The main makefile for the system, it loads all the other makefiles.
- `.config` - Where you change your build system settings. It is loaded by the Makefile. It is ignored by `git`.

### Make Configuration

- `mk/config.mk` - The build system's own settings are here. You can override these settings in your `.config`, don't change them here.
- `mk/*.mk` - The rest of the makefiles. You should not need to change them.

### Podman Configuration

- `podman/redox-base-containerfile` - The file used to create the image used by Podman Build. The installation of Ubuntu packages needed for the build is done here. See [Adding Ubuntu Packages to the Build](./ch08-02-advanced-podman-build.md#adding-ubuntu-packages-to-the-build) if you need to add additional Ubuntu packages.

### Build System Configuration

- `config/$(ARCH)/$(CONFIG_NAME).toml` - The build configuration with system settings, paths and recipes to be included in the QEMU image that will be built, e.g. `config/x86_64/desktop.toml`.
- `config/$(ARCH)/server.toml` - The `server` variant with system components only (try this config if you have boot problems on QEMU/real hardware).
- `config/$(ARCH)/desktop.toml` - The default build config with system components and the Orbital desktop environment.
- `config/$(ARCH)/demo.toml` - The `demo` variant with optional programs and games.
- `config/$(ARCH)/ci.toml` - The continuous integration configuration, recipes added here become packages on [CI server](https://static.redox-os.org/pkg/).
- `config/$(ARCH)/dev.toml` - The development variant with GCC and Rust included.
- `config/$(ARCH)/desktop-minimal.toml` - The minimal `desktop` variant for low-end computers.
- `config/$(ARCH)/server-minimal.toml` - The minimal `server` variant for low-end computers.
- `config/$(ARCH)/resist.toml` - The build with the `resist` POSIX test suite.
- `config/$(ARCH)/acid.toml` - The build with the `acid` stress test suite.
- `config/$(ARCH)/jeremy.toml` - The build of [Jeremy Soller](https://soller.dev/) (creator/BDFL of Redox) with the recipes that he is testing in the moment.

### Cookbook

- `cookbook/recipes/recipe-name` - A recipe (software port) directory (represented as `recipe-name`), this directory holds the `recipe.toml` file.
- `cookbook/recipes/recipe-name/recipe.toml` - The recipe configuration file, a recipe contains instructions for obtaining sources via tarball or git, then creating executables or other files to include in the Redox filesystem. Note that a recipe can contain dependencies that cause other recipes to be built, even if the dependencies are not otherwise part of your Redox build.

  To learn more about the recipe system read [this](./ch09-03-porting-applications.md) page.

- `cookbook/recipes/recipe-name/recipe.sh` - The old recipe configuration format (can't be used as dependency of a recipe with a TOML configuration).
- `cookbook/recipes/recipe-name/source.tar` - The tarball of the recipe (renamed).
- `cookbook/recipes/recipe-name/source` - The directory where the recipe source is extracted/downloaded.
- `cookbook/recipes/recipe-name/target` - The directory where the recipe binaries are stored.
- `cookbook/recipes/recipe-name/target/${TARGET}` - The directory for the recipes binaries of the CPU architecture (`${TARGET}` is the environment variable of the CPU).
- `cookbook/recipes/recipe-name/target/${TARGET}/build` - The directory where the recipe build system run its commands.
- `cookbook/recipes/recipe-name/target/${TARGET}/stage` - The directory where recipe binaries go before the packaging, after `make all` or `make rebuild` the [installer](https://gitlab.redox-os.org/redox-os/installer) will extract the recipe package on the QEMU image, generally at `/bin` or `/lib` on Redox filesystem hierarchy.
- `cookbook/recipes/recipe-name/target/${TARGET}/sysroot` - The folder where recipe build dependencies (libraries) goes, for example: `library-name/src/example.c`
- `cookbook/recipes/recipe-name/target/${TARGET}/stage.pkgar` - Redox package file.
- `cookbook/recipes/recipe-name/target/${TARGET}/stage.sig` - Signature for the `tar` package format.
- `cookbook/recipes/recipe-name/target/${TARGET}/stage.tar.gz` - Legacy `tar` package format, produced for compatibility reasons as we are working to make the package manager use the `pkgar` format.
- `cookbook/recipes/recipe-name/target/${TARGET}/stage.toml` - Contains the runtime dependencies of the package and is part of both package formats.
- `cookbook/*` - Part of the Cookbook system, these scripts and utilities help build the recipes.
- `prefix/*` - Tools used by the cookbook system. They are normally downloaded during the first system build.

  If you are having a problem with the build system, you can remove the `prefix` directory and it will be recreated during the next build.

### Build System Files

- `build` - The directory where the build system will place the final image. Usually `build/$(ARCH)/$(CONFIG_NAME)`, e.g. `build/x86_64/desktop`.
- `build/harddrive.img` - The Redox image file, to be used by QEMU or VirtualBox for virtual machine execution on a Linux host.
- `build/livedisk.iso` - The Redox bootable image file, to be copied to a USB drive or CD for live boot and possible installation.
- `build/fetch.tag` - An empty file that, if present, tells the build system that fetching of recipe sources has been done.
- `build/repo.tag` - An empty file that, if present, tells the build system that all recipes required for the Redox image have been successfully built. **The build system will not check for changes to your code when this file is present.** Use `make rebuild` to force the build system to check for changes.
- `build/podman` - The directory where Podman Build places the container user's home directory, including the container's Rust installation. Use `make container_clean` to remove it. In some situations, you may need to remove this directory manually, possibly with root privileges.
- `build/container.tag` - An empty file, created during the first Podman Build, so Podman Build knows a reusable Podman image is available. Use `make container_clean` to force a rebuild of the Podman image on your next `make rebuild`.
  
## Make Commands

You can combine `make` targets, but order is significant. For example, `make r.games image` will build the `games` recipe and create a new Redox image, but `make image r.games` will make the Redox image before it builds the recipe.

### Build System

- `make pull` - Update the sources for the build system without building.
- `make all` - Builds the entire system, checking for changes and only building as required. Only use this for the first build. If the system was successfully built previously, this command may report `Nothing to be done for 'all'`, even if some recipes have changed. Use `make rebuild` instead.

(You need to use this command if the Redox toolchain changed, after the `make clean` command)

- `make rebuild` - Rebuild all recipes with changes (it don't detect changes on the Redox toolchain), including download changes from GitLab, it should be your normal `make` target.
- `make fetch` - Update recipe sources, according to each recipe, without building them. Only the recipes that are included in your `(CONFIG_NAME).toml` are fetched. Does nothing if `$(BUILD)/fetch.tag` is present. You won't need this.
- `make clean` - Clean all recipe binaries (Note that `make clean` may require some tools to be built).
- `make unfetch` - Clean all recipe sources.
- `make distclean` - Clean all recipe sources and binaries (a complete `make clean`).
- `make repo` - Package the recipe binaries, according to each recipe. Does nothing if `$(BUILD)/repo.tag` is present. You won't need this.
- `make live` - Creates a bootable image, `build/livedisk.iso`. Recipes are not usually rebuilt.
- `make env` - Creates a shell with the build environment initialized. If you are using Podman Build, the shell will be inside the container, and you can use it to debug build issues such as missing packages.
- `make container_su` - After creating a container shell using `make env`, and while that shell is still running, use `make container_su` to enter the same container as `root`. See [Debugging your Build Process](./ch08-02-advanced-podman-build.md#debugging-your-build-process).
- `make container_clean` - If you are using Podman Build, this will discard images and other files created by it.
- `make container_touch` - If you have removed the file `build/container.tag`, but the container image is still usable, this will recreate the `container.tag` file and avoid rebuilding the container image.
- `make container_kill` - If you have started a build using Podman Build, and you want to stop it, `Ctrl-C` may not be sufficient. Use this command to terminate the most recently created container.

### Recipes

- `make f.recipe-name` - Download the recipe source.
- `make r.recipe-name` - Build a single recipe, checking if the recipe source has changed, and creating the executable, etc. e.g. `make r.games`.

  The package is built even if it is not in your filesystem configuration.

  (This command will continue where you stopped the build process, it's useful to save time if you had a compilation error and patched a crate)

- `make c.recipe-name` - Clean the binary and intermediate build artifacts of the recipe.
- `make u.recipe-name` - Clean the recipe source.

### QEMU/VirtualBox

- `make qemu` - If a `build/harddrive.img` file exists, QEMU is run using that image. If you want to force a rebuild first, use `make rebuild qemu`. Sometimes `make qemu` will detect a change and rebuild, but this is not typical. If you are interested in a particular combination of QEMU command line options, have a look through `mk/qemu.mk`.
- `make qemu vga=no` - Start QEMU without a GUI (also disable Orbital).
- `make qemu vga=virtio` - Start QEMU with the VirtIO GPU driver (2D acceleration).
- `make qemu kvm=no` - Start QEMU without the Linux KVM acceleration.
- `make qemu iommu=no` - Start QEMU without the IOMMU.
- `make qemu audio=no` - Disable all audio drivers.
- `make qemu usb=no` - Disable all USB drivers.
- `make qemu efi=yes` - Enable UEFI.
- `make qemu live=yes` - Start a live disk (loads the entire image into RAM).
- `make qemu vga=no kvm=no` - Cumulative QEMU options is supported.
- `make image` - Builds a new QEMU image, `build/harddrive.img`, without checking if any recipes have changed. Not recommended, but it can save you some time if you are just updating one recipe with `make r.recipe-name`.
- `make gdb` - Connects `gdb` to the Redox image in QEMU. Join us on [chat](./ch13-01-chat.md) if you want to use this.
- `make mount` - Mounts the Redox image as a filesystem at `$(BUILD)/filesystem`. **Do not use this if QEMU is running**, and remember to use `make unmount` as soon as you are done. This is not recommended, but if you need to get a large file onto or off of your Redox image, this is available as a workaround.
- `make unmount` - Unmounts the Redox image filesystem. Use this as soon as you are done with `make mount`, and **do not start QEMU** until this is done.
- `make virtualbox` - The same as `make qemu`, but for VirtualBox.

## Environment Variables

These variables are used by programs or commands.

- `$(BUILD)` - Represents the `build` folder.
- `$(ARCH)` - Represents the CPU architecture folder at `build`.
- `${TARGET}` - Represents the CPU architecture folder at `cookbook/recipes/recipe-name/target`.
- `$(CONFIG_NAME)` - Represents your build configuration folder at `build/$(ARCH)/$(CONFIG_NAME)`.

We recommend that you use these variables with the `"` symbol to clean any spaces on the path, spaces are interpreted as command separators and will break the path.

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

You can use these scripts to perform actions not implemented as commands in the Cookbook build system.

- `scripts/changelog.sh` - Show the changelog of all Redox components/recipes.
- `scripts/find-recipe.sh` - Show all files installed by a recipe.

```sh
scripts/find-recipe.sh recipe-name
```

- `scripts/rebuild-recipe.sh` - Alternative to `make u.recipe r.recipe c.recipe u.recipe` that clean your recipe source/binary (delete `source`, `source.tar` and `target` in the recipe folder) to make a new build.

```sh
scripts/rebuild-recipe.sh recipe-name
```

## Crates

Some Redox projects have crates on `crates.io`, thus they use a version-based development, if some change is sent to their repository they need to release a new version on `crates.io`, it will have some delay.

### Current projects with crates

- [redox_syscall](https://crates.io/crates/redox_syscall)
- [redoxfs](https://crates.io/crates/redoxfs)
- [redoxer](https://crates.io/crates/redoxer)
- [redox_installer](https://crates.io/crates/redox_installer)
- [redox-users](https://crates.io/crates/redox_users)
- [redox-buffer-pool](https://crates.io/crates/redox-buffer-pool)
- [redox_log](https://crates.io/crates/redox-log)
- [redox_termios](https://crates.io/crates/redox_termios)
- [redox-daemon](https://crates.io/crates/redox-daemon)
- [redox_event](https://crates.io/crates/redox_event)
- [redox_event_update](https://crates.io/crates/redox_event_update)
- [redox_pkgutils](https://crates.io/crates/redox_pkgutils)
- [redox_uefi](https://crates.io/crates/redox_uefi)
- [redox_uefi_alloc](https://crates.io/crates/redox_uefi_alloc)
- [redox_dmi](https://crates.io/crates/redox_dmi)
- [redox_hwio](https://crates.io/crates/redox_hwio)
- [redox_intelflash](https://crates.io/crates/redox_intelflash)
- [redox_liner](https://crates.io/crates/redox_liner)
- [redox_simple_endian](https://crates.io/crates/redox_simple_endian)
- [redox_uefi_std](https://crates.io/crates/redox_uefi_std)
- [ralloc](https://crates.io/crates/ralloc)
- [orbclient](https://crates.io/crates/orbclient)
- [orbclient_window_shortcuts](https://crates.io/crates/orbclient_window_shortcuts)
- [orbfont](https://crates.io/crates/orbfont)
- [orbimage](https://crates.io/crates/orbimage)
- [orbterm](https://crates.io/crates/orbterm)
- [orbutils](https://crates.io/crates/orbutils)
- [slint_orbclient](https://crates.io/crates/slint_orbclient)
- [ralloc_shim](https://crates.io/crates/ralloc_shim)
- [ransid](https://crates.io/crates/ransid)
- [gitrepoman](https://crates.io/crates/gitrepoman)
- [pkgar](https://crates.io/crates/pkgar)
- [pkgar-core](https://crates.io/crates/pkgar-core)
- [pkgar-repo](https://crates.io/crates/pkgar-repo)
- [termion](https://crates.io/crates/termion)
- [reagent](https://crates.io/crates/reagent)
- [gdb-protocol](https://crates.io/crates/gdb-protocol)
- [orbtk](https://crates.io/crates/orbtk)
- [orbtk_orbclient](https://crates.io/crates/orbtk_orbclient)
- [orbtk-render](https://crates.io/crates/orbtk-render)
- [orbtk-shell](https://crates.io/crates/orbtk-shell)
- [orbtk-tinyskia](https://crates.io/crates/orbtk-tinyskia)

### Manual patching

If you don't want to wait a new release on `crates.io`, you can patch the crate temporarily by fetching the version you need from GitLab and changing the crate version in `Cargo.toml` to `crate-name = { path = "path/to/crate" }`.

## Pinned commits

The build system pin the last working commit of the submodules, if some submodule is broken because of some commit, the pinned commit avoid the fetch of this broken commit, thus pinned commits increase the development stability (broken changes aren't passed for developers/testers).

(When you run `make pull` the build system update the submodule folders based on the last pinned commit)

### Current pinned submodules

- `cookbook`
- `installer`
- `redoxfs`
- `relibc`
- `rust`

### Manual submodule update

Whenever a fix or new feature is merged on the submodules, the upstream build system must update the commit hash, to workaround this you can run `git pull` on the folder of the submodule directly, example:

```sh
make pull
cd submodule-folder-name
git checkout master
git pull
cd ..
```

## Update the build system

This is the recommended way to update your sources/binaries.

```sh
make pull
make rebuild
```

(If the `make pull` command download new commits of the `relibc` submodule, you will need to run the commands of the section below)

Some new changes will require a complete rebuild (you will need to read the Dev room in our [chat](./ch13-01-chat.md) to know if some heavy MR was merged and run the `make clean all` command) or a new build system copy (run the [bootstrap.sh](./ch02-05-building-redox.md#bootstrap-prerequisites-and-fetch-sources) script again or run the commands of [this](./ch08-01-advanced-build.md#clone-the-repository) section), but the commands above cover the most cases.

## Update relibc

An outdated relibc copy can contain bugs (already fixed on recent commits) or outdated crates, to update the relibc sources and build it, run:

```sh
make pull
touch relibc
make prefix
```

### All recipes

To pass the new relibc changes for all recipes (system components are the most common use case) you will need to rebuild all recipes, unfortunately it's not possible to use `make rebuild` because it can't detect the relibc changes to trigger a complete rebuild.

To clean all recipe binaries and trigger a complete rebuild, run:

```sh
make clean
make all
```
Or

```sh
make clean all
```

### One recipe

To pass the new relibc changes to one recipe, run:

```sh
make c.recipe-name
make r.recipe-name
```
Or

```sh
make c.recipe-name r.recipe-name
```

### Update relibc crates

Sometimes you need to update the relibc crates, run these commands between the `make pull` and `touch relibc` commands:

```sh
cd relibc
cargo update -p crate
cd ..
```
Or

```sh
cd relibc
cargo update
cd ..
```

## Configuration

- [Configuration Settings](./ch02-07-configuration-settings.md)

## Cross-Compilation

The Redox build system is an example of [cross-compilation](https://en.wikipedia.org/wiki/Cross_compiler). The Redox [toolchain](https://static.redox-os.org/toolchain/) runs on Linux, and produces Redox executables. Anything that is installed with your package manager is just part of the toolchain and does not go on Redox.

As the recipes are [statically linked](https://en.wikipedia.org/wiki/Static_build), Redox doesn't have packages with shared libraries (lib*) seen in most Unix/Linux packages.

In the background, `make all` downloads the Redox toolchain to build all recipes (patched forks of rustc, GCC and LLVM).

If you are using Podman, the `podman_bootstrap.sh` script will download an Ubuntu container and `make all` will install the Redox toolchain, all recipes will be compiled in the container.

The recipes produce Redox-specific executables. At the end of the build process, these executables are installed inside the QEMU image.

The `relibc` (Redox C Library) provides the Redox [system calls](https://docs.rs/redox_syscall/latest/syscall/) to any software.

- [OSDev article on cross-compiling](https://wiki.osdev.org/Why_do_I_need_a_Cross_Compiler%3F)

## Build Phases

Every build system command/script has phases, read this page to know them.

- [Build Phases](./ch08-07-build-phases.md)