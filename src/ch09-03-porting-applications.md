# Porting Applications using Recipes

The [Including Programs in Redox](./ch09-01-including-programs.md) page gives an example to port/modify a pure Rust program, here we will explain the advanced way to port Rust programs, mixed Rust programs (Rust + C/C++ libraries, for example) and C/C++ programs.

(Before reading this page you must read the [Build System Quick Reference](./ch08-06-build-system-reference.md) page)

- [Recipe](#recipe)
    - [Quick Recipe Template](#quick-recipe-template)
    - [Environment Variables](#environment-variables)
- [Cookbook](#cookbook)
    - [Cross Compiler](#cross-compiler)
    - [Cross Compilation](#cross-compilation)
    - [Templates](#templates)
        - [Cargo template script](#cargo-template-script)
        - [Configure template script](#configure-template-script)
    - [Custom Template](#custom-template)
        - [Cargo script template](#cargo-script-template)
        - [GNU Autotools script template](#gnu-autotools-script-template)
        - [GNU Autotools script template (lacking a pre-configured tarball)](#gnu-autotools-script-template-lacking-a-pre-configured-tarball)
        - [CMake script template](#cmake-script-template)
        - [Cargo packages script template](#cargo-packages-script-template)
            - [Cargo package with flags](#cargo-package-with-flags)
        - [Cargo flags script template](#cargo-flags-script-template)
        - [Disable the default Cargo flags](#disable-the-default-cargo-flags)
        - [Enable all Cargo flags](#enable-all-cargo-flags)
        - [Cargo examples script template](#cargo-examples-script-template)
        - [Script template](#script-template)
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
        - [Arch Linux/AUR](#arch-linuxaur)
        - [Debian](#debian)
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

A recipe is how we call a software port on Redox, on this section we will explain the recipe structure and things to consider.

Create a folder in `cookbook/recipes/your-category` with a file named as `recipe.toml` inside, we will edit this file to fit the program needs.

- Commands example:

```sh
cd ~/tryredox/redox
```

```sh
mkdir cookbook/recipes/your-category/recipe-name
```

```sh
nano cookbook/recipes/your-category/recipe-name/recipe.toml
```

The `recipe.toml` example below is the supported recipe syntax, adapt for your use case.

```toml
[source]
git = "software-repository-link"
upstream = "software-repository-link"
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

- Don't remove or forget the `[build]` section (`[source]` section can be removed if you don't use `git` and `tar` or have the `source` folder present on your recipe folder).
- Insert `git` data type to clone your software repository, if it's not available the build system will build the contents inside the `source` folder on recipe directory.
- Insert the `upstream` data type if you want to add a Git remote on the source folder of your recipe.
- Insert `branch` data type if your want to use other branch.
- Insert `rev` data type if you want to use a commit revision (SHA1).
- Insert `tar` data type to download and extract tarballs, this can be used instead of `git`.
- Insert `blake3` data type to add [BLAKE3](https://en.wikipedia.org/wiki/BLAKE_(hash_function)) checksum verification for the tarball of your recipe.
- Insert `patches` data type to use patch files, they need to be in the same directory of `recipe.toml` (not needed if your program build and run without patches).
- Insert `dependencies` data type if your software have dependencies, to make it work your dependencies need their own recipes (if your software doesn't need this, remove it from your `recipe.toml`).
- Insert `script` data type to run your custom script (`script =` is enabled when you define your `template` as `custom`).

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

You can quickly copy and paste this template on each `recipe.toml`, that way you spent less time writting and has less chances for typos.

If the program use a Git repository, you can easily rename the `tar` to `git`.

If the program don't need dependencies, you can quickly remove the `dependencies = []` section.

After the `#TODO` you will write your current port status.

### Environment Variables

If you want to apply changes on the program source/binary you can use these variables on your commands:

- `${COOKBOOK_RECIPE}` - Represents the recipe folder.
- `${COOKBOOK_SOURCE}` - Represents the `source` folder at `cookbook/recipes/your-category/recipe-name/source` (program source).
- `${COOKBOOK_SYSROOT}` - Represents the `sysroot` folder at `cookbook/recipes/your-category/recipe-name/target/your-target` (library sources).
- `${COOKBOOK_STAGE}` - Represents the `stage` folder at `cookbook/recipes/your-category/recipe-name/target/your-target` (recipe binaries).

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

The GCC and LLVM compiler frontends on Linux use `glibc` (GNU C Library) by default on the linking process, it will create Linux ELF binaries that don't work on Redox because `glibc` don't support the Redox system calls.

To make the compiler use `relibc` (Redox C Library), the Cookbook needs to tell the build system of the program or library to use it, it's done with environment variables.

The Cookbook have templates to avoid custom commands for cross-compilation, but it's not always possible because some build systems are customized or not adapted for cross-compilation.

(Some build systems have different methods to enable cross-compilation and pass a custom C library for the compiler, you will need to figure this out)

### Cross Compiler

Cookbook use a patched Rust/GCC to do cross-compilation of recipes with `relibc` to any supported CPU architecture, you can check cross-compilers [here](https://static.redox-os.org/toolchain/).

### Cross Compilation

Cookbook default behavior is cross-compilation because it brings more flexiblity to the build system, as it makes the recipes use `relibc` or build to a different CPU architecture.

By default Cookbook respect the architecture of your host system but you can change it easily on your `.config` file (`ARCH?=` field).

- Don't use a CPU architecture inside the `recipe.toml` script field, it breaks cross-compilation.
- All recipes must use our cross-compilers, a Cookbook [template](#templates) does this automatically but it's not always possible, study the build system of your program/library to find these options or patch the configuration files.

### Templates

The template is the build system of the program or library, programs using an GNU Autotools build system will have a `configure` file on the root of the source tarball, programs using CMake build system will have a `CMakeLists.txt` file with all available CMake flags and a `cmake` folder, programs using Meson build system will have a `meson.build` file, Rust programs will have a `Cargo.toml` file, etc.

- `template = "cargo"` - Build with `cargo` (Rust programs, you can't use the `script =` field).
- `template = "configure"` - Build with `configure` and `make` (you can't use the `script =` field).
- `template = "custom"` - Run your commands on the `script =` field and build (Any build system/installation process).

The `script =` field runs any terminal command, it's important if the build system of the program don't support cross-compilation or need custom options that Cookbook don't support.

To find the supported Cookbook terminal commands, look the recipes using a `script =` field on their `recipe.toml` or read the [source code](https://gitlab.redox-os.org/redox-os/cookbook/-/tree/master/src).

- [Recipes](https://gitlab.redox-os.org/redox-os/cookbook/-/tree/master/recipes)

#### Cargo template script

You can see the commands of the `cargo` template below:

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
        mkdir -pv "${COOKBOOK_STAGE}/bin"
        cp -v \
            "target/${TARGET}/release/examples/${example}" \
            "${COOKBOOK_STAGE}/bin/${recipe}_${example}"
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
        mkdir -pv "${COOKBOOK_STAGE}/bin"
        cp -v \
            "target/${TARGET}/release/${package}" \
            "${COOKBOOK_STAGE}/bin/${recipe}_${package}"
    done
}
```

- Post-script

```sh
# Common post script
# Strip binaries
if [ -d "${COOKBOOK_STAGE}/bin" ]
then
    find "${COOKBOOK_STAGE}/bin" -type f -exec "${TARGET}-strip" -v {} ';'
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

#### Configure template script

You can see the commands of the `configure` template below:

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
if [ -d "${COOKBOOK_STAGE}/bin" ]
then
    find "${COOKBOOK_STAGE}/bin" -type f -exec "${TARGET}-strip" -v {} ';'
fi

# Remove libtool files
if [ -d "${COOKBOOK_STAGE}/lib" ]
then
    find "${COOKBOOK_STAGE}/lib" -type f -name '*.la' -exec rm -fv {} ';'
fi
```

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

#### GNU Autotools script template

```
script = """
COOKBOOK_CONFIGURE_FLAGS+=(
    --program-flag
)
cookbook_configure
"""
```

This script template is used for a GNU Autotools build system with flags, some programs need these flags for customization.

Change or copy/paste the "--program-flag" according to your needs.

(Some programs and libraries need more configuration to work)

#### GNU Autotools script template (lacking a pre-configured tarball)

If you are using the repository of the program you will need to create a configuration file for GNU Autotools.

```
script = """
./autogen.sh
cookbook_configure
"""
```

(Some programs and libraries need more configuration to work)

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

(Some programs and libraries need more configuration to work)

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
package="package-name"
"${COOKBOOK_CARGO}" build \
            --manifest-path "${COOKBOOK_SOURCE}/Cargo.toml" \
            --package "${package}" \
            --release
           --add-your-flag-here
        mkdir -pv "${COOKBOOK_STAGE}/bin"
        cp -v \
            "target/${TARGET}/release/${package}" \
            "${COOKBOOK_STAGE}/bin/${package}"
"""
```

- The `package-name` after `package=` is where you will insert the Cargo package name of your program.
- The `--add-your-flag-here` will be replaced by the program flags.

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

##### Adapted scripts

This script is for scripts adapted to be packaged, they have shebangs and rename the file to remove the script extension.

(Some programs and libraries need more configuration to work)

- One script

```
script = """
mkdir -pv "${COOKBOOK_STAGE}"/bin
cp "${COOKBOOK_SOURCE}"/script-name "${COOKBOOK_STAGE}"/bin/script-name
chmod a+x "${COOKBOOK_STAGE}"/bin/script-name
"""
```

This script will move the script from the `source` folder to the `stage` folder and mark it as executable to be packaged.

(Probably you need to mark it as executable, we don't know if all scripts carry executable permission)

- Multiple scripts

```
script = """
mkdir -pv "${COOKBOOK_STAGE}"/bin
cp "${COOKBOOK_SOURCE}"/* "${COOKBOOK_STAGE}"/bin
chmod a+x "${COOKBOOK_STAGE}"/bin/*
"""
```

This script will move the scripts from the `source` folder to the `stage` folder and mark them as executable to be packaged.

##### Non-adapted scripts

You need to use these scripts for scripts not adapted for packaging, you need to add shebangs, rename the file to remove the script extension (`.py`) and mark as executable (`chmod a+x`).

(Some programs and libraries need more configuration to work)

- One script

```
script = """
mkdir -pv "${COOKBOOK_STAGE}"/bin
cp "${COOKBOOK_SOURCE}"/script-name.py "${COOKBOOK_STAGE}"/bin/script-name
chmod a+x "${COOKBOOK_STAGE}"/bin/script-name
"""
```

(Rename the "script-name" parts with your script name)

This script will rename your script name (remove the `.py` extension, for example), make it executable and package.

- Multiple scripts

```
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

```
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
- The recipe `PATH` environment variable only read the build tools at `/bin`, it don't read the `/lib` and `/include` folders (this avoid [automagic dependencies](https://wiki.gentoo.org/wiki/Project:Quality_Assurance/Automagic_dependencies)).
- Don't add build tools on recipe dependencies, check the [Debian](https://packages.debian.org/testing/build-essential) and [Arch Linux](https://archlinux.org/packages/core/any/base-devel/) meta-packages for reference.
- The compiler will build the development libraries as `.a` files (objects for static linking) or `.so` files (objects for dynamic linking), the `.a` files will be mixed in the final binary while the `.so` files will be installed out of the binary (stored on the `/lib` directory of the system).
- Linux distributions add a number after the `.so` files to avoid conflicts on the `/lib` folder when packages use different ABI versions of the same library, for example: `library-name.so.6`.
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

The determine the program dependencies you can use Arch Linux and Debian as reference, Arch Linux and AUR are the best methods because they separate the build tools from runtimes and libraries, thus you commit less mistakes.

They also have less customized packages, while on Debian is common to have highly customized programs and libraries, sometimes causing confusion.

Arch Linux is more clear on this aspect.

- The build instructions of C/C++ programs tend to mix necessary and optional dependencies together.
- Most Rust programs have build instructions focused on Linux and force some dependencies, some crates could not need them to work, investigate which crates the program is using.

#### Arch Linux/AUR

Each package page of some program has a "Dependencies" section on the package details, see the items below:

- `(make)` - Build tools (required to build the program)
- `(optional)` - Programs/libraries to enchance the program functionality

The other items are runtime or library dependencies (without `()`).

See the [Firefox](https://archlinux.org/packages/extra/x86_64/firefox/) package, for example.

- [Arch Linux Packages](https://archlinux.org/packages/)
- [AUR](https://aur.archlinux.org/)

#### Debian

Each Debian package page has dependency items, see below:

- `depends` - Necessary dependencies (it don't separate build tools from runtimes)
- `recommends` - Expand the software functionality (optional)
- `suggests` - Expand the software functionality (optional)
- `enhances` - Expand the software functionality (optional)

(The `recommends`, `suggests` and `enhances` items aren't needed to make the program work)

See the [Firefox ESR](https://packages.debian.org/testing/firefox-esr) package, for example.

- [Debian Testing Packages](https://packages.debian.org/testing/allpackages)

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
make qemu vga=no
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
make c.recipe-name r.recipe-name
```

### All crates

Most unmaintained Rust programs have very old crate versions without up-to-date Redox support, this method will update all crates of the dependency chain to the latest version.

Be aware that some crates break the ABI frequently and make the program stop to work, that's why you must try the "One crate" method first.

(Also good to test the latest improvements of the libraries)

- Go to the `source` folder of your recipe and run `cargo update`, example:

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
make c.recipe-name r.recipe-name
```

### Local patches

If you want to patch some crate offline with your patches, add this text on the `Cargo.toml` of the program:

```toml
[patch.crates-io]
crate-name = { path = "patched-crate-folder" }
```

It will make Cargo replace the crate based on this folder in the program source code - `cookbook/recipes/your-category/your-recipe/source/patched-crate-folder` (you don't need to manually create this folder if you `git clone` the crate source code on the program source directory)

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
```

```sh
grep -rnw "text" --include "recipe.toml"
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
