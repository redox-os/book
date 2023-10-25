# Build Phases

Every build system command/script has phases, this page will document them.

- [bootstrap.sh](#bootstrapsh)
- [podman_bootstrap.sh](#podman_boostrapsh)
- [make all (first run)](#make-all-first-run)
- [make all (second run)](#make-all-second-run)
- [make all (Podman, first run)](#make-all-podman-first-run)
- [make prefix](#make-prefix)
- [make rebuild](#make-rebuild)
- [make r.recipe](#make-rrecipe)
- [make qemu](#make-qemu)

### `bootstrap.sh`

This is the script used to do the initial configuration of the build system, see its phases below:

1. Install the Rust toolchain (using [rustup.rs](https://rustup.rs/)) and add `cargo` to the shell PATH.
2. Install all necessary packages (based on your Unix-like distribution) of the development tools to build all recipes.
3. Download the build system source/submodules (if you run without the `-d` option - `./bootstrap.sh -d`)
4. Show a message with the commands to build the Redox system.

### `podman_bootstrap.sh`

This script is the alternative to `bootstrap.sh` for non-Debian systems, used to configure the build system for use with Podman., see its phases below:

1. Install Podman, make, FUSE and QEMU if it's not installed.
2. Download the build system sources (if you run without the `-d` option - `./podman_bootstrap.sh -d`)
4. Show a message with the commands to build the Redox system.

### `make all` (first run)

This is the command used to build all recipes inside your default TOML configuration (`config/$ARCH/desktop.toml` or the one inside your `.config`), see its phases below:

1. Download the binaries of the Redox toolchain (patched rustc, GCC and LLVM) from the CI server.
2. Download the sources of the recipes specified on your TOML configuration.
3. Build the recipes.
4. Package the recipes.
5. Create the QEMU image and install the packages.

### `make all` (second run)

If the `build/$ARCH/$CONFIG/repo.tag` file is up to date, it won't do anything. If the `repo.tag` file is missing it will works like `make rebuild`.

### `make all` (Podman, first run)

This command on Podman works in a different way, see its phases below:

1. Install the Redox container (Ubuntu + Redox toolchain).
2. Install the Rust toolchain inside this container.
3. Install the Ubuntu packages (inside the container) of the development tools to build all recipes.
4. Download the sources of the recipes specified on your TOML configuration.
5. Build the recipes.
6. Package the recipes.
7. Create the QEMU image and install the packages.

### `make prefix`

This command is used to download the build system toolchain, see its phases below:

1. Download the Rust and GCC forks from the [CI server](https://static.redox-os.org/toolchain/) (if it's not present or you if you executed `rm -rf prefix` to fix issues).
2. Build the `relibc` submodule.

### `make rebuild`

This is the command used to check/build the recipes with changes, see its phases below:

1. Check for source changes on recipes (if confirmed, download them) or if a new recipe was added to the TOML configuration.
2. Build the recipes with changes.
3. Package the recipes with changes.
4. Create the QEMU image and install the packages.

### `make r.recipe`

This is the command used to build a recipe, see its phases below.

1. Search where the recipe is stored.
2. See if the `source` folder is present, if not, download the source from the method specified inside the `recipe.toml` (this step will be ignored if the `[source]` and `git =` fields are commented out of the `recipe.toml`).
3. Build the recipe dependencies as static objects (for static linking).
4. Start the compilation based on the template of the `recipe.toml`.
5. If the recipe is using Cargo, it will download the crates, build them and link on the final binary of the program.
6. If the recipe is using GNU Autotools, CMake or Meson, they will check the build environment and library sources to link on the final binary of the program.
7. Package the recipe.

Typically, `make r.recipe` is used with `make image` to quickly build a recipe and create an image to test it.

### `make qemu`

This is the command used to run Redox inside a virtual machine, see its phases below:

1. It checks for pending changes, if found, it will trigger `make rebuild`.
2. It checks the existence of the QEMU image, if not available, it will works like `make image`.
3. A command with custom arguments is passed to QEMU to boot Redox without problems.
4. The QEMU window is shown with a menu to choose the resolution.
5. The boot process happens (the bootloader does a bootstrap to the kernel and the init start the userspace daemons).
6. The Orbital login screen appear.
