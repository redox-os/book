# Porting Applications using Recipes

The [Including Programs in Redox](./ch09-01-including-programs.md) page gives an example to port/modify a pure Rust program, here we will explain the advanced way to port Rust programs, mixed Rust programs (Rust + C/C++ libraries, for example) and C/C++ programs.

(Before reading this page you **must** read the [Build System Quick Reference](./ch08-06-build-system-reference.md) and [Coding and Building](./ch09-02-coding-and-building.md) pages)

- [Recipe](#recipe)
    - [Quick Recipe Template](#quick-recipe-template)
- [Cookbook](#cookbook)
    - [Custom Compiler](#custom-compiler)
    - [Cross Compilation](#cross-compilation)
    - [Templates](#templates)
    - [Custom Template](#custom-template)
        - [Cargo script template](#cargo-script-template)
        - [Configure script template](#configure-script-template)
        - [CMake script template](#cmake-script-template)
        - [Cargo packages script template](#cargo-packages-script-template)
        - [Cargo flags script template](#cargo-flags-script-template)
        - [Disable the default Cargo flags](#disable-the-default-cargo-flags)
        - [Enable all Cargo flags](#enable-all-cargo-flags)
        - [Cargo examples script template](#cargo-examples-script-template)
        - [Add the Cookbook "bin" folder to the PATH](#add-the-cookbook-bin-folder-to-the-path)
        - [Insert Cargo build artifacts in the build directory](#insert-cargo-build-artifacts-in-the-build-directory)
        - [Add the "sysroot" includes for most C compilation](#add-the-sysroot-includes-for-most-c-compilation)
        - [Add the "sysroot" libraries and build binaries statically for most C compilation](#add-the-sysroot-libraries-and-build-binaries-statically-for-most-c-compilation)
        - [Ensure that pkg-config gets the right flags from the "sysroot"](#ensure-that-pkg-config-gets-the-right-flags-from-the-sysroot)
        - [Strip binaries](#strip-binaries)
        - [Remove libtool files](#remove-libtool-files)
        - [Remove Cargo install files](#remove-cargo-install-files)
- [Sources](#sources)
    - [Tarballs](#tarballs)
    - [Git Repositories](#git-repositories)
- [Dependencies](#dependencies)
    - [Bundled Libraries](#bundled-libraries)
- [Testing/Building](#testingbuilding)
- [Update crates](#update-crates)
    - [One or more crates](#one-or-more-crates)
    - [All crates](#all-crates)
    - [Verify the dependency tree](#verify-the-dependency-tree)
- [Patch crates](#patch-crates)
    - [Redox forks](#redox-forks)
    - [Local patches](#local-patches)
- [Cleanup](#cleanup)
- [Search Text On Recipes](#search-text-on-recipes)
- [Search for functions on relibc](#search-for-functions-on-relibc)
- [Create a BLAKE3 hash for your recipe](#create-a-blake3-hash-for-your-recipe)
- [Submitting MRs](#submitting-mrs)

## Recipe

A recipe is how we call a software port on Redox, on this section we will explain the recipe structure and things to consider.

Create a folder in `cookbook/recipes` with a file named as `recipe.toml` inside, we will edit this file to fit the program needs.

- Commands example:

```sh
cd ~/tryredox/redox
mkdir cookbook/recipes/program_example
nano cookbook/recipes/program_example/recipe.toml
```

Your `recipe.toml` file could look like this:

```toml
[source]
git = "software-repository-link.git"
branch = "branch-name"
rev = "commit-revision"
tar = "software-tarball-link.tar.gz"
blake3 = "your-hash"
patches = [
    "patch1.patch",
    "patch2.patch",
]
[build]
template = "build-system"
dependencies = [
    "library1",
    "library2",
]
script = """
insert your script here
"""
[package]
dependencies = [
    "runtime1",
    "runtime2",
]
```

- Don't remove/forget the `[build]` section (`[source]` section can be removed if you don't use `git =` and `tar =` or have the `source` folder present on your recipe folder).
- Insert `git =` to clone your software repository, if it's not available the build system will build the contents inside the `source` folder on recipe directory.
- Insert `branch =` if your want to use other branch.
- Insert `rev =` if you want to use a commit revision (SHA1).
- Insert `tar =` to download/extract tarballs, this can be used instead of `git =`.
- Insert `blake3 =` to add [BLAKE3](https://en.wikipedia.org/wiki/BLAKE_(hash_function)) checksum verification for the tarball of your recipe.
- Insert `patches =` to use patch files, they need to be in the same directory of `recipe.toml` (not needed if your program compile/run without patches).
- Insert `dependencies =` if your software have dependencies, to make it work your dependencies/libraries need their own recipes (if your software doesn't need this, remove it from your `recipe.toml`).
- Insert `script =` to run your custom script (`script =` is enabled when you define your `template =` as `custom`).

Note that there are two `dependencies =`, one below the `[build]` section and other below `[package]` section.

- Below `[build]` - development libraries.
- Below `[package]` - runtime dependencies (packages installed on Redox or data files).

### Quick Recipe Template

This is a recipe template for a quick porting workflow.

```toml
#TODO Not compiled or tested
[source]
tar = "tarball-link"
[build]
template = "build-system"
dependencies = [
    "library1",
]
```

You can quickly copy/paste this template on each `recipe.toml`, that way you spent less time writting and has less chances for typos.

If the program use a Git repository, you can easily rename the `tar` to `git`.

If the program don't need dependencies, you can quickly remove the `dependencies = []` section.

After the `#TODO` you will write your current port status.

## Cookbook

The GCC/LLVM compiler frontends on Linux will use `glibc` (GNU C Library) by default on linking, it will create Linux ELF binaries that don't work on Redox because `glibc` don't use the Redox syscalls.

To make the compiler use the `relibc` (Redox C Library), the Cookbook system needs to tell the build system of the software to use it, it's done with environment variables.

The Cookbook have templates to avoid custom commands, but it's not always possible because some build systems are customized or not adapted for Cookbook compilation.

(Each build system has different environment variables to enable cross-compilation and pass a custom C library for the compiler)

### Custom Compiler

Cookbook use a custom GCC/LLVM/rustc with Redox patches to compile recipes with `relibc` linking, you can check them [here](https://static.redox-os.org/toolchain/).

### Cross Compilation

Cookbook default behavior is cross-compilation because it brings more flexiblity to the build system, it make the compiler use `relibc` or compile to a different processor architecture.

By default Cookbook respect the architecture of your host system but you can change it easily on your `.config` file (`ARCH?=` field).

(We recommend that you don't set the processor architecture inside the `recipe.toml` script field, because you lost flexibility, can't merge the recipe for CI server and could forget this custom setting)

### Templates

The template is the type of the program/library build system, programs using an Autotools build system will have a `configure` file on the root of the repository/tarball source, programs using CMake build system will have a `CMakeLists.txt` file with all available CMake flags and a `cmake` folder, programs using Meson build system will have a `meson.build` file, Rust programs will have a `Cargo.toml` file.

- `template = "cargo"` - compile with `cargo` (Rust programs, you can't use the `script =` field).
- `template = "configure"` - compile with `configure` and `make` (you can't use the `script =` field).
- `template = "custom"` - run your custom `script =` field and compile (Any build system/installation process).

The `script =` field runs any shell command, it's useful if the software use a script to build from source or need custom options that Cookbook don't support.

To find the supported Cookbook shell commands, look the recipes using a `script =` field on their `recipe.toml` or read the [source code](https://gitlab.redox-os.org/redox-os/cookbook/-/tree/master/src).

- [Recipes](https://gitlab.redox-os.org/redox-os/cookbook/-/tree/master/recipes)

### Custom Template

The "custom" template enable the `script =` field to be used, this field will run any command supported by your shell.

#### Cargo script template

```toml
script = """
COOKBOOK_CARGO="${COOKBOOK_REDOXER}"
COOKBOOK_CARGO_FLAGS=(
    --path "${COOKBOOK_SOURCE}"
    --root "${COOKBOOK_STAGE}"
    --locked
    --no-track
)
function cookbook_cargo {
    "${COOKBOOK_CARGO}" install "${COOKBOOK_CARGO_FLAGS[@]}"
}
"""
```

#### Configure script template

```toml
script = """
COOKBOOK_CONFIGURE="${COOKBOOK_SOURCE}/configure"
COOKBOOK_CONFIGURE_FLAGS=(
    --host="${TARGET}"
    --prefix=""
    --disable-shared
    --enable-static
)
COOKBOOK_MAKE="make"
COOKBOOK_MAKE_JOBS="$(nproc)"
function cookbook_configure {
    "${COOKBOOK_CONFIGURE}" "${COOKBOOK_CONFIGURE_FLAGS[@]}"
    "${COOKBOOK_MAKE}" -j "${COOKBOOK_MAKE_JOBS}"
    "${COOKBOOK_MAKE}" install DESTDIR="${COOKBOOK_STAGE}"
}
"""
```

#### CMake script template

```toml
script = """
COOKBOOK_CONFIGURE="cmake"
COOKBOOK_CONFIGURE_FLAGS=(
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_CROSSCOMPILING=True
    -DCMAKE_EXE_LINKER_FLAGS="-static"
    -DCMAKE_INSTALL_PREFIX="/"
    -DCMAKE_PREFIX_PATH="${COOKBOOK_SYSROOT}"
    -DCMAKE_SYSTEM_NAME=Generic
    -DCMAKE_SYSTEM_PROCESSOR="$(echo "${TARGET}" | cut -d - -f1)"
    -DCMAKE_VERBOSE_MAKEFILE=On
"${COOKBOOK_SOURCE}"
)
cookbook_configure
"""
```

More CMake options can be added with a `-D` before them, the customization of CMake compilation is very easy.

#### Cargo packages script template

```toml
script = """
cookbook_cargo_packages program-name
"""
```

(you can use `cookbook_cargo_packages program1 program2` if it's more than one package)

This script is used for Rust programs that use folders inside the repository for compilation, you can use the folder name or program name.

This will fix the "found virtual manifest instead of package manifest" error.

#### Cargo flags script template

```toml
script = """
cookbook_cargo --features flag-name
"""
```

(you can use `cookbook_cargo --features flag1 flag2` if it's more than one flag)

Some Rust softwares have Cargo flags for customization, search them to match your needs or make some program compile.

#### Disable the default Cargo flags

It's common that some flag of the program doesn't work on Redox, if you don't want to spend much time testing flags that work and don't work, you can disable all of them to see if the most basic setting of the program works with this script:

```toml
script = """
cookbook_cargo --no-default-features
"""
```

#### Enable all Cargo flags

If you want to enable all flags of the program, use:

```toml
script = """
cookbook_cargo --all-features
"""
```

#### Cargo examples script template

```toml
script = """
cookbook_cargo_examples example-name
"""
```

(you can use `cookbook_cargo_examples example1 example2` if it's more than one example)

This script is used for examples on Rust programs.

#### Add the Cookbook "bin" folder to the PATH

```toml
export PATH="${COOKBOOK_ROOT}/bin:${PATH}"
```

#### Insert Cargo build artifacts in the build directory

```toml
export CARGO_TARGET_DIR="${COOKBOOK_BUILD}/target"
```

#### Add the "sysroot" includes for most C compilation

```toml
#TODO: check paths for spaces!
export CFLAGS="-I${COOKBOOK_SYSROOT}/include"
export CPPFLAGS="-I${COOKBOOK_SYSROOT}/include"
```

#### Add the "sysroot" libraries and build binaries statically for most C compilation

```toml
#TODO: check paths for spaces!
export LDFLAGS="-L${COOKBOOK_SYSROOT}/lib --static"
```

#### Ensure that pkg-config gets the right flags from the "sysroot"

```toml
export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_PATH=
export PKG_CONFIG_LIBDIR="${COOKBOOK_SYSROOT}/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="${COOKBOOK_SYSROOT}"
```

#### Strip binaries

```toml
if [ -d "${COOKBOOK_STAGE}/bin" ]
then
    find "${COOKBOOK_STAGE}/bin" -type f -exec "${TARGET}-strip" -v {} ';'
fi
```

#### Remove libtool files

```toml
if [ -d "${COOKBOOK_STAGE}/lib" ]
then
    find "${COOKBOOK_STAGE}/lib" -type f -name '*.la' -exec rm -fv {} ';'
fi
```

#### Remove Cargo install files

```toml
for file in .crates.toml .crates2.json
do
    if [ -f "${COOKBOOK_STAGE}/${file}" ]
    then
        rm -v "${COOKBOOK_STAGE}/${file}"
    fi
done
```

## Sources

### Tarballs

Tarballs are the most easy way to compile a software because the build system is already configured, while being more fast to download and process (the computer don't need to process Git deltas, even with GitHub tarballs which are compressed Git repositories).

(In cases where you don't find tarballs, GitHub tarballs will be available on the "Releases" and "Tags" pages with a `tar.gz` name in the download button, copy this link and paste on the `tar =` field of your `recipe.toml`).

If you want an easy way to find programs/libraries, see the Debian testing [packages list](https://packages.debian.org/testing/allpackages).

You can search them with `Ctrl+F`, all package names are clickable and the homepage of them is available on the right side of the package description/details.

The Debian package page covers the build dependencies too, the `depends` are the necessary dependencies, the items `recommends`, `suggests` and `enhances` is to expand the software functionality, not needed to make it work/compile.

Debian packages are the most easy to find programs/libraries because they are the most used by software developers to describe build dependencies.

### Git Repositories

In cases where source/GitHub tarballs aren't available, you can use the commit hash of the latest stable version.

If you are on GitHub they appear as a collapsed code on the "Releases" page or "Tags" page.

(If you want to use the development version of the software, you can just use the Git repository link without a commit hash, but if some commit broke the compilation, you use the last working commit hash on the `rev =` field)

You can look this [example](https://github.com/redox-os/redox/commit/4f8c725f32a434ada132ca3296d31d4bbb75f850), if you see this same commit [here](https://github.com/redox-os/redox/releases/tag/0.5.0), it appears collapsed as "4f8c725" and is clickable.

The first two lines of your `recipe.toml` will looks like this:

```toml
[source]
git = "repository-link.git"
rev = "commit-revision-hash"
```

This same logic applies for every Git frontend and is more easy to find, manage and patch than tarballs.

## Dependencies

Most C/C++/mixed Rust softwares, place build system dependencies together with his own dependencies (development libraries), if you see the "Build Instructions" of most software, you will notice that it have packages without the `-dev` suffix and `-dev` packages (pure Rust programs don't use C/C++ libraries but his crates can use).

The packages with the `-dev` suffix are development libraries (they provide headers), while the packages without this suffix are runtime dependencies or build tools (necessary to configure/run the build process), you will need to test this, feel free to ask us on [Chat](./ch13-01-chat.md).

Mixed Rust programs have crates ending with `-sys` to use C/C++ libraries of the system, sometimes they bundle them.

- The compiler will build the development libraries as `.a` files (static linking) or `.so` files (dynamic linking), the `.a` files will be mixed in the final binary while the `.so` files will be out of the binary (stored on the `/lib` directory of the system).

Install the packages for your Linux distribution on the "Build Instructions" of the software, see if it compiles on your system first (if packages for your distribution is not available, search for Debian/Ubuntu equivalents).

We recommend that you add the `-dev` dependencies first, generally the Linux distribution package web interface place the library official website on package page (you can use the Debian testing [packages list](https://packages.debian.org/testing/allpackages) to search them with `Ctrl+F`, all package names are clickable and the homepage of them is available on the right side of the package description/details), inside the dependency website you will copy the tarball link or Git repository link and paste on your `recipe.toml`, according to TOML syntax (`tar = "link"` or `git = "link"`).

Create a recipe for each dependency and add inside of your main recipe `dependencies = []` section (`"recipe-name",`).

Run `make r.recipe-name` and see if it don't give errors, if it give an error it can be a dependency that require patches or missing runtime/build system dependencies, try to investigate both methods until the software compile successfully.

If you run `make r.recipe-name` and it compile successfully with just `-dev` recipes, feel free to add the packages without the `-dev` suffix on the [bootstrap.sh](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/bootstrap.sh) script or [redox-base-containerfile](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/podman/redox-base-containerfile) for Podman builds.

The `bootstrap.sh` script and `redox-base-containerfile` covers the build system packages needed by the recipes on [demo.toml](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/config/x86_64/demo.toml)

(You need to do this because each software is different, the major reason is "Build Instructions" organization)

All recipes are [statically compiled](https://en.wikipedia.org/wiki/Static_build), thus you don't need to package libraries and applications separated for binary linking, improving security and simplifying the configuration/packaging.

The only exception for static linking would be the LLVM, as it makes the binary very big, thus it will be dynamic.

### Bundled Libraries

Some programs use bundled libraries during the compilation, using CMake or a Python script, the most common case is using CMake (emulators do this in most cases).

The reason for this can be more portability or a patched library with optimizations for a specific task of the program.

In some cases some bundled library needs a Redox patch, if not it will give a compilation error.

Most programs using CMake will try to detect the system libraries on the build environment, if not they will use the bundled libraries.

The "system libraries" on this case is the recipes specified on the `dependencies = []` section of your `recipe.toml`.

If you are using a recipe from the `master` branch as dependency, check if you find a `.patch` file on the recipe folder or if the `recipe.toml` has a `git =` field pointing to the Redox GitLab.

If you find one of these (or if you patched the recipe), you should specify it on the `dependencies = []` section, if not you can use the bundled libraries without problems.

Generally programs with CMake use a `-DUSE_SYSTEM` flag to control this behavior.

## Testing/Building

(Compile on your Linux distribution before this step to see if all build system dependencies and software libraries are correct)

To build your recipe, run:

```sh
make r.recipe-name
```

If the compilation was successful, the recipe will be packaged and don't give errors.

If you want to insert this recipe permanently in your QEMU image add your recipe name below the last item in `[packages]` on your TOML config (`config/x86_64/desktop.toml`, for example).

- Example - `recipe-name = {}` or `recipe-name = "recipe"` (if you have `REPO_BINARY=1` in your `.config`).

To install your compiled recipe on QEMU image, run `make image`.

If you had a problem, use this command to log any possible errors on your terminal output:

```sh
make r.recipe-name 2>&1 | tee recipe-name.log
```

The recipe sources will be extracted/cloned on the `source` folder inside of your recipe folder, the binaries go to `target` folder.

## Update crates

In some cases the `Cargo.lock` of some Rust program can have a version of some crate that don't have Redox patches (old) or broken Redox support (changes on code that make the target OS fail), this will give you an error during the recipe compilation.

The reason of fixed crate versions is explained [here](https://doc.rust-lang.org/cargo/faq.html#why-do-binaries-have-cargolock-in-version-control-but-not-libraries).

To fix this, you will need to update the crates of your recipe after the first compilation of the recipe and build it again, see the ways to do it below.

### One or more crates

Most of the time you just need to update some crates to have Redox support, this will avoid random breaks on the dependency chain of the program (due to ABI changes) thus you can update one or more crates to reduce the chance of breaks.

We recommend that you do this based on the errors you get during the compilation, this method have more chance to make some program work on Redox.

- Go to the `source` folder of your recipe and run `cargo update -p crate-name`, example:

```sh
cd cookbook/recipes/recipe-name/source
cargo update -p crate1 crate2
cd -
make r.recipe-name
```
Or (if you still get the error)

```sh
cd cookbook/recipes/recipe-name/source
cargo update -p crate1 crate2
cd -
make c.recipe-name r.recipe-name
```

### All crates

This method will update all crates of the dependency chain to the latest version, be aware that some crates break the ABI frequently and make the program stop to work, that's why you must try the "One crate" method first.

(Try this method if you want to test the latest improvements on the libraries)

- Go to the `source` folder of your recipe and run `cargo update`, example:

```sh
cd cookbook/recipes/recipe-name/source
cargo update
cd -
make r.recipe-name
```
Or (if you still get the error)

```sh
cd cookbook/recipes/recipe-name/source
cargo update
cd -
make c.recipe-name r.recipe-name
```

### Verify the dependency tree

If you use the above methods but the program is still using old crate versions, see this section:

- [Verify the dependency tree](./ch08-05-troubleshooting.md#verify-the-dependency-tree)

## Patch crates

### Redox forks

It's possible that some not ported crate have a Redox fork with patches, you can search the crate name [here](https://gitlab.redox-os.org/), generally the Redox patches stay in the `redox` branch or `redox-version` branch that follow the crate version.

To use this Redox fork on your Rust program, add this text on the end of the `Cargo.toml` in the program source code:

```toml
[patch.crates-io]
crate-name = { git = "repository-link", branch = "redox" }
```

It will make Cargo replace the patched crate in the entire dependency chain, after that, run:

```sh
make r.recipe-name
```

Or (if the above doesn't work)

```sh
make c.recipe-name r.recipe-name
```

Or

```sh
cd cookbook/recipes/recipe-name/source
cargo update -p crate-name
cd -
make r.recipe-name
```
Or

```sh
cd cookbook/recipes/recipe-name/source
cargo update -p crate-name
cd -
make c.recipe-name r.recipe-name
```

### Local patches

If you want to patch some crate offline with your patches, add this text on the `Cargo.toml` of the program:

```toml
[patch.crates-io]
crate-name = { path = "patched-crate-folder" }
```

It will make Cargo replace the crate based on this folder in the program source code - `cookbook/recipes/your-recipe/source/patched-crate-folder` (you don't need to manually create this folder if you `git clone` the crate source code on the program source directory)

Inside this folder you will apply the patches on the crate source and build the recipe.

## Cleanup

If you have some problems (outdated recipe), try to run these commands:

- This command will wipe your old recipe binary.

```sh
make c.recipe
```

- This script will delete your recipe source/binary and compile (fresh build).

```sh
scripts/rebuild-recipe.sh recipe-name
```

## Search Text on Recipes

To speed up your porting workflow you can use the `grep` tool to search the recipe configuration:

```sh
cd cookbook/recipes
grep -rnw "text" --include "recipe.toml"
```

This command will search all match texts in the `recipe.toml` files of each recipe folder.

## Search for functions on relibc

Sometimes your program is not building because relibc lack the necessary functions, to verify if they are implemented, run these commands:

```sh
cd relibc
grep -nrw "function-name" --include "*.rs"
```

You will insert the function name in `function-name`.

## Create a BLAKE3 hash for your recipe

You need to create a BLAKE3 hash of your recipe tarball if you want to merge it on upstream, for this you can use the `b3sum` tool, it can be installed from `crates.io` with `cargo install b3sum`.

After the first run of the `make r.recipe-name` command, run these commands:

```sh
cd cookbook/recipes/your-recipe-folder/source.tar
b3sum source.tar
```

It will print the generated BLAKE3 hash, copy and paste on the `blake3 =` field of your `recipe.toml`.

## Submitting MRs

If you want to add your recipe on [Cookbook](https://gitlab.redox-os.org/redox-os/cookbook) to become a Redox package on [CI server](https://static.redox-os.org/pkg/), you can submit your merge request with proper dependencies and comments.

We recommend that you make a commit for each new recipe and is preferable that you test it before the MR, but you can send it non-tested with a `#TODO` on the first line of the `recipe.toml` file.

After the `#TODO` comment you will explain what is missing on your recipe (apply a space after the `TODO`, if you forget it the `grep` can't scan properly), that way we can `grep` for `#TODO` and anyone can improve the recipe easily (don't forget the `#` character before the text, the TOML syntax treat every text after this as a comment, not a code).