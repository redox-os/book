# Porting Applications using Recipes

The [Including Programs in Redox](./ch09-01-including-programs.md) page gives an example to port/modify a pure Rust program, here we will explain the advanced way to port Rust programs, mixed Rust programs (Rust + C/C++ libraries, for example) and C/C++ programs.

(Before reading this page you **must** read the [Build System Quick Reference](./ch08-06-build-system-reference.md) and [Coding and Building](./ch09-02-coding-and-building.md) pages)

- [Recipe](#recipe)
    - [Quick Recipe Template](#quick-recipe-template)
    - [Environment Variables](#environment-variables)
- [Cookbook](#cookbook)
    - [Custom Compiler](#custom-compiler)
    - [Cross Compilation](#cross-compilation)
    - [Templates](#templates)
    - [Custom Template](#custom-template)
        - [Cargo script template](#cargo-script-template)
        - [Configure script template](#configure-script-template)
        - [CMake script template](#cmake-script-template)
        - [Cargo packages script template](#cargo-packages-script-template)
            - [Cargo package with flags](#cargo-package-with-flags)
        - [Cargo flags script template](#cargo-flags-script-template)
        - [Disable the default Cargo flags](#disable-the-default-cargo-flags)
        - [Enable all Cargo flags](#enable-all-cargo-flags)
        - [Cargo examples script template](#cargo-examples-script-template)
        - [Script template](#script-template)
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
    - [Environment Variables](#environment-variables-1)
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
- Below `[package]` - runtime dependencies or data files.

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

### Environment Variables

If you want to apply changes on the program source/binary you can use these variables on your commands:

- `${COOKBOOK_SOURCE}` - Represents the `source` folder at `cookbook/recipes/recipe-name/source` (program source).
- `${COOKBOOK_SYSROOT}` - Represents the `sysroot` folder at `cookbook/recipes/recipe-name/target/${TARGET}` (library sources).
- `${COOKBOOK_STAGE}` - Represents the `stage` folder at `cookbook/recipes/recipe-name/target/${TARGET}` (recipe binaries).

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

## Cookbook

The GCC/LLVM compiler frontends on Linux will use `glibc` (GNU C Library) by default on linking, it will create Linux ELF binaries that don't work on Redox because `glibc` don't use the Redox syscalls.

To make the compiler use the `relibc` (Redox C Library), the Cookbook system needs to tell the build system of the software to use it, it's done with environment variables.

The Cookbook have templates to avoid custom commands, but it's not always possible because some build systems are customized or not adapted for Cookbook compilation.

(Each build system has different environment variables to enable cross-compilation and pass a custom C library for the compiler)

### Custom Compiler

Cookbook use a custom GCC/LLVM/rustc with Redox patches to compile recipes with `relibc` linking, you can check them [here](https://static.redox-os.org/toolchain/).

### Cross Compilation

Cookbook default behavior is cross-compilation because it brings more flexiblity to the build system, it make the compiler use `relibc` or compile to a different CPU architecture.

By default Cookbook respect the architecture of your host system but you can change it easily on your `.config` file (`ARCH?=` field).

(We recommend that you don't set the CPU architecture inside the `recipe.toml` script field, because you lost flexibility, can't merge the recipe for CI server and could forget this custom setting)

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

```
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

```
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

```
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

```
script = """
cookbook_cargo_packages program-name
"""
```

(you can use `cookbook_cargo_packages program1 program2` if it's more than one package)

This script is used for Rust programs that use folders inside the repository for compilation, you can use the folder name or program name.

This will fix the "found virtual manifest instead of package manifest" error.

##### Cargo package with flags

If you need a script for a package with flags (customized), you can use this script:

```
script = """
"${COOKBOOK_CARGO}" build \
            --manifest-path "${COOKBOOK_SOURCE}/Cargo.toml" \
            --package "${package-name}" \
            --release
           --add-your-flag-here
        mkdir -pv "${COOKBOOK_STAGE}/bin"
        cp -v \
            "target/${TARGET}/release/${package-name}" \
            "${COOKBOOK_STAGE}/bin/${recipe}_${package-name}"
"""
```

The `--add-your-flag-here` will be replaced by your flag name and the parts with `package-name` will be replaced by the real package.

#### Cargo flags script template

```
script = """
cookbook_cargo --features flag-name
"""
```

(you can use `cookbook_cargo --features flag1 flag2` if it's more than one flag)

Some Rust softwares have Cargo flags for customization, search them to match your needs or make some program compile.

#### Disable the default Cargo flags

It's common that some flag of the program doesn't work on Redox, if you don't want to spend much time testing flags that work and don't work, you can disable all of them to see if the most basic setting of the program works with this script:

```
script = """
cookbook_cargo --no-default-features
"""
```

#### Enable all Cargo flags

If you want to enable all flags of the program, use:

```
script = """
cookbook_cargo --all-features
"""
```

#### Cargo examples script template

```
script = """
cookbook_cargo_examples example-name
"""
```

(you can use `cookbook_cargo_examples example1 example2` if it's more than one example)

This script is used for examples on Rust programs.

#### Script template

If you want to package a script as executable program use this recipe template:

- One script

```toml
script = """
mkdir -pv "${COOKBOOK_STAGE}"/bin
cp "${COOKBOOK_SOURCE}"/script-name.py "${COOKBOOK_STAGE}"/bin/script-name
chmod a+x "${COOKBOOK_STAGE}"/bin/script-name
"""
```

(Rename the "script-name" parts with your script name)

This script will rename your script name (remove the `.py` extension, for example), make it executable and package.

- Multiple scripts

```toml
script = """
mkdir -pv "${COOKBOOK_STAGE}"/bin
for script in "${COOKBOOK_SOURCE}"/*
do
  shortname=`basename "$script" ".py"`
  cp -v "$script" "${COOKBOOK_STAGE}"/bin/"$shortname"
  chmod a+x "${COOKBOOK_STAGE}"/bin/"$shortname"
done
"""
```

This script will rename all scripts to remove the `.py` extension, mark all scripts as executable and package.

- Shebang

It's the magic behind executable scripts as it make the system interpret the script as an ELF binary, if your script doesn't have a shebang on the beginning it can't work as an executable program.

To fix this, use this script:

```toml
script = """
mkdir -pv "${COOKBOOK_STAGE}"/bin
cp "${COOKBOOK_SOURCE}"/script-name.py "${COOKBOOK_STAGE}"/bin/script-name
sed -i '1 i\#!/usr/bin/env python3' "${COOKBOOK_STAGE}"/bin/script-name
chmod a+x "${COOKBOOK_STAGE}"/bin/script-name
"""
```

The `sed -i '1 i\#!/usr/bin/env python3' "${COOKBOOK_STAGE}"/bin/script-name` command will add the shebang on the beginning of your script.

The `python3` is the script interpreter in this case, use `bash` or `lua` or whatever interpreter is appropriate for your case..

There are many combinations for these script templates, you can download scripts without the `[source]` section, make customized installations, etc.

#### Add the Cookbook "bin" folder to the PATH

```
export PATH="${COOKBOOK_ROOT}/bin:${PATH}"
```

#### Insert Cargo build artifacts in the build directory

```
export CARGO_TARGET_DIR="${COOKBOOK_BUILD}/target"
```

#### Add the "sysroot" includes for most C compilation

```
#TODO: check paths for spaces!
export CFLAGS="-I${COOKBOOK_SYSROOT}/include"
export CPPFLAGS="-I${COOKBOOK_SYSROOT}/include"
```

#### Add the "sysroot" libraries and build binaries statically for most C compilation

```
#TODO: check paths for spaces!
export LDFLAGS="-L${COOKBOOK_SYSROOT}/lib --static"
```

#### Ensure that pkg-config gets the right flags from the "sysroot"

```
export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_PATH=
export PKG_CONFIG_LIBDIR="${COOKBOOK_SYSROOT}/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="${COOKBOOK_SYSROOT}"
```

#### Strip binaries

```
if [ -d "${COOKBOOK_STAGE}/bin" ]
then
    find "${COOKBOOK_STAGE}/bin" -type f -exec "${TARGET}-strip" -v {} ';'
fi
```

#### Remove libtool files

```
if [ -d "${COOKBOOK_STAGE}/lib" ]
then
    find "${COOKBOOK_STAGE}/lib" -type f -name '*.la' -exec rm -fv {} ';'
fi
```

#### Remove Cargo install files

```
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

Tarballs are the most easy way to compile a software because the build system is already configured (GNU Autotools is the most used), while being more fast to download and process (the computer don't need to process Git deltas present in Git repositories).

Archives with `tar.xz` and `tar.bz2` tend to have higher compression level, thus smaller file size.

(In cases where you don't find tarballs, GitHub tarballs will be available on the "Releases" and "Tags" pages with a `tar.gz` name in the download button, copy this link and paste on the `tar =` field of your `recipe.toml`).

Your `recipe.toml` will have this content:

```toml
[source]
tar = "tarball-link"
```

### Git Repositories

Some programs don't offer tarballs or make releases, thus you need to use the their Git repository.

Your `recipe.toml` will have this content:

```toml
[source]
git = "repository-link.git"
```

## Dependencies

Most C, C++ and mixed Rust softwares place build system tools (packages without the `-dev` suffix) together with development libraries (packages with `-dev` suffix) in their "Build Instructions".

Example:

```sh
sudo apt-get install cmake libssl-dev
```

The `cmake` package is the build system while the `libssl-dev` package is the linker objects (`.a` and `.so` files) of OpenSSL.

The Debian package system bundle dynamic/static objects on their `-dev` packages (other Linux distributions just bundle dynamic objects), while Redox will use the source code of the libraries, both the Debian package and the library tarball offer headers, thus they can used with linker objects and source code.

(Don't use the `.deb` packages to create recipes, they are adapted for the Debian environment)

You would need to create a recipe of the `libssl-dev` and add on your `recipe.toml`, while the `cmake` package would need to be installed on your system.

Sometimes the command have runtime packages that will need recipes, most of them will be added below the `[build]` to keep the "static linking" policy, while some doesn't make sense to add on this section or are too large and would make the binary bigger, you can opt to not add them on your `recipe.toml` (the user will need to manually install the runtime before on Redox) or add it below the `[package]` section (it will install the runtime during the package installation).

(Pure Rust programs don't use C/C++ libraries but its crates can use).

Mixed Rust programs have crates ending with `-sys` to use C/C++ libraries of the system, sometimes they bundle them.

If you have questions about this feel free to ask us on [Chat](./ch13-01-chat.md).

If you want an easy way to find programs/libraries, see the Debian testing [packages list](https://packages.debian.org/testing/allpackages).

You can search them with `Ctrl+F`, all package names are clickable and the homepage of them is available on the right-side of the package description/details.

The package page also covers the build dependencies, the `depends` are the necessary dependencies, the items `recommends`, `suggests` and `enhances` is to expand the software functionality, not needed to make it work.

- Debian packages are the most easy to find programs/libraries because they are the most used by software developers to describe build dependencies.

- The compiler will build the development libraries as `.a` files (static linking) or `.so` files (dynamic linking), the `.a` files will be mixed in the final binary while the `.so` files will be out of the binary (stored on the `/lib` directory of the system).

(Linux distributions add a number after the `.so` files to avoid conflicts on the `/lib` folder when packages use different versions of the same library, for example: `library-name.so.6`)

- Install the packages for your Linux distribution on the "Build Instructions" of the software, see if it compiles on your system first (if packages for your distribution is not available, search for Debian/Ubuntu equivalents).

Run `make r.recipe-name` and see if it don't give errors, if you get an error it can be a dependency that require patches or missing runtime/build system tools, try to investigate both methods until the recipe finish the build process successfully.

If you run `make r.recipe-name` and it builds successfully with just `-dev` recipes, feel free to add the packages without the `-dev` suffix on the [bootstrap.sh](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/bootstrap.sh) script or [redox-base-containerfile](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/podman/redox-base-containerfile) for Podman builds.

The `bootstrap.sh` script and `redox-base-containerfile` covers the build system packages needed by the recipes on [demo.toml](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/config/x86_64/demo.toml)

(You need to do this because each software is different, the major reason is "Build Instructions" organization)

All recipes needs to be [statically compiled](https://en.wikipedia.org/wiki/Static_build), thus you don't need to package development libraries or runtimes separated for binary linking, improving security and simplifying the configuration/packaging.

The only exception for static linking would be the LLVM because it makes the binary size very big, thus it will be dynamic linked.

### Bundled Libraries

Some programs have bundled libraries, using CMake or a Python script, the most common case is using CMake (emulators do this in most cases).

The reason for this can be more portability or a patched library with optimizations for a specific task of the program.

In some cases some bundled library needs a Redox patch, if not it will give a compilation error.

Most programs using CMake will try to detect the system libraries on the build environment, if not they will use the bundled libraries.

The "system libraries" on this case is the recipes specified on the `dependencies = []` section of your `recipe.toml`.

If you are using a recipe from the `master` branch as dependency, check if you find a `.patch` file on the recipe folder or if the `recipe.toml` has a `git =` field pointing to the Redox GitLab.

If you find one of these (or if you patched the recipe), you should specify it on the `dependencies = []` section, if not you can use the bundled libraries without problems.

Generally programs with CMake use a `-DUSE_SYSTEM` flag to control this behavior.

### Environment Variables

Sometimes specify the library recipe on the `dependencies = []` section is not enough, some build systems have environment variables to receive a custom path for external libraries.

When you add a library on your `recipe.toml` the Cookbook will copy the library source code to the `sysroot` folder at `cookbook/recipes/recipe-name/target/${TARGET}`, this folder has an environment variable that can be used inside the `script =` field on your `recipe.toml`.

Example:

```toml
script = """
export OPENSSL_DIR="${COOKBOOK_SYSROOT}"
cookbook_cargo
"""

The `export` will active the `OPENSSL_DIR` variable on the environment, this variable is implemented by the program, it's a way to specify the custom OpenSSL path to the program's build system, as you can see, when the `òpenssl` recipe is added to the `dependencies = []` section its sources go to the `sysroot` folder.

Now the program build system is satisfied with the OpenSSL sources, the `cookbook_cargo` function calls Cargo to build it.

Programs using CMake don't use environment variables but a option, see this example:

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
    -DOPENSSL_ROOT_DIR="${COOKBOOK_SYSROOT}"
"${COOKBOOK_SOURCE}"
)
cookbook_configure
"""
```

On this example the `-DOPENSSL_ROOT_DIR` option will have the custom OpenSSL path.

## Testing/Building

(Build on your Linux distribution before this step to see if all build system tools and development libraries are correct)

To build your recipe, run:

```sh
make r.recipe-name
```

If the build process was successful the recipe will be packaged and don't give errors.

If you want to insert this recipe permanently in your QEMU image, add your recipe name below the last item in `[packages]` on your TOML config (`config/x86_64/your-config.toml`, for example).

- Example - `recipe-name = {}` or `recipe-name = "recipe"` (if you have `REPO_BINARY=1` in your `.config`).

To install your compiled recipe on QEMU image, run `make image`.

If you had a problem, use this command to log any possible errors on your terminal output:

```sh
make r.recipe-name 2>&1 | tee recipe-name.log
```

The recipe sources will be extracted/cloned on the `source` folder inside of your recipe folder, the binaries go to `target` folder.

## Update crates

Sometimes the `Cargo.lock` of some Rust programs can hold a crate version without Redox patches or broken Redox support (changes on code that make the target OS fail), this will give you an error during the recipe compilation.

The reason of fixed crate versions is explained [here](https://doc.rust-lang.org/cargo/faq.html#why-do-binaries-have-cargolock-in-version-control-but-not-libraries).

To fix this you will need to update the crates of your recipe after the first compilation and build it again, see the ways to do it below.

### One or more crates

In maintained Rust programs you just need to update some crates to have Redox support (because they frequently update the crate versions), this will avoid random breaks on the dependency chain of the program (due to ABI changes) thus you can update one or more crates to reduce the chance of breaks.

We recommend that you do this based on the errors you get during the compilation, this method is recommended for maintained programs.

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

Most unmaintained Rust programs have very old crate versions without up-to-date Redox support, this method will update all crates of the dependency chain to the latest version.

Be aware that some crates break the ABI frequently and make the program stop to work, that's why you must try the "One crate" method first.

(Also good to test the latest improvements of the libraries)

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

- This command will wipe your old recipe binary/source.

```sh
make c.recipe-name u.recipe-name
```

- This script will delete your recipe binary/source and build (fresh build).

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