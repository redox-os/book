# Porting Applications using Recipes

The [Including Programs in Redox](./including-programs.md) page gives an example to port/modify a pure Rust program, here we will explain the advanced way to port pure Rust programs, mixed Rust programs (Rust and C/C++ libraries, for example), C/C++ programs and others.

(Before reading this page you must read the [Build System](./build-system-reference.md) page)

- [Recipe](#recipe)
    - [Recipe Configuration Example](#recipe-configuration-example)
    - [Quick Recipe Template](#quick-recipe-template)
- [Cookbook](#cookbook)
    - [Cross Compiler](#cross-compiler)
    - [Cross Compilation](#cross-compilation)
    - [Templates](#templates)
    - [Metapackages](#metapackages)
- [Cookbook - Custom Template](#cookbook-custom-template)
    - [Functions](#functions)
    - [Environment Variables](#environment-variables)
        - [Quick Template](#quick-template)
    - [Packaging Behavior](#packaging-behavior)
    - [GNU Autotools script](#gnu-autotools-script)
    - [GNU Autotools configuration script](#gnu-autotools-configuration-script)
    - [CMake script](#cmake-script)
    - [Meson script](#meson-script)
    - [Cargo script](#cargo-script)
        - [Analyze the source code of a Rust program](#analyze-the-source-code-of-a-rust-program)
        - [Cargo packages command example](#cargo-packages-command-example)
            - [Cargo package with flags](#cargo-package-with-flags)
        - [Cargo bins script example](#cargo-bins-script-example)
        - [Cargo flags command example](#cargo-flags-command-example)
        - [Disable the default Cargo flags](#disable-the-default-cargo-flags)
        - [Enable all Cargo flags](#enable-all-cargo-flags)
        - [Cargo profiles command example](#cargo-profiles-command-example)
        - [Cargo examples command example](#cargo-examples-command-example)
            - [Cargo examples with flags](#cargo-examples-with-flags)
        - [Rename binaries](#rename-binaries)
        - [Change the active source code folder](#change-the-active-source-code-folder)
        - [Configuration files](#configuration-files)
        - [Script-based programs](#script-based-programs)
            - [Adapted scripts](#adapted-scripts)
            - [Non-adapted scripts](#non-adapted-scripts)
    - [Dynamically Linked Programs](#dynamically-linked-programs)
        - [Debugging](#debugging)
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
    - [Testing](#testing)
- [Feature Flags](#feature-flags)
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
script = """
insert your script here
"""
[build]
template = "build-system"
cargoflags = "--flag"
configureflags = [
    "OPTION1=text",
    "OPTION2=text",
]
cmakeflags = [
    "-DOPTION1=text",
    "-DOPTION2=text",
]
mesonflags = [
    "-Doption1=text",
    "-Doption2=text",
]
dependencies = [
    "library1",
    "library2",
]
script = """
# Uncomment the following if the package can be dynamically linked
#DYNAMIC_INIT
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
- `branch = "branch-name"` - Insert the program version or patched branch (can be removed if the `master` or `main` branches are being used)
- `rev = "commit-hash"` - Insert the commit hash of the latest stable version or commit of the program (can be removed if a stable version is not used or the latest commit is stable)
- `tar = "tarball-link.tar.gz"` - Insert the program source tarball (can be removed if a tarball is not used)
- `blake3 = "source-hash"` - Insert the program source tarball BLAKE3 hash, can be generated using the `b3sum` tool, install with the `cargo install b3sum` command (can be removed if using a Git repository or under porting)
- `patches = []` - Data type to load `.patch` files (can be removed if patch files aren't used)
- `"patch1.patch",` (Under the `patches` data type) - The patch file name (can be removed if the `patches` data type above is not present)
- `same_as = "../program-name"` - Insert the folder of other recipe to make a symbolic link to the `source` folder of other recipe, useful if you want modularity with synchronization
- `source.script` (Under the `[source]` section) - Data type used when you need to change the build system configuration (to regenerate the GNU Autotools configuration, for example)
- `[build]` - Section for data types that manage the program compilation and packaging
- `template = "build-system"` - Insert the program build system (`cargo` for Rust programs, `configure` for programs using GNU Autotools and `custom` for advanced porting with - custom commands)
- `cargoflags` - Data type for Cargo flags (string)
- `configureflags` - Data type for GNU Autotools flags (array)
- `cmakeflags` - Data type for CMake flags (array)
- `mesonflags` - Data type for Meson flags (array)
- `build.dependencies = []` (Under the `[build]` section) - Data type to add library dependencies, be it statically linked or dynamically linked
- `"library1",` - The library name (can be removed if the `dependencies` data type above is not present)
- `build.script` - Data type to load the custom commands for compilation and packaging
- `[package]` - Section for data types that manage the program package
- `package.dependencies = []` (Under the `[package]` section) - Data type to add interpreters or "data files" recipes to be installed by the package manager or build system installer
- `"runtime-dependency1",` - The name of the interpreter or data recipe (can be removed if the `dependencies` data type above is not present)

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

The GCC and LLVM compiler frontends on Linux use the Linux target triplet by default, it will create Linux ELF binaries that don't work on Redox because it can't undertstand them.

Part of this process is to use `glibc` (GNU C Standard Library) which don't support Redox system calls, to make the compiler use `relibc` (Redox C Library) the Cookbook needs to tell the build system of the program or library to use it, it's done with environment variables.

The Cookbook have templates to avoid custom commands for cross-compilation, but it's not always possible because some build systems aren't standardized or adapted for cross-compilation.

(Some build systems have different methods to enable cross-compilation and pass a different C standard library to the compiler, you will need to figure this out)

### Cross Compiler

Cookbook use Rust/GCC forks to do cross-compilation of recipes (programs) with `relibc` to any supported CPU architecture, you can check our cross-compilers on GitLab ([GCC](https://gitlab.redox-os.org/redox-os/gcc), [LLVM](https://gitlab.redox-os.org/redox-os/llvm-project), [Rust](https://gitlab.redox-os.org/redox-os/rust) and [build server](https://static.redox-os.org/toolchain/)).

### Cross Compilation

The Cookbook behavior is for cross-compilation because it allow us to do Redox development from Linux.

By default Cookbook use the architecture of your host system but you can change it easily on your `.config` file (`ARCH?=` field).

- Don't use a hardcoded CPU architecture on the `script` data types of your `recipe.toml`, it breaks cross-compilation.
- All recipes must use our cross-compilers, a Cookbook [template](#templates) does this automatically but it's not always possible, study the build system of your program/library to find these options or patch the configuration files.

### Templates

The template is the build system of the program or library, programs using an GNU Autotools build system will have a `configure` file on the root of the source tarball, programs using CMake build system will have a `CMakeLists.txt` file with all available CMake flags and a `cmake` folder, programs using Meson build system will have a `meson.build` file, Rust programs will have a `Cargo.toml` file, etc.

(You can't use the `script =` data types if templates are used)

- `template = "cargo"` - Build with Cargo using cross-compilation (Rust programs with one package in the Cargo workspace).
- `template = "configure"` - Build with GNU Autotools/GNU Make using cross-compilation.
- `template = "cmake"` - Build with CMake using cross-compilation.
- `template = "meson"` - Build with Meson using cross-compilation.
- `template = "custom"` - Run your commands on the `script =` field and build (Any build system or installation process).

The `script =` field runs any terminal command, it's important if the build system of the program don't support cross-compilation or need custom options that Cookbook don't support.

Each template (except `custom`) script supports flags, you can add flags as an array of strings
- `cargoflags = "foo"`
- `configureflags = [ "foo" ]`
- `cmakeflags = [ "foo" ]`
- `mesonflags = [ "foo" ]`

To find the supported Cookbook terminal commands, look the recipes using a `script =` field on their `recipe.toml` or read the [source code](https://gitlab.redox-os.org/redox-os/cookbook/-/tree/master/src).

- [Recipes](https://gitlab.redox-os.org/redox-os/cookbook/-/tree/master/recipes)

### Metapackages

Metapackages are packages without any files, just dependencies. Use the following recipe template to create a metapackage:

```toml
[package]
dependencies = [
    "package1",
    "package2",
]
```

## Cookbook - Custom Template

The `custom` template enable the `build.script =` data type to be used, this data type will run any command supported by the [GNU Bash](https://www.gnu.org/software/bash/) shell. The shell script will be wrapped with Bash functions and variables to aid build script. The wrapper can be found in [this Cookbook source file](https://gitlab.redox-os.org/redox-os/cookbook/-/blob/master/src/bin/cook.rs).


- Script example

```toml
[build]
script = """
first-command
second-command
"""
```

The script section starts at the location of the `${COOKBOOK_BUILD}` environment variable (`recipe-name/target/$TARGET/build`). This `${COOKBOOK_BUILD}` will be an empty folder, while recipe sources are in `${COOKBOOK_SOURCE}`. It is expected that the build script will not modify anything in `${COOKBOOK_SOURCE}`, otherwise, please use the `source.script = ` data type.

### Functions

Each template has a Bash function to be used in the `script` data type when you need to customize the template configuration to fix the program compilation or enable/disable features.

- `cookbook_cargo` - Bash function of the `cargo` template
- `cookbook_configure` - Bash function of the `configure` template
- `cookbook_cmake` - Bash function of the `cmake` template
- `cookbook_meson` - Bash function of the `meson` template
- `DYNAMIC_INIT` - Bash function to configure the recipe to be dynamically linked
- `DYNAMIC_STATIC_INIT` - Bash function to configure the recipe to be both statically and dynamically linked (library recipe only)

### Environment Variables

These variables available in the script:

- `${TARGET}` - Redox compiler triple target (`$ARCH-unknown-redox`)
- `${GNU_TARGET}` - Redox compiler triple target (GNU variant)
- `${COOKBOOK_MAKE_JOBS}` - Total CPU threads available
- `${COOKBOOK_RECIPE}` - Recipe folder.
- `${COOKBOOK_ROOT}` - The Cookbook directory.
- `${COOKBOOK_SOURCE}` - The `source` folder at `recipe-name/source` (program source).
- `${COOKBOOK_SYSROOT}` - The `sysroot` folder at `recipe-name/target/$TARGET/sysroot` (library sources).
- `${COOKBOOK_BUILD}` - The `build` folder at `recipe-name/target/$TARGET/build` (recipe build system).
- `${COOKBOOK_STAGE}` - The `stage` folder at `recipe-name/target/$TARGET/stage` (recipe binaries).

- For RISC-V, `${TARGET}` and `${GNU_TARGET}` is `riscv64gc-unknown-redox` and `riscv64-unknown-redox`, usually you want `${TARGET}` unless the script requires a GNU target triple.
- To get `$ARCH`, you need to add `ARCH="${TARGET%%-*}"` to the beginning of the script. 

There are more variables depending on the build script that you are using, read more below.

We recommend that you use path environment variables with the `"` symbol to clean any spaces on the path, spaces are interpreted as command separators and will break the path.

Example:

```sh
"${VARIABLE_NAME}"
```

If you have a folder inside the variable folder you can call it with:

```sh
"${VARIABLE_NAME}"/folder-name
```
Or
```sh
"${VARIABLE_NAME}/folder-name"
```

#### Quick Template

You can quickly copy these environment variables from this section.

```sh
"${COOKBOOK_SOURCE}/"
```

```sh
"${COOKBOOK_BUILD}/"
```

```sh
"${COOKBOOK_SYSROOT}/"
```

```sh
"${COOKBOOK_STAGE}/"
```


### Packaging Behavior

The Cookbook download the recipe sources on the `source` folder (`recipe-name/source`), copy the contents of this folder to the `build` folder (`recipe-name/target/$TARGET/build`), build the sources and move the binaries to the `stage` folder (`recipe-name/target/$TARGET/stage`).

If your recipe has library dependencies, it will copy the library source and linker objects to the `sysroot` folder to be used by the `build` folder.

- Moving the program files to the Redox filesystem

The `"${COOKBOOK_STAGE}"/` path is used to specify where the recipe files will go inside of Redox, in most cases `/usr/bin` and `/usr/lib`.

You can see path examples for most customized recipes below:

```sh
"${COOKBOOK_STAGE}"/ # The root of the Redox build system
"${COOKBOOK_STAGE}"/usr/bin # The folder where all global Unix executables go
"${COOKBOOK_STAGE}"/usr/lib # The folder where all static and shared library objects go
```

### GNU Autotools script

Use this script if the program or library need to be compiled with `configure` and `make`

- Configure with dynamic linking

```toml
script = """
DYNAMIC_INIT
COOKBOOK_CONFIGURE_FLAGS+=(
    --program-flag
)
cookbook_configure
"""
```

- Run make without configure

```toml
script = """
DYNAMIC_INIT
COOKBOOK_CONFIGURE_FLAGS+=(
    --program-flag
)
COOKBOOK_CONFIGURE="true"

rsync -av --delete "${COOKBOOK_SOURCE}/" ./
cookbook_configure
"""
```

Definition of `cookbook_configure` is roughly:

```sh
function cookbook_configure {
    "${COOKBOOK_CONFIGURE}" "${COOKBOOK_CONFIGURE_FLAGS[@]}" "$@"
    "${COOKBOOK_MAKE}" -j "${COOKBOOK_MAKE_JOBS}"
    "${COOKBOOK_MAKE}" install DESTDIR="${COOKBOOK_STAGE}"
}
```

### GNU Autotools configuration script

Sometimes the program tarball or repository is lacking the `configure` script, so you will need to generate this script.

- Add the following code below the `[source]` section

```toml
script = """
DYNAMIC_INIT
autotools_recursive_regenerate
"""
```

### CMake script

Use this script for programs using the CMake build system, more CMake options can be added with a `-D` before them, the customization of CMake compilation is very easy.

- CMake using dynamic linking

```toml
script = """
DYNAMIC_INIT
COOKBOOK_CMAKE_FLAGS+=(
    -Dprogram-flag
)
cookbook_cmake
"""
```

- CMake inside a subfolder

```toml
script = """
DYNAMIC_INIT
COOKBOOK_CMAKE_FLAGS+=(
    -Dprogram-flag
)
cookbook_cmake "${COOKBOOK_SOURCE}"/subfolder
"""
```

Definition of `cookbook_cmake` is roughly:

```sh
function cookbook_cmake {
    "${COOKBOOK_CMAKE}" "${COOKBOOK_SOURCE}" \
        "${COOKBOOK_CMAKE_FLAGS[@]}" \
        "$@"

    "${COOKBOOK_NINJA}" -j"${COOKBOOK_MAKE_JOBS}"
    DESTDIR="${COOKBOOK_STAGE}" "${COOKBOOK_NINJA}" install -j"${COOKBOOK_MAKE_JOBS}"
}
```


### Meson script

Use this script for programs using the Meson build system, more Meson options can be added with a `-D` before them, the customization of Meson compilation is very easy.

Keep in mind that some programs and libraries need more configuration to work.

- Meson using dynamic linking

```toml
script = """
DYNAMIC_INIT
COOKBOOK_MESON_FLAGS+=(
    -Dprogram-flag
)
cookbook_meson
"""
```

- Meson inside a subfolder

```toml
script = """
DYNAMIC_INIT
COOKBOOK_MESON_FLAGS+=(
    -Dprogram-flag
)
cookbook_meson "${COOKBOOK_SOURCE}"/subfolder
"""
```

### Cargo script

Use this script if you need to customize the `cookbook_cargo` function.

```toml
script = """
COOKBOOK_CARGO_FLAGS=(
    --bin foo
)
PACKAGE_PATH="subfolder" cookbook_cargo "${COOKBOOK_CARGO_FLAGS[@]}"
"""
```

If the project is roughly a simple Cargo project then `cookbook_cargo` is all that you need.

```toml
script = """
cookbook_cargo
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

(Ignore packages with the `[[lib]]` data type, Rust libraries don't need to be packaged because Rust has automatic dependency management, except for backup purposes)

But some programs don't have the `[[bin]]` and `[[lib]]` data types, for these cases you need to see the source code files, in most cases at the `src` folder.

- The file named `main.rs` contains the program executable code.
- The file named `lib.rs` contains the library object code (ignore it).

(Some Rust programs use Cargo packages instead of Cargo examples for examples, to discover that see if the "examples" folder has `.rs` files (Cargo examples) or folders with `Cargo.toml` files inside (Cargo packages) )

#### Cargo packages command example

This command is used for Rust programs that use package folders inside the repository for compilation, you need to use the name on the `name` field below the `[package]` section of the `Cargo.toml` file inside the package folder (generally using the same name of the program).

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
            --release \
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
            --release \
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

#### Cargo profiles command example

This script is used for Rust programs using Cargo profiles.

```toml
script = """
cookbook_cargo --profile profile-name
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

##### Cargo examples with flags

This script is used for Cargo examples with flags.

```toml
script = """
recipe="$(basename "${COOKBOOK_RECIPE}")"
    for example in example1 example2
    do
        "${COOKBOOK_CARGO}" build \
            --manifest-path "${COOKBOOK_SOURCE}/${PACKAGE_PATH}/Cargo.toml" \
            --example "${example}" \
            --release \
            --add-your-flag-here
        mkdir -pv "${COOKBOOK_STAGE}/usr/bin"
        cp -v \
            "target/${TARGET}/${build_type}/examples/${example}" \
            "${COOKBOOK_STAGE}/usr/bin/${recipe}_${example}"
    done
"""
```

(Replace the `example1` item and others with the example names, if the program has only one example you can remove the `example2` item)

#### Rename binaries

Some programs or examples could use generic names for their binaries, thus they could bring file conflicts on the packaging process, to avoid it use this command after the compilation or installation commands:

```sh
mv "${COOKBOOK_STAGE}/usr/bin/binary-name" "${COOKBOOK_STAGE}/usr/bin/new-binary-name"
```

- Duplicated names

Some recipes for Rust programs can duplicate the program name on the binary (`name_name`), you can also use the command above to fix these cases.

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
cookbook function or custom build system commands
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

- Python script example

```toml
script = """
mkdir -pv "${COOKBOOK_STAGE}"/usr/bin
cp "${COOKBOOK_SOURCE}"/script-name.py "${COOKBOOK_STAGE}"/usr/bin/script-name
chmod a+x "${COOKBOOK_STAGE}"/usr/bin/script-name
"""
```

(Rename the "script-name" parts with your script name and the `.py` extension for your script programming language extension if needed)

This script will rename your script name, make it executable and package.

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

It's the magic behind executable scripts as it make the system interpret the script as an common executable, if your script doesn't have a shebang on the beginning it can't work as an executable program.

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

### Dynamically Linked Programs

The `DYNAMIC_INIT` acts as a marker that indicates the package can be
dynamically linked. It automatically sets `LDFLAGS` and `RUSTFLAGS` based on
the preferred linkage. See the environment variables section under
configuration settings for more information.

In most cases, if you want to use dynamic linking for a package, just prepend
`DYNAMIC_INIT` in the recipe script. Depending on the package,
this *should* suffice. However, sometimes you *may* need to regenerate the GNU Autotools configuration,
which you can do by invoking the `autotools_recursive_regenerate` helper function
after `DYNAMIC_INIT` (See the examples below). This is to make sure the build
system uses our `libtool` fork. In other cases, more
recipe-specific modification may be required. 

#### Example

```diff
# <...snip...>

[build]
template = "custom"
script = """
+DYNAMIC_INIT
cookbook_configure
"""
```

```diff
# <...snip...>
[source]
+script = """
+DYNAMIC_INIT
+autotools_recursive_regenerate
+"""

[build]
template = "custom"
script = """
+DYNAMIC_INIT
+cookbook_configure
"""
```

Dynamically linked programs depend on shared libraries at runtime. To
include these libraries, you must add them to `build.dependencies`.

#### Example

```toml
# <...snip...>

[build]
dependencies = [
    "libmpc",
    "libgmp",
]
```

### Troubleshooting

- Why the dynamic linker (`ld.so`) is not finding my library?

Set `LD_DEBUG=all` and re-run the program. It will show you where objects are
being found and loaded, as well as the library search paths. You probably
forgot to add a library in the `dependencies` list. You can also use
`patchelf` on your host or on Redox to display all `DT_NEEDED` entries of an
object (`patchelf --print-needed <path>`). It is available by default for the
desktop configuration.

## Sources

### Tarballs

Tarballs are the most easy way to build a C/C++ program or library because the build system is already configured (GNU Autotools is the most used), while being more fast to download and process than Git repositories (the computer don't need to process Git deltas).

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

See the [nano package](https://gitlab.archlinux.org/archlinux/packaging/packages/nano/-/blob/main/.SRCINFO?ref_type=heads#L12) example.

- AUR - Search for your program, open the program page, go to the "Sources" section on the end of the package details.

### Git Repositories

Some programs don't offer official tarballs for releases, thus you need to use their Git repository and pin the commit hash of the latest stable release.

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

- Open the [Rust 1.74 release announcement](https://github.com/rust-lang/rust/releases/tag/1.74.0).
- The commit hash is `79e9716c980570bfd1f666e3b16ac583f0168962` and was shortened as `79e9716`.

#### GitLab release commit hash

Each GitLab release has a commit hash, you will use it to pin the last version of the program to keep code stability.

Open the "Releases" button and copy the first code on the end of the release announcement.

Example:

- Open the [Redox 0.8.0 release announcement](https://gitlab.redox-os.org/redox-os/redox/-/releases/0.8.0).
- The commit hash is `c8634bd9890afdac4438d1ff99631d600d469264` and was shortened as `c8634bd9`.

## Dependencies

A program dependency can be a library (a program that offer functions to some program), a runtime (a program that satisfy some program dependency when it's executed) or a build tool (a program to configure/build some program).

Most C, C++ and Rust programs place build tools/runtime together with development libraries (packages with `-dev` suffix) in their documentation for build instructions.

Example:

```sh
sudo apt-get install cmake libssl-dev
```

The `cmake` package is the build system while the `libssl-dev` package is the library (OpenSSL) linker objects (`.a` and `.so` files).

The Debian package system bundle shared/static objects on their `-dev` packages (other Linux distributions just bundle shared objects), while Redox will use the source code of libraries.

You would need to create a recipe of the `libssl-dev` and add on your `recipe.toml`, while the `cmake` package would need to be installed on your system.

Dependencies added below the `[build]` section can be statically linked (if the `DYNAMIC_INIT` function is not used) or dynamically linked (if the `DYNAMIC_INIT` function is used), while dependencies added below the `[package]` section will be installed by the build system installer or packaga manager.

Mixed Rust programs have crates ending with `-sys` to use C/C++ libraries of the system, sometimes they bundle them.

If you want an easy way to find dependencies, see the Debian stable [packages list](https://packages.debian.org/stable/allpackages).

You can search them with `Ctrl+F`, all package names are clickable and their homepage is available on the right-side of the package description/details.

- We recommend to use the FreeBSD dependencies of the program if available because Linux dependencies tend to contain Linux-specific kernel features not available on Redox (unfortunately the FreeBSD package naming policy don't separate library objects/interpreters from build tools in all cases, thus you need to know or search each item to know if it's a library, interpreter or build tool)
- Debian packages are the most easy way to find dependencies because they are the most used by software developers to describe "Build Instructions" dependencies.
- Don't use the `.deb` packages to create recipes, they are adapted for the Debian environment.
- The recipe `PATH` environment variable only read the build tools at `/usr/bin`, it don't read the `/usr/lib` and `/include` folders because the Linux library objects don't work on Redox.
- Don't add build tools on recipe dependencies, check the [Debian](https://packages.debian.org/stable/build-essential) and [Arch Linux](https://archlinux.org/packages/core/any/base-devel/) meta-packages for a common reference of build tools.
- The compiler will build the development libraries as `.a` files (objects for static linking) or `.so` files (objects for dynamic linking), the `.a` files will be mixed in the final binary while the `.so` files will be installed out of the binary (stored on the `/lib` directory of the system).
- Linux distributions add a number after the `.so` files to avoid conflicts on the `/usr/lib` folder when packages use different ABI versions of the same library, for example: `library-name.so.6`.
- You need to do this because each software is different, the major reason is the "Build Instructions" organization of each program.

If you have questions about program dependencies, feel free to ask us on the [Chat](./chat.md).

### Bundled Libraries

Some programs have bundled libraries, using CMake or a Python script, the most common case is using CMake (emulators do this in most cases).

The reason for this can be control over library versions to avoid compilation/runtime errors or a patched library with optimizations for specific tasks of the program.

In some cases some bundled library needs a Redox patch, if not it will give a compilation or runtime error.

Most programs using CMake will try to detect the system libraries on the build environment, if not they will use the bundled libraries.

The "system libraries" on this case is the recipes specified on the `build.dependencies = []` section of your `recipe.toml`.

To determine if you need to use a Redox recipe as dependency check if you find a `.patch` file on the recipe folder or if the `recipe.toml` has a `git =` field pointing to the Redox GitLab, if not you can probably use the bundled libraries without problems.

Generally programs with CMake use a `-DUSE_SYSTEM` flag to enable the "system libraries" behavior.

### Environment Variables

Sometimes specify the library recipe on the `dependencies = []` section is not enough, some build systems have environment variables to receive a custom path for external libraries.

When you add a library on your `recipe.toml` the Cookbook will copy the library source code to the `sysroot` folder at `cookbook/recipes/your-category/recipe-name/target/your-target`, this folder has an environment variable that can be used inside the `script =` field on your `recipe.toml`.

Example:

```toml
script = """
export OPENSSL_DIR="${COOKBOOK_SYSROOT}"
cookbook_cargo
"""
```

The `export` will active the `OPENSSL_DIR` variable on the environment, this variable is implemented by the program build system, it's a way to specify the custom OpenSSL path to the program's build system, as you can see, when the `òpenssl` recipe is added to the `dependencies = []` section its sources go to the `sysroot` folder.

Now the program build system is satisfied with the OpenSSL sources, the `cookbook_cargo` function calls Cargo to build it.

Programs using CMake don't use environment variables but an option, see this example:

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

See the [firefox package](https://archlinux.org/packages/extra/x86_64/firefox/), for example.

- [Arch Linux Packages](https://archlinux.org/packages/)
- [AUR](https://aur.archlinux.org/)

#### Gentoo

The [Gentoo](https://gentoo.org) distribution does a wonderful job to document many programs and libraries, like source code location, dependencies, feature flags, cross-compilation and context.

It's the most complete reference for advanced packaging of programs, you can search the Gentoo packages on the [Gentoo Packages](https://packages.gentoo.org/) website.

To start you need to read the [Gentoo documentation](https://devmanual.gentoo.org/general-concepts/dependencies/) page to learn advanced packaging and some problems.

The "Dependencies" section of a Gentoo package will show a table with the following categories:

- `BDEPEND` - Host build tools (don't add them on the `dependencies = []` section of your `recipe.toml`)
- `DEPEND` - These dependencies are necessary to build the program
- `RDEPEND` - These dependencies are necessary to execute the program, can be mandatory or optional
- `PDEPEND` - Optional dependencies (customization)

The complex classification of Gentoo allow the packager to easily make a minimum build of a program on Redox, it's important because some optional dependencies can use APIs from the Linux kernel not present on Redox.

Thus the best approach is to know the minimum necessary to make the program work on Redox and expand from that.

### Testing

- Install the packages for your Linux distribution on the "Build Instructions" of the software, if you don't have the knowledge to separate build tools from library dependencies see if it builds on your system first (if packages for your distribution is not available, search for Debian/Ubuntu equivalents).

- Create the dependency recipe and run `make r.dependency-name` and see if it don't give errors, if you get an error it can be a dependency that require patches, missing C/POSIX library functions or build tools, try to investigate both methods until the recipe finish the build process successfully.

If you run `make r.recipe-name` and it builds successfully, feel free to add the build tools on the [redox-base-containerfile](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/podman/redox-base-containerfile) configuration file (for Podman builds) or the [bootstrap.sh](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/bootstrap.sh) script (for native builds).

The `redox-base-containerfile` and `bootstrap.sh` script covers the build tools required by recipes on the [demo.toml](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/config/x86_64/demo.toml) filesystem configuration.

## Feature Flags

The program/library build systems offer flags to enable/disable features, it will increase the chance to make them work on Redox by disabling Linux-specific or unsupported features/libraries.

The FreeBSD port Makefiles are the best reference for feature flags to Redox as they tend to disable Linux-specific features and are adapted to cross-compilation, increasing the program/library compatiblity with non-Linux systems.

(You need to disable the program/library's build system tests to make cross-compilation work)

- [FreeBSD Ports GitHub Mirror](https://github.com/freebsd/freebsd-ports)

(Use the "Go to file" button to search for the software name)

## Building/Testing The Program

(if you don't have the knowledge to separate build tools from library dependencies build on your Linux distribution before this step to see if all build system tools and development libraries are correct)

To build your recipe, run:

```sh
make r.recipe-name
```

To test your recipe in Orbital, run:

```sh
make qemu
```

If you want to only test in the terminal, run:

```sh
make qemu gpu=no
```

If the build process was successful the recipe may be packaged and don't give errors (sometimes you need to fix packaging errors).

If you want to insert this recipe permanently in your QEMU image, add your recipe name below the last item in `[packages]` on your TOML config (`config/x86_64/your-config.toml`, for example).

- Example: `recipe-name = {}` or `recipe-name = "recipe"` (if you have `REPO_BINARY=1` in your `.config`).

To install your compiled recipe on QEMU image, run `make image`

If you had a problem, use this command to log any possible errors on your terminal output:

```sh
make r.recipe-name 2>&1 | tee recipe-name.log
```

The recipe sources will be extracted/downloaded on the `source` folder inside of your recipe folder, while the executables or data go to the `target` folder.

## Update crates

Sometimes the `Cargo.toml` and `Cargo.lock` of some Rust programs can hold a crate versions lacking Redox support or a broken Redox code path (changes on code that make the target OS fail), this will give you an error during the recipe compilation.

- The reason of fixed crate versions is explained on the [Cargo FAQ](https://doc.rust-lang.org/cargo/faq.html#why-do-binaries-have-cargolock-in-version-control-but-not-libraries).

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

Most unmaintained Rust programs carry very old crate versions with lacking/broken Redox support, this method will update all crates of the dependency chain to the latest possible version based on the `Cargo.toml` configuration.

Be aware that some crates break the API stability frequently and make the programs stop to work, that's why you must try the "One crate" method first.

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

- [Verify the dependency tree](./troubleshooting.md#verify-the-dependency-tree)

## Patch crates

### Redox forks

It's possible that some not ported crate have a Redox fork with patches, you can search the crate name on the [Redox GitLab](https://gitlab.redox-os.org/), generally the Redox patches stay in the `redox` branch or `redox-version` branch that follow the crate version.

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

Sometimes your program is not building because relibc lack the necessary functions, to verify if they are implemented run the following commands:

```sh
cd relibc
```

```sh
grep -nrw "function-name" --include "*.rs"
```

You will insert the function name in `function-name`

## Create a BLAKE3 hash for your recipe

You need to create a BLAKE3 hash of your recipe tarball if you want to merge it on upstream, to do this you can use the `b3sum` tool that can be installed from `crates.io` with the `cargo install b3sum` command.

After the first run of the `make r.recipe-name` command, run these commands:

```sh
b3sum cookbook/recipes/your-category/recipe-name/source.tar
```

It will print the generated BLAKE3 hash, copy and paste on the `blake3 =` field of your `recipe.toml`

## Verify the size of your package

To verify the size of your package use this command:

```sh
ls -1sh cookbook/recipes/your-category/recipe-name/target/your-target
```

See the size of the `stage.pkgar` and `stage.tar.gz` files.

## Submitting MRs

If you want to add your recipe on [Cookbook](https://gitlab.redox-os.org/redox-os/cookbook) to become a Redox package on the [build server](https://static.redox-os.org/pkg/), read the [package policy](https://gitlab.redox-os.org/redox-os/cookbook#package-policy).

After this you can submit your merge request with proper category, dependencies and comments.
