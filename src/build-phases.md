# Build Phases

Every build system command and script has phases, this page documents them.

- [native_bootstrap.sh](#native_bootstrapsh)
- [podman_bootstrap.sh](#podman_boostrapsh)
- [make all (first run)](#make-all-first-run)
- [make all (second run)](#make-all-second-run)
- [make all (Podman, first run)](#make-all-podman-first-run)
- [make prefix](#make-prefix)
- [make prefix (after "touch relibc")](#make-prefix-after-touch-relibc)
- [make rebuild](#make-rebuild)
- [make r.recipe](#make-rrecipe)
- [make qemu](#make-qemu)

### native_bootstrap.sh

This is the script used to do the initial configuration of the build system, see its phases below:

- Install the Rust toolchain (using [rustup.rs](https://rustup.rs/)) and add `cargo` to the shell PATH.
- Install the packages (based on your Unix-like distribution) of the development tools to build all recipes.
- Download the build system sources (if you run without the `-d` option - `./native_bootstrap.sh -d`)
- Show a message with the commands to build the Redox system.

### podman_bootstrap.sh

This script is the alternative to `native_bootstrap.sh` for Podman, used to configure the build system for a Podman environment, see its phases below:

- Install Podman, GNU Make, FUSE and QEMU if it's not installed.
- Download the Debian container and install the recipe dependencies.
- Download the build system sources (if you run without the `-d` option - `./podman_bootstrap.sh -d`)
- Show a message with the commands to build the Redox system.

### make all (first run)

This is the command used to build all recipes inside your default TOML configuration (`config/your-cpu-arch/desktop.toml` or the one inside your `.config`), see its phases below:

- Download the binaries of the Redox toolchain (patched rustc, GCC and LLVM) from the build server.
- Download the sources of the recipes specified on your TOML configuration.
- Build the recipes.
- Package the recipes.
- Create the QEMU image and install the packages.

### make all (second run)

If the `build/$ARCH/$CONFIG/repo.tag` file is up to date, it won't do anything. If the `repo.tag` file is missing it will works like `make rebuild`.

### make all (Podman environment, first run)

This command on Podman works in a different way, see its phases below:

- Download the Redox container (Ubuntu + Redox toolchain).
- Install the Rust toolchain inside the container.
- Install the Ubuntu packages of the development tools to build all recipes (inside the container).
- Download the sources of the recipes specified on your TOML configuration.
- Build the recipes.
- Package the recipes.
- Create the QEMU image and install the packages.

### make prefix

This command is used to download the build system toolchain, see its phases below:

- Download the Rust and GCC forks from the [build server](https://static.redox-os.org/toolchain/) (if it's not present or you if you executed `rm -rf prefix` to fix issues).
- Build the `relibc` submodule.

### make prefix (after "touch relibc")

- Build the new relibc changes

### make rebuild

This is the command used to verify and build the recipes with changes, see its phases below:

- Verify source changes on recipes (if confirmed, download them) or if a new recipe was added to the TOML configuration.
- Build the recipes with changes.
- Package the recipes with changes.
- Create the QEMU image and install the packages.

### make r.recipe

This is the command used to build a recipe, see its phases below.

- Search where the recipe is stored.
- Verify if the `source` folder is present, if not, download the source from the method specified inside the `recipe.toml` (this step will be ignored if the `[source]` and `git =` fields are commented out).
- Build the recipe dependencies as static objects (for static linking).
- Start the compilation based on the template of the `recipe.toml`
- If the recipe is using Cargo, it will download the crates, build them, link them/relibc to the program binary.
- If the recipe is using GNU Autotools, CMake or Meson, they will check the build environment and the presence library objects, build the libraries or the program and link them/relibc to the final binary.
- Package the recipe.

Typically, `make r.recipe` is used with `make image` to quickly build a recipe and create an image to test it.

### make qemu

This is the command used to run Redox inside QEMU, see its phases below:

- It checks for pending changes, if found, it will trigger `make rebuild`.
- It checks the existence of the QEMU image, if not available, it will works like `make image`.
- A command with custom arguments is passed to QEMU to boot Redox without problems.
- The QEMU window is shown with a menu to choose the resolution.
- The bootloader does a bootstrap of the kernel, the kernel starts the init, the init starts the user-space daemons and Orbital.
- The Orbital login screen appear.
