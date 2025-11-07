# Build Process

This page explain what each build system command does in detail.

(Read the [Build System](./build-system-reference.md) to know the context of each command)

- [Bootstrap Scripts](#bootstrap-scripts)
- [Toolchain](#toolchain)
- [Build System](#build-system)
- [Recipes](#recipes)
- [QEMU](#qemu)

## Bootstrap Scripts

### podman_bootstrap.sh

- Install Podman, GNU Make, Rust, FUSE and QEMU if it's not installed in the host system.
- Download the build system sources (if you run without the `-d` option: `./podman_bootstrap.sh -d`)
- Show a message with the commands to build the Redox system.

### native_bootstrap.sh

- Install the Rust toolchain (using [rustup.rs](https://rustup.rs/)).
- Install the recipe build tools from your Linux or Unix-like distribution.
- Download the build system sources (if you run without the `-d` option: `./native_bootstrap.sh -d`)
- Show a message with the commands to build the Redox system.

## Toolchain

### make prefix

- Download our Rust and GCC forks from the [Redox build server](https://static.redox-os.org/toolchain/) (if it's not present or you if you executed `rm -rf prefix` to fix issues).
- Build the `relibc` submodule.

### make prefix (after "touch relibc" command)

- Build the new relibc changes

## Build System

### make pull

- Update the build system source and submodules
- Checkout submodules to the latest pinned commit

### make all (first execution)

- Download the binaries of the Redox toolchain from the build server (if `make prefix` was not executed before).
- Download the sources of the recipes specified on your filesystem configuration.
- Cross-compile recipes to Redox.
- Package recipe binaries as `pkgar` files.
- Install packages in the QEMU virtual disk formatted with RedoxFS.

### make all (second execution and next)

If the `build/$ARCH/$CONFIG/repo.tag` file is up to date, it won't do anything. If the `repo.tag` file is missing it will work like the `make rebuild` command.

### make all (Podman environment, first execution)

- Download the Redox container image.
- Install the Rust and Redox toolchains (inside the container).
- Install the recipe build tools (inside the container).
- Download the sources of the recipes specified on your filesystem configuration.
- Cross-compile recipes to Redox (inside the container).
- Package recipe binaries as `pkgar` files.
- Install recipe packages in the QEMU virtual disk formatted with RedoxFS.

### make rebuild

- Verify source changes on recipes (if available, download them) or if a new recipe was added to the filesystem configuration.
- Cross-compile recipes with changes to Redox.
- Package recipe binaries with changes as `pkgar` files.
- Install recipe packages with changes in the QEMU virtual disk formatted with RedoxFS.

### make image

- Verify source changes on recipes (if the build system was updated or has changes)
- Create a new Redox image with new recipe changes or recipes

## Recipes

### make r.recipe

- Search the recipe location.
- Verify if the `source` folder is present, if not, download the source from the method specified inside the `recipe.toml` (this step will be ignored if the `[source]` section and its data types aren't present or were commented out).
- Build the recipe library dependencies as shared or static objects.
- Start the compilation based on the template of the `recipe.toml`
- If the recipe is using Cargo, it will download the crates, build them, link them/relibc to the program binary.
- If the recipe is using GNU Autotools, CMake or Meson, they will check the build environment and dependencies presence/versions for compatibility, build the libraries or the program and link them/relibc to the final binary.
- Package the recipe binaries.

## QEMU

### make qemu

- It checks for pending changes, if found, it will trigger `make rebuild`.
- It checks the existence of the QEMU image, if not available, it will works like `make image`.
- A command with custom arguments is passed to QEMU to boot Redox without problems.
- The QEMU window is shown with a menu to choose the resolution.
- The bootloader does a bootstrap of the kernel, the kernel starts the init, the init starts the user-space daemons and Orbital.
- The Orbital login screen appear.
