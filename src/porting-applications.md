# Porting Applications using Recipes

The [Including Programs in Redox](./ch09-01-including-programs.md) page gives an example to port/modify a pure Rust program, here we will explain the advanced way to port Rust programs, mixed Rust programs (Rust and C/C++ libraries, for example) and C/C++ programs.

(Before reading this page you must read the [Build System Quick Reference](./ch08-06-build-system-reference.md) page)

- [Recipe](#recipe)
    - [Recipe Configuration Example](#recipe-configuration-example)
    - [Quick Recipe Template](#quick-recipe-template)
- [Cookbook](#cookbook)
    - [Cross Compiler](#cross-compiler)
    - [Cross Compilation](#cross-compilation)
    - [Environment Variables](#environment-variables)
        - [Quick Template](#quick-template)
    - [Templates](#templates)
        - [Functions](#functions)
        - [cookbook_cargo function script](#cookbook_cargo-function-script)
        - [cookbook_configure function script](#cookbook_configure-function-script)
    - [Custom Template](#custom-template)
        - [Packaging Behavior](#packaging-behavior)
        - [Cargo script example](#cargo-script-example)
        - [GNU Autotools script example](#gnu-autotools-script-example)
        - [GNU Autotools script example (lacking a pre-configured tarball)](#gnu-autotools-script-example-lacking-a-pre-configured-tarball)
        - [CMake script example](#cmake-script-example)
        - [Analyze the source code of a Rust program](#analyze-the-source-code-of-a-rust-program)
        - [Cargo packages command example](#cargo-packages-command-example)
            - [Cargo package with flags](#cargo-package-with-flags)
        - [Cargo bins script example](#cargo-bins-script-example)
        - [Cargo flags command example](#cargo-flags-command-example)
        - [Disable the default Cargo flags](#disable-the-default-cargo-flags)
        - [Enable all Cargo flags](#enable-all-cargo-flags)
        - [Cargo examples command example](#cargo-examples-command-example)
        - [Rename binaries](#rename-binaries)
        - [Change the active source code folder](#change-the-active-source-code-folder)
        - [Configuration files](#configuration-files)
        - [Script-based programs](#script-based-programs)
            - [Adapted scripts](#adapted-scripts)
            - [Non-adapted scripts](#non-adapted-scripts)
- [Sources](#sources)
    - [Tarballs](#tarballs)
        - [Build System](#build-system)
        - [Links](#links)
    - [Git Repositories](#git-repositories)
        - [GitHub release commit hash](#github-release-commit-hash)
        - [GitLab release commit hash](#gitlab-release-commit-hash)
- [Dependencies](#dependencies)
    - [Bundled Libraries](#bundled-libraries)
    - [Submodules](#submodules)
    - [Environment Variables](#environment-variables-1)
    - [Configuration](#configuration)
        - [Arch Linux and AUR](#arch-linux-and-aur)
        - [Gentoo](#gentoo)
        - [FreeBSD](#freebsd)
    - [Testing](#testing)
- [Building/Testing The Program](#buildingtesting-the-program)
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
- [Verify the size of your package](#verify-the-size-of-your-package)
- [Submitting MRs](#submitting-mrs)

## Recipe

A recipe is how we call a software port on Redox, this section will explain the recipe configuration and things to consider.

Create a folder at `cookbook/recipes/program-category` with a file named as `recipe.toml` inside, we will edit this file to fit the program needs.

- Commands example:

```sh
cd ~/tryredox/redox
```

```sh
mkdir cookbook/recipes/program-category/program-name
```

```sh
nano cookbook/recipes/program-category/program-name/recipe.toml
```

### Recipe Configuration Example

The recipe configuration (`recipe.toml`) example below contain all supported recipe options. Adapt for your script, program, library or data files.

```toml
[source]
git = "repository-link"
upstream = "repository-link"
branch = "branch-name"
rev = "commit-hash"
tar = "tarball-link.tar.gz"
blake3 = "source-hash"
patches = [
    "patch1.patch",
    "patch2.patch",
]
same_as = "../program-name"
[build]
template = "build-system"
dependencies = [
    "static-library1",
    "static-library2",
]
script = """
insert your script here
"""
[package]
dependencies = [
    "runtime-dependency1",
    "runtime-dependency2",
]
```

- `[source]` - Section for data types that manage the program source (only remove it if you have a `source` folder)
- `git = "repository-link"` - Insert the Git repository of the program (can be removed if a Git repository is not used), you can comment out it to not allow Cookbook to force a `git pull` or change the active branch to `master` or `main`
- `upstream = "repository-link"` - If you are using a fork of the program source with patches add the program upstream source here (can be removed if the upstream source is being used on the `git` data type)
- `branch = "branch-name"` - Insert the program version or patched branch (can be removed if the `master` or `main` branch is being used)
- `rev = "commit-hash"` - Insert the commit hash of the latest stable version of the program (can be removed if a stable version is not used)
- `tar = "tarball-link.tar.gz"` - Insert the program source tarball (can be removed if a tarball is not used)
- `blake3 = "source-hash"` - Insert the program source tarball BLAKE3 hash, can be generated using the `b3sum` tool, install with the `cargo install b3sum` command (can be removed if using a Git repository or under porting)
- `patches = []` - Data type to load `patch` files (can be removed if patch files aren't used)
- `"patch1.patch",` (Under the `patches` data type) - The patch file name (can be removed if the `patches` data type above is not present)
- `same_as = "../program-name"` - Insert the folder of other recipe to make a symbolic link to the `source` folder of other recipe, useful if you want modularity with synchronization
- `[build]` - Section for data types that manage the program build process (don't remove it)
- `template = "build-system"` - Insert the program build system (`cargo` for Rust programs, `configure` for programs using GNU Autotools and `custom` for advanced porting with custom commands)
- `dependencies = []` (Under the `[build]` section) - Data type to load the library dependencies for static linking, don't static link if the library is too big
- `"static-library1",` - The statically-linked library name (can be removed if the `dependencies` data type above is not present)
- `script` - Data type to load the custom commands for packaging
- `[package]` - Section for data types that manage the program package
- `dependencies = []` (Under the `[package]` section) - Data type to load the dynamically-linked libraries or "data files" recipes to be installed by the package manager
- `"runtime-dependency1",` - The name of the dynamically-linked library or data recipe (can be removed if the `dependencies` data type above is not present)

### Quick Recipe Template

This is a recipe template for a quick porting workflow.

```toml
#TODO not compiled or tested
[source]
git = "repository-link"
rev = "commit-hash"
tar = "tarball-link"
[build]
template = "build-system"
dependencies = [
    "library1",
]
```

You can quickly copy and paste this template on each `recipe.toml`, that way you spent less time writting and has less chances for typos.

- If your program use a tarball, you can quickly remove the `git` and `rev` data types.
- If your program use a Git repository, you can quickly remove the `tar` data type.
- If you don't need to pin a commit hash for the most recent stable release, you can quickly remove the `rev` data type.
- If the program don't need dependencies, you can quickly remove the `dependencies = []` section.

After the `#TODO` you will write your current porting status.

## Cookbook

The GCC and LLVM compiler frontends on Linux use `glibc` (GNU C Library) by default on the library object linking process, it will create ELF binaries that don't work on Redox because `glibc` doesn't support the Redox system calls.

To make the compiler use `relibc` (Redox C Library), the Cookbook needs to tell the build system of the program or library to use it, it's done with environment variables.

The Cookbook have templates to avoid custom commands for cross-compilation, but it's not always possible because some build systems aren't adapted for cross-compilation.

(Some build systems have different methods to enable cross-compilation and pass a different C standard library to the compiler, you will need to figure this out)

### Cross Compiler

Cookbook use Rust/GCC forks to do cross-compilation of recipes (programs) with `relibc` to any supported CPU architecture, you can check our cross-compilers [here](https://static.redox-os.org/toolchain/).

### Cross Compilation

The Cookbook default behavior is cross-compilation because it brings more flexiblity to the Redox build system, as it allow recipes to use `relibc` or build to a different CPU architecture.

By default Cookbook respect the architecture of your host system but you can change it easily on your `.config` file (`ARCH?=` field).

- Don't use a CPU architecture on the `script` data type of your `recipe.toml`, it breaks cross-compilation.
- All recipes must use our cross-compilers, a Cookbook [template](#templates) does this automatically but it's not always possible, study the build system of your program/library to find these options or patch the configuration files.

### Environment Variables

If you want to apply changes on the program source/binary you can use these variables on your commands:

- `${COOKBOOK_RECIPE}` - Represents the recipe folder.
- `${COOKBOOK_SOURCE}` - Represents the `source` folder at `recipe-name/source` (program source).
- `${COOKBOOK_SYSROOT}` - Represents the `sysroot` folder at `recipe-name/target/your-cpu-arch/sysroot` (library sources).
- `${COOKBOOK_BUILD}` - Represents the `build` folder at `recipe-name/target/your-cpu-arch/build` (recipe build system).
- `${COOKBOOK_STAGE}` - Represents the `stage` folder at `recipe-name/target/your-cpu-arch/stage` (recipe binaries).

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

#### Quick Template

You can quickly copy these environment variables from this section.

```
"${COOKBOOK_SOURCE}/"
```

```
"${COOKBOOK_BUILD}/"
```

```
"${COOKBOOK_SYSROOT}/"
```

```
"${COOKBOOK_STAGE}/"
```

### Templates

The template is the build system of the program or library, programs using an GNU Autotools build system will have a `configure` file on the root of the source tarball, programs using CMake build system will have a `CMakeLists.txt` file with all available CMake flags and a `cmake` folder, programs using Meson build system will have a `meson.build` file, Rust programs will have a `Cargo.toml` file, etc.

- `template = "cargo"` - Build with Cargo and cross-compilation variables (Rust programs with one package in the Cargo workspace, you can't use the `script =` field).
- `template = "configure"` - Build with GNU Autotools and cross-compilation variables (you can't use the `script =` field).
- `template = "custom"` - Run your commands on the `script =` field and build (Any build system or installation process).

The `script =` field runs any terminal command, it's important if the build system of the program don't support cross-compilation or need custom options that Cookbook don't support.

To find the supported Cookbook terminal commands, look the recipes using a `script =` field on their `recipe.toml` or read the [source code](https://gitlab.redox-os.org/redox-os/cookbook/-/tree/master/src).

- [Recipes](https://gitlab.redox-os.org/redox-os/cookbook/-/tree/master/recipes)

#### Functions

Each template has a function in the Cookbook source code, these functions contain commands to trigger the build system with cross-compilation variables for the Redox triple.

- `cargo` (cookbook_cargo) - This function run `cargo build`
- `configure` (cookbook_configure) - This function run `./configure`, `make` and `make install`

#### cookbook_cargo function script

You can see the commands of the `cookbook_cargo` function below:

- Pre-script

```sh
# Common pre script
# Add cookbook bins to path
export PATH="${COOKBOOK_ROOT}/bin:${PATH}"

# This puts cargo build artifacts in the build directory
export CARGO_TARGET_DIR="${COOKBOOK_BUILD}/target"

# This adds the sysroot includes for most C compilation
#TODO: check paths for spaces!
export CFLAGS="-I${COOKBOOK_SYSROOT}/include"
export CPPFLAGS="-I${COOKBOOK_SYSROOT}/include"

# This adds the sysroot libraries and compiles binaries statically for most C compilation
#TODO: check paths for spaces!
export LDFLAGS="-L${COOKBOOK_SYSROOT}/lib --static"

# These ensure that pkg-config gets the right flags from the sysroot
export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_PATH=
export PKG_CONFIG_LIBDIR="${COOKBOOK_SYSROOT}/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="${COOKBOOK_SYSROOT}"

# cargo template
COOKBOOK_CARGO="${COOKBOOK_REDOXER}"
function cookbook_cargo {
    "${COOKBOOK_CARGO}" install \
        --path "${COOKBOOK_SOURCE}" \
        --root "${COOKBOOK_STAGE}" \
        --locked \
        --no-track \
        "$@"
}

# helper for installing binaries that are cargo examples
function cookbook_cargo_examples {
    recipe="$(basename "${COOKBOOK_RECIPE}")"
    for example in "$@"
    do
        "${COOKBOOK_CARGO}" build \
            --manifest-path "${COOKBOOK_SOURCE}/Cargo.toml" \
            --example "${example}" \
            --release
        mkdir -pv "${COOKBOOK_STAGE}/usr/bin"
        cp -v \
            "target/${TARGET}/release/examples/${example}" \
            "${COOKBOOK_STAGE}/usr/bin/${recipe}_${example}"
    done
}

# helper for installing binaries that are cargo packages
function cookbook_cargo_packages {
    recipe="$(basename "${COOKBOOK_RECIPE}")"
    for package in "$@"
    do
        "${COOKBOOK_CARGO}" build \
            --manifest-path "${COOKBOOK_SOURCE}/Cargo.toml" \
            --package "${package}" \
            --release
        mkdir -pv "${COOKBOOK_STAGE}/usr/bin"
        cp -v \
            "target/${TARGET}/release/${package}" \
            "${COOKBOOK_STAGE}/usr/bin/${recipe}_${package}"
    done
}
```

- Post-script

```sh
# Common post script
# Strip binaries
if [ -d "${COOKBOOK_STAGE}/usr/bin" ]
then
    find "${COOKBOOK_STAGE}/usr/bin" -type f -exec "${TARGET}-strip" -v {} ';'
fi

# Remove cargo install files
for file in .crates.toml .crates2.json
do
    if [ -f "${COOKBOOK_STAGE}/${file}" ]
    then
        rm -v "${COOKBOOK_STAGE}/${file}"
    fi
done
```

#### cookbook_configure function script

You can see the commands of the `cookbook_configure` function below:

- Pre-script

```sh
# Common pre script
# Add cookbook bins to path
export PATH="${COOKBOOK_ROOT}/bin:${PATH}"

# This adds the sysroot includes for most C compilation
#TODO: check paths for spaces!
export CFLAGS="-I${COOKBOOK_SYSROOT}/include"
export CPPFLAGS="-I${COOKBOOK_SYSROOT}/include"

# This adds the sysroot libraries and compiles binaries statically for most C compilation
#TODO: check paths for spaces!
export LDFLAGS="-L${COOKBOOK_SYSROOT}/lib --static"

# These ensure that pkg-config gets the right flags from the sysroot
export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_PATH=
export PKG_CONFIG_LIBDIR="${COOKBOOK_SYSROOT}/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="${COOKBOOK_SYSROOT}"

# configure template
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
```

- Post-script

```sh
# Common post script
# Strip binaries
if [ -d "${COOKBOOK_STAGE}/usr/bin" ]
then
    find "${COOKBOOK_STAGE}/usr/bin" -type f -exec "${TARGET}-strip" -v {} ';'
fi

# Remove libtool files
if [ -d "${COOKBOOK_STAGE}/usr/lib" ]
then
    find "${COOKBOOK_STAGE}/usr/lib" -type f -name '*.la' -exec rm -fv {} ';'
fi
```

### Custom Template

The `custom` template enable the `script =` field to be used, this field will run any command supported by the [GNU Bash](https://www.gnu.org/software/bash/) shell.

The script section start at the location of the `${COOKBOOK_BUILD}` environment variable (`recipe-name/target/your-cpu/build`)

- Script example

```toml
script = """
first-command
second-command
"""

#### Packaging Behavior

The Cookbook download the recipe sources on the `source` folder (`recipe-name/source`), copy the contents of this folder to the `build` folder (`recipe-name/target/your-cpu-arch/build`), build the sources and move the binaries to the `stage` folder (`recipe-name/target/your-cpu-arch/stage`).

If your recipe has library dependencies, it will copy the library sources to the `sysroot` folder to be used by the `build` folder.

- Moving the program files to the Redox filesystem

The `"${COOKBOOK_STAGE}"/` path is used to specify where the recipe files will go inside of Redox, in most cases `/usr/bin` and `/usr/lib`.

You can see path examples for most customized recipes below:

```sh
"${COOKBOOK_STAGE}"/ # The root of the Redox build system
"${COOKBOOK_STAGE}"/usr/bin # The folder where all global Unix executables go
"${COOKBOOK_STAGE}"/usr/lib # The folder where all static and shared library objects go
```

#### Cargo script example

Use this script if you need to customize the `cookbook_cargo` function.

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

#### GNU Autotools script example

Use this script if the program or library need flags, change or copy and paste the "--program-flag" according to your needs.

(Some programs and libraries need more configuration to work)

```toml
script = """
COOKBOOK_CONFIGURE_FLAGS+=(
    --program-flag
)
cookbook_configure
"""
```

#### GNU Autotools script example (lacking a pre-configured tarball)

If you are using the repository of the program you will need to create a configuration file for GNU Autotools.

(Some programs and libraries need more configuration to work)

```toml
script = """
./autogen.sh
cookbook_configure
"""
```

#### CMake script example

Use this script for programs using the CMake build system, more CMake options can be added with a `-D` before them, the customization of CMake compilation is very easy.

(Some programs and libraries need more configuration to work)

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

#### Analyze the source code of a Rust program

Rust programs and libraries use the `Cargo.toml` configuration file to configure the build system and source code.

While packaging Rust programs you need to know where the main executable is located in the Cargo project, to do this you need to verify the `Cargo.toml` files of the project.

A Rust program can have one or more Cargo packages to build, see some common assumptions below:

- Most Rust programs with a `src` folder use one Cargo package, thus you can use the `cargo` template.
- Most Rust programs with multiple Cargo packages name the main package with the name of the program.

Beyond these common source code organization, there are special cases.

- In some Rust programs the `Cargo.toml` file contains one of these data types:

```toml
[[bin]]
name = "executable-name"
[[lib]]
name = "library-object-name"
```

The `[[bin]]` is what you need, the program executable is built by this Cargo package.

(Ignore packages with the `[[lib]]` data type, Rust libraries don't need to be packaged because Rust does static compilation, except for backup purposes)

But some programs don't have the `[[bin]]` and `[[lib]]` data types, for these cases you need to see the source code files, in most cases at the `src` folder.

- The file named `main.rs` contains the program executable code.
- The file named `lib.rs` contains the library object code (ignore it).

#### Cargo packages command example

This command is used for Rust programs that use folders inside the repository for compilation, you can use the folder name or program name.

Sometimes the folder name and program name doesn't work, it happens because the `Cargo.toml` of the package carry a different name, open the file and verify the true name on the `name` field below the `[package]` section.

(This will fix the "found virtual manifest instead of package manifest" error)

```toml
script = """
cookbook_cargo_packages program-name
"""
```

(You can use `cookbook_cargo_packages program1 program2` if it's more than one package)

##### Cargo package with flags

If you need a script for a package with flags (customization), you can use this script:

```toml
script = """
package=package-name
"${COOKBOOK_CARGO}" build \
            --manifest-path "${COOKBOOK_SOURCE}/Cargo.toml" \
            --package "${package}" \
            --release
            --add-your-flag-here
        mkdir -pv "${COOKBOOK_STAGE}/usr/bin"
        cp -v \
            "target/${TARGET}/release/${package}" \
            "${COOKBOOK_STAGE}/usr/bin/${package}"
"""
```

- The `package-name` after `package=` is where you will insert the Cargo package name of your program.
- The `--add-your-flag-here` will be replaced by the program flag.

#### Cargo bins script example

Some Rust programs use bins instead of packages to build, to build them you can use this script:

```toml
script = """
binary=bin-name
"${COOKBOOK_CARGO}" build \
            --manifest-path "${COOKBOOK_SOURCE}/Cargo.toml" \
            --bin "${binary}" \
            --release
            --add-your-flag-here
        mkdir -pv "${COOKBOOK_STAGE}/usr/bin"
        cp -v \
            "target/${TARGET}/release/${binary}" \
            "${COOKBOOK_STAGE}/usr/bin/${binary}"
"""
```

- The `bin-name` after `binary=` is where you will insert the Cargo package name of your program.
- The `--add-your-flag-here` will be replaced by the program flags.

#### Cargo flags command example

Some Rust softwares have Cargo flags for customization, search them to match your needs or make some program build.

```toml
script = """
cookbook_cargo --features flag-name
"""
```

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

#### Cargo examples command example

This script is used for examples on Rust programs.

```toml
script = """
cookbook_cargo_examples example-name
"""
```

(You can use `cookbook_cargo_examples example1 example2` if it's more than one example)

#### Rename binaries

Some programs or examples could use generic names for their binaries, thus they could bring file conflicts on the packaging process, to avoid it use this command after the compilation or installation commands:

```sh
mv "${COOKBOOK_STAGE}/usr/bin/binary-name" "${COOKBOOK_STAGE}/usr/bin/new-binary-name"
```

- Duplicated names

Some recipes for Rust programs can duplicate the program name on the binary (`name_name`), you can also use this command to fix these cases.

#### Change the active source code folder

Sometimes a program don't store the source code on the root of the Git repository, but in a subfolder.

For these cases you need to change the directory of the `${COOKBOOK_SOURCE}` environment variable on the beginning of the `script` data type, to do this add the following command on your recipe script:

```sh
COOKBOOK_SOURCE="${COOKBOOK_SOURCE}/subfolder-name"
```

- An example for a Rust program:

```toml
script = """
COOKBOOK_SOURCE="${COOKBOOK_SOURCE}/subfolder-name"
cookbook_cargo
"""
```

#### Configuration Files

Some programs require to setup configuration files from the source code or tarball, to setup them use this recipe template:

```toml
[build]
template = "custom"
script = """
cookbook function or custom build system commands # It's recommended to insert the build system commands before the configuration files command
mkdir -pv "${COOKBOOK_STAGE}"/usr/share # create the /usr/share folder inside the package
cp -rv "${COOKBOOK_SOURCE}"/configuration-file "${COOKBOOK_STAGE}"/usr/share # copy the configuration file from the program source code to the package
"""
```

Edit the script above to your needs.

#### Script-based programs

Use the following scripts to package interpreted programs.

##### Adapted scripts

This script is for scripts adapted to be packaged, they have shebangs and rename the file to remove the script extension.

(Some programs and libraries need more configuration to work)

- One script

```toml
script = """
mkdir -pv "${COOKBOOK_STAGE}"/usr/bin
cp "${COOKBOOK_SOURCE}"/script-name "${COOKBOOK_STAGE}"/usr/bin/script-name
chmod a+x "${COOKBOOK_STAGE}"/usr/bin/script-name
"""
```

This script will move the script from the `source` folder to the `stage` folder and mark it as executable to be packaged.

(Probably you need to mark it as executable, we don't know if all scripts carry executable permission)

- Multiple scripts

```toml
script = """
mkdir -pv "${COOKBOOK_STAGE}"/usr/bin
cp "${COOKBOOK_SOURCE}"/* "${COOKBOOK_STAGE}"/usr/bin
chmod a+x "${COOKBOOK_STAGE}"/usr/bin/*
"""
```

This script will move the scripts from the `source` folder to the `stage` folder and mark them as executable to be packaged.

##### Non-adapted scripts

You need to use these scripts for scripts not adapted for packaging, you need to add shebangs, rename the file to remove the script extension (`.py`) and mark as executable (`chmod a+x`).

(Some programs and libraries need more configuration to work)

- One script

```toml
script = """
mkdir -pv "${COOKBOOK_STAGE}"/usr/bin
cp "${COOKBOOK_SOURCE}"/script-name.py "${COOKBOOK_STAGE}"/usr/bin/script-name
chmod a+x "${COOKBOOK_STAGE}"/usr/bin/script-name
"""
```

(Rename the "script-name" parts with your script name)

This script will rename your script name (remove the `.py` extension, for example), make it executable and package.

- Multiple scripts

```toml
script = """
mkdir -pv "${COOKBOOK_STAGE}"/usr/bin
for script in "${COOKBOOK_SOURCE}"/*
do
  shortname=`basename "$script" ".py"`
  cp -v "$script" "${COOKBOOK_STAGE}"/usr/bin/"$shortname"
  chmod a+x "${COOKBOOK_STAGE}"/usr/bin/"$shortname"
done
"""
```

This script will rename all scripts to remove the `.py` extension, mark all scripts as executable and package.

- Shebang

It's the magic behind executable scripts as it make the system interpret the script as an ELF binary, if your script doesn't have a shebang on the beginning it can't work as an executable program.

To fix this, use this script:

```toml
script = """
mkdir -pv "${COOKBOOK_STAGE}"/usr/bin
cp "${COOKBOOK_SOURCE}"/script-name.py "${COOKBOOK_STAGE}"/usr/bin/script-name
sed -i '1 i\#!/usr/bin/env python3' "${COOKBOOK_STAGE}"/usr/bin/script-name
chmod a+x "${COOKBOOK_STAGE}"/usr/bin/script-name
"""
```

The `sed -i '1 i\#!/usr/bin/env python3' "${COOKBOOK_STAGE}"/usr/bin/script-name` command will add the shebang on the beginning of your script.

The `python3` is the script interpreter in this case, use `bash` or `lua` or whatever interpreter is appropriate for your case..

There are many combinations for these script templates, you can download scripts without the `[source]` section, make customized installations, etc.

## Sources

### Tarballs

Tarballs are the most easy way to compile a software because the build system is already configured (GNU Autotools is the most used), while being more fast to download and process than Git repositories (the computer don't need to process Git deltas).

Your `recipe.toml` will have this content:

```toml
[source]
tar = "tarball-link"
```

Copy the tarball link and paste on the `tarball-link` field.

**Only use official tarballs**, GitHub auto-generate tarballs for each new release or tag of the program, but they [aren't static](https://github.blog/changelog/2023-01-30-git-archive-checksums-may-change/) (break the checksum) and [don't verify the archive integrity](https://github.blog/2023-02-21-update-on-the-future-stability-of-source-code-archives-and-hashes/).

You can find the official tarballs on the release announcement assets with the program name and ending with `tar.gz` or `tar.xz` (their URLs contain "releases" instead of "archive"), while unstable tarballs can be found on the "Source code" buttons (their URLs contain "archive").

- In most cases they are created using the [GNU Tar](https://www.gnu.org/software/tar/) tool.
- Avoid files containing the names "linux" and "x86_64" on GitHub, they are pre-built binaries for some operating system and CPU architecture, not source code.
- Some programs require Git submodules to work, you can't use tarballs if the official tarball don't bundle the Git submodules.
- Archives with `tar.xz` and `tar.bz2` tend to have a higher compression level, thus smaller file size.

#### Build System

In most cases the tarballs use GNU Autotools to build, it's common that the tarball method of compilation is not well documented, causing confusion on new packagers.

To investigate, you can do these things:

- Build with the `configure` template and see if it works (sometimes you need to use some flag or customize)
- Search the Git repository of the program or library for `autogen.sh` and `configure.ac` files, it means that support for GNU Autotools is available, when some tarball is created, it comes with a `configure` file inside, this file doesn't exist on the Git repository and you need to create it by running the `autogen.sh` script.
- Sometimes these files are available but GNU Autotools is deprecated (because it's old), we recommend that you use the supported build system (in most cases CMake or Meson).

#### Links

Sometimes it's hard to find the official tarball of some software, as each project website organization is different.

To help on this process, the [Arch Linux packages](https://archlinux.org/packages/) and [AUR](https://aur.archlinux.org/) are the most easy repositories to find tarball links on the configuration of the packages.

- Arch Linux packages - Search for your program, open the program page, see the "Package Actions" category on the top right position and click on the "Source Files" button, a GitLab page will open, open the `.SRCINFO` and search for the tarball link on the "source" fields of the file.

See [this](https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/blob/main/.SRCINFO?ref_type=heads#L22) example.

- AUR - Search for your program, open the program page, go to the "Sources" section on the end of the package details.

### Git Repositories

Some programs don't offer official tarballs for releases, thus you need to use their Git repository and pin the commit hash of the most recent release.

Your `recipe.toml` will have this content:

```toml
[source]
git = "repository-link"
rev = "commit-hash"
```

#### GitHub release commit hash

Each GitHub release has a commit hash, you will use it to pin the last version of the program to keep code stability.

Open the release item and copy the second code below the version number.

Example:

- Open [this](https://github.com/rust-lang/rust/releases/tag/1.74.0) release announcement.
- The commit hash is `79e9716c980570bfd1f666e3b16ac583f0168962` and was shortened as `79e9716`.

#### GitLab release commit hash

Each GitLab release has a commit hash, you will use it to pin the last version of the program to keep code stability.

Open the "Releases" button and copy the first code on the end of the release announcement.

Example:

- Open [this](https://gitlab.redox-os.org/redox-os/redox/-/releases/0.8.0) release announcement.
- The commit hash is `c8634bd9890afdac4438d1ff99631d600d469264` and was shortened as `c8634bd9`.

## Dependencies

A program dependency can be a library (a program that offer functions to some program), a runtime (a program that satisfy some program when it's executed) or a build tool (a program to build/configure some program).

Most C, C++ and Rust softwares place build tools/runtime together with development libraries (packages with `-dev` suffix) in their "Build Instructions".

Example:

```sh
sudo apt-get install cmake libssl-dev
```

The `cmake` package is the build system while the `libssl-dev` package is the linker objects (`.a` and `.so` files) of OpenSSL.

The Debian package system bundle shared/static objects on their `-dev` packages (other Linux distributions just bundle dynamic objects), while Redox will use the source code of the libraries.

You would need to create a recipe of the `libssl-dev` and add on your `recipe.toml`, while the `cmake` package would need to be installed on your system.

Library dependencies will be added below the `[build]` to keep the "static linking" policy, while some libraries/runtimes doesn't make sense to add on this section because they would make the program binary too big.

Runtimes will be added below the `[package]` section (it will install the runtime during the package installation).

Mixed Rust programs have crates ending with `-sys` to use C/C++ libraries of the system, sometimes they bundle them.

If you have questions about program dependencies, feel free to ask us on [Chat](./ch13-01-chat.md).

If you want an easy way to find dependencies, see the Debian testing [packages list](https://packages.debian.org/testing/allpackages).

You can search them with `Ctrl+F`, all package names are clickable and their homepage is available on the right-side of the package description/details.

- Debian packages are the most easy to find dependencies because they are the most used by software developers to describe "Build Instructions".
- Don't use the `.deb` packages to create recipes, they are adapted for the Debian environment.
- The recipe `PATH` environment variable only read the build tools at `/usr/bin`, it don't read the `/usr/lib` and `/include` folders (this avoid [automagic dependencies](https://wiki.gentoo.org/wiki/Project:Quality_Assurance/Automagic_dependencies)).
- Don't add build tools on recipe dependencies, check the [Debian](https://packages.debian.org/testing/build-essential) and [Arch Linux](https://archlinux.org/packages/core/any/base-devel/) meta-packages for reference.
- The compiler will build the development libraries as `.a` files (objects for static linking) or `.so` files (objects for dynamic linking), the `.a` files will be mixed in the final binary while the `.so` files will be installed out of the binary (stored on the `/lib` directory of the system).
- Linux distributions add a number after the `.so` files to avoid conflicts on the `/usr/lib` folder when packages use different ABI versions of the same library, for example: `library-name.so.6`.
- You need to do this because each software is different, the major reason is "Build Instructions" organization.

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

When you add a library on your `recipe.toml` the Cookbook will copy the library source code to the `sysroot` folder at `cookbook/recipes/your-category/recipe-name/target/your-target`, this folder has an environment variable that can be used inside the `script =` field on your `recipe.toml`.

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

### Submodules

In some programs or libraries you can't use tarballs because they don't carry the necessary Git submodules of the program (most common in GitHub generated tarballs), on these cases you will need to use the Git repository or the commit of the last stable release (Cookbook download the submodules automatically).

To identify if the program use Git submodules, check if it have external folders to other repository (they appear with a commit hash on the right side) or the existence of a `.gitmodules` file.

Follow these steps to use the last stable version of the program when Git submodules are necessary:

- Open the program/library Git repository.
- Check the "Releases" or "Tags" buttons, in most cases the program have a stable release at "Releases".
- In both pages the commit hash of the stable release will be the first item of the announcement below the version number.
- Copy the repository link/release commit and paste on your `recipe.toml`, for example:

```toml
git = "your-repository-link"
rev = "your-release-commit"
```

If the last stable release is years behind, we recommend that you ignore it and use the Git repository to download/build bug fixes sent after this old version, if you are concerned about the program upstream breaking the recipe, you can use the commit of the last successful CI test.

### Configuration

The determine the program dependencies you can use Arch Linux and Gentoo as reference.

- The build instructions of C/C++ programs tend to mix necessary and optional dependencies together.
- Most Rust programs have build instructions focused on Linux and force some dependencies, some crates could not need them to work, investigate which crates the program is using.
- Some programs and libraries have bad documentation, lack build instructions or explain the dependencies, for these cases you will need to read third-party sources or examine the build system.

Arch Linux and AUR are the most simple references because they separate the build tools from runtimes and build dependencies, thus you make less mistakes.

They also have less expanded packages, while on Debian is common to have highly expanded programs and libraries, sometimes causing confusion.

(An expanded package is when most or all optional dependencies are enabled)

But Arch Linux is not clear about the optional feature flags and minimum dependencies to build and execute a program.

Using Gentoo as reference you can learn how to make the most minimum Redox port and increase your chances to make it work on Redox.

But Gentoo modify the feature flags of their packages to be used by their package system, thus you should use the FreeBSD Ports.

#### Arch Linux and AUR

Each package page of some program has a "Dependencies" section on the package details, see the items below:

- `dependency-name` - Build or runtime dependencies, they lack the `()` symbol (required to make the program build and execute)
- `dependency-name (make)` - Build tools (required to build the program)
- `dependency-name (optional)` - Programs or libraries to expand the program functionality

See the [Firefox](https://archlinux.org/packages/extra/x86_64/firefox/) package, for example.

- [Arch Linux Packages](https://archlinux.org/packages/)
- [AUR](https://aur.archlinux.org/)

#### Gentoo

The [Gentoo](https://gentoo.org) distribution does a wonderful job to document many programs and libraries, like source code location, dependencies, feature flags, cross-compilation and context.

It's the most complete reference for advanced packaging of programs, you can search the Gentoo packages on [this](https://packages.gentoo.org/) link.

To start you need to read [this](https://devmanual.gentoo.org/general-concepts/dependencies/) page to learn advanced packaging and some problems.

The "Dependencies" section of a Gentoo package will show a table with the following categories:

- `BDEPEND` - Host build tools (don't add them on the `dependencies = []` section of your `recipe.toml`)
- `DEPEND` - These dependencies are necessary to build the program
- `RDEPEND` - These dependencies are necessary to execute the program, can be mandatory or optional
- `PDEPEND` - Optional dependencies (customization)

The complex classification of Gentoo allow the packager to easily make a minimum build of a program on Redox, it's important because some optional dependencies can use APIs from the Linux kernel not present on Redox.

Thus the best approach is to know the minimum necessary to make the program work on Redox and expand from that.

#### FreeBSD

FreeBSD Ports is an important reference to find feature flags for C/C++ programs and libraries, you can see all feature flags of the software by reading the Makefile of the port.

- [FreeBSD Ports GitHub Mirror](https://github.com/freebsd/freebsd-ports)

Use the "Go to file" button to search for the software name.

### Testing

- Install the packages for your Linux distribution on the "Build Instructions" of the software, see if it builds on your system first (if packages for your distribution is not available, search for Debian/Ubuntu equivalents).

- Create the dependency recipe and run `make r.dependency-name` and see if it don't give errors, if you get an error it can be a dependency that require patches, missing C library functions or build tools, try to investigate both methods until the recipe finish the build process successfully.

If you run `make r.recipe-name` and it builds successfully, feel free to add the build tools on the [bootstrap.sh](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/bootstrap.sh) script (for native builds) or the [redox-base-containerfile](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/podman/redox-base-containerfile) configuration file (for Podman builds).

The `bootstrap.sh` script and `redox-base-containerfile` covers the build tools required by recipes on [demo.toml](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/config/x86_64/demo.toml)

## Building/Testing The Program

(Build on your Linux distribution before this step to see if all build system tools and development libraries are correct)

To build your recipe, run:

```sh
make r.recipe-name
```

To test your recipe, run:

```sh
make qemu
```

If you want to test from terminal, run:

```sh
make qemu gpu=no
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

Sometimes the `Cargo.toml` and `Cargo.lock` of some Rust programs can hold a crate versions lacking Redox support or broken Redox code path (changes on code that make the target OS fail), this will give you an error during the recipe compilation.

- The reason of fixed crate versions is explained [here](https://doc.rust-lang.org/cargo/faq.html#why-do-binaries-have-cargolock-in-version-control-but-not-libraries).

To fix this you will need to update the crates of your recipe after the first compilation and build it again, see the ways to do it below.

(Bump a crate version on `Cargo.toml` can break some part of the source code, on this case the program needs a source code patch to use the updated API of the crate)

### One or more crates

In maintained Rust programs you just need to update some crates to have Redox support (because they frequently update the crate versions), this will avoid random breaks on the dependency chain of the program (due to ABI changes) thus you can update one or more crates to reduce the chance of breaks.

We recommend that you do this based on the errors you get during the compilation, this method is recommended for maintained programs.

- Expose the Redox build system environment variables to the current shell, go to the `source` folder of your recipe and update the crates, example:

```sh
make env
```

```sh
cd cookbook/recipes/your-category/recipe-name/source
```

```sh
cargo update -p crate1 crate2
```

```sh
cd -
```

```sh
make r.recipe-name
```

If you still get the error, run:

```sh
make cr.recipe-name
```

### All crates

Most unmaintained Rust programs carry very old crate versions lacking Redox support, this method will update all crates of the dependency chain to the latest possible version based on the `Cargo.toml` configuration.

Be aware that some crates break the ABI frequently and make the program stop to work, that's why you must try the "One crate" method first.

- This method can fix locked crate versions on the dependency tree, if these locked crate versions don't change you need to bump the version of the crates locking the crate version, you will edit them in the `Cargo.toml` and run `cargo update` again (API breaks are expected).

(Also good to test the latest improvements of the libraries)

- Expose the Redox build system environment variables to the current shell, go to the `source` folder of your recipe and update the crates, example:

```sh
make env
```

```sh
cd cookbook/recipes/your-category/recipe-name/source
```

```sh
cargo update
```

```sh
cd -
```

```sh
make r.recipe-name
```

If you still get the error, run:

```sh
make cr.recipe-name
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
make cr.recipe-name
```

Or

```sh
make env
```

```sh
cd cookbook/recipes/your-category/recipe-name/source
```

```sh
cargo update -p crate-name
```

```sh
cd -
```

```sh
make r.recipe-name
```

If you still get the error, run:

```sh
make cr.recipe-name
```

### Local patches

If you want to patch some crate offline with your patches, add this text on the `Cargo.toml` of the program:

```toml
[patch.crates-io]
crate-name = { path = "patched-crate-folder" }
```

It will make Cargo replace the crate based on this folder in the program source code - `cookbook/recipes/your-category/your-recipe/source/patched-crate-folder` (you don't need to manually create this folder if you `git clone` the crate source code on the program source directory)

Inside this folder you will apply the patches on the crate source and rebuild the recipe.

## Cleanup

If you have some problems (outdated recipe), try to run these commands:

- This command will delete your old recipe binary/source.

```sh
make c.recipe-name u.recipe-name
```

- This command will delete your recipe binary/source and build (fresh build).

```sh
make ucr.recipe-name
```

## Search Text on Recipes

To speed up your porting workflow you can use the `grep` tool to search the recipe configuration:

```sh
cd cookbook/recipes
```

```sh
grep -rnwi "text" --include "recipe.toml"
```

This command will search all match texts in the `recipe.toml` files of each recipe folder.

## Search for functions on relibc

Sometimes your program is not building because relibc lack the necessary functions, to verify if they are implemented, run these commands:

```sh
cd relibc
```

```sh
grep -nrw "function-name" --include "*.rs"
```

You will insert the function name in `function-name`.

## Create a BLAKE3 hash for your recipe

You need to create a BLAKE3 hash of your recipe tarball if you want to merge it on upstream, for this you can use the `b3sum` tool, it can be installed from `crates.io` with `cargo install b3sum`.

After the first run of the `make r.recipe-name` command, run these commands:

```sh
b3sum cookbook/recipes/your-category/recipe-name/source.tar
```

It will print the generated BLAKE3 hash, copy and paste on the `blake3 =` field of your `recipe.toml`.

## Verify the size of your package

If the static linking of your recipe make the package bigger than 100MB, you need to reduce it with dynamic linking, to verify your package size use this command:

```sh
ls -1sh cookbook/recipes/your-category/recipe-name/target/your-target
```

See the size of the `stage.pkgar` and `stage.tar.gz` files.

## Submitting MRs

If you want to add your recipe on [Cookbook](https://gitlab.redox-os.org/redox-os/cookbook) to become a Redox package on the [CI server](https://static.redox-os.org/pkg/), read the [package policy](https://gitlab.redox-os.org/redox-os/cookbook#package-policy).

After this you can submit your merge request with proper category, dependencies and comments.
