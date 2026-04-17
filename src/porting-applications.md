# Application Porting

The [Including Applications in Redox](./including-programs.md) page gives an example to port/modify a pure Rust application, in this page we explain the advanced way to port pure Rust applications, mixed Rust applications (Rust and C/C++ libraries, for example), C/C++ applications and others.

(Before reading this page you must read the [Build System](./build-system-reference.md) page)

- [Notes](#notes)
- [Packaging Policy](#packaging-policy)
- [Testing Area](#testing-area)
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
    - [Analyze the source code of a Rust application](#analyze-the-source-code-of-a-rust-application)
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
    - [Script-based applications](#script-based-applications)
        - [Adapted scripts](#adapted-scripts)
        - [Non-adapted scripts](#non-adapted-scripts)
    - [Dynamically Linked applications](#dynamically-linked-applications)
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
    - [Build Tools](#build-tools)
- [Feature Flags](#feature-flags)
- [Building/Testing The application](#buildingtesting-the-application)
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

## Notes

This section contains quick important information for porting.

- The Redox build system does cross-compilation and the application or library need to be configured for that, read [this](./developer-faq.md#why-does-redox-do-cross-compilation) section to learn why it's needed
- Meson and CMake configurations have better cross-compilation support than GNU Autotools and GNU Make configurations, in case the application or library allows you to choose them
- The cross-compilation configuration of GNU Make configuration may require extensive and time-consuming patching, thus it's recommend to search if a version, branch, fork or patch with GNU Autotools, CMake or Meson support exist
- Some Rust programs use CMake or Meson to find C/C++ libraries instead of `-sys` crates
- Most or all build instructions were made for native compilation and not cross-compilation, with some poor documentation exceptions
- If the application or library build tests in compilation you need to disable them for cross-compilation
- If you are using dynamic linking and the `custom` recipe template, the `DYNAMIC_INIT` command need to be added in the first line of the `script` data type
- We recommend to use the FreeBSD dependencies of the application if available because Linux dependencies tend to contain Linux-specific kernel features not available on Redox (unfortunately the FreeBSD package naming policy doesn't separate library objects/interpreters from build tools in all cases, thus you need to know or search each item to know if it's a library, interpreter or build tool)
- Debian packages are the most easy way to find dependencies because they are the most used by software developers to describe "Build Instructions" dependencies.
- Don't use the `.deb` packages to create recipes, they are adapted for the Debian environment.
- The Debian naming policy use dashes as separators in packages with optional features: `application-name` (default application variant with compiled executables) and `application-name-dev` (application variant with objects for compilation linking), also check the source package to be sure
- The recipe `PATH` environment variable only read build tool recipes declared in the `build.dev-dependencies` data type or the host system's `/usr/bin` directory, it can't read the `/usr/lib` and `/include` folders because the Linux library objects don't work on Redox.
- The recipe support recursive dependencies, thus you don't need to specify a dependency two times if some dependency already provides it
- Don't add build tools in the `build.dependencies` data type, check the [Debian](https://packages.debian.org/stable/build-essential) and [Arch Linux](https://archlinux.org/packages/core/any/base-devel/) meta-packages for a common reference of build tools.
- The compiler can build recipe dependency libraries as `.so` files (objects for dynamic linking) or `.a` files (objects for static linking): The `.so` files will be installed out of the binary (stored on the `/lib` directory of the system) while the `.a` files will be mixed in the final binary.
- Linux distributions add a number after the `.so` files to avoid conflicts in the `/usr/lib` folder when applications use different API versions of the same library, for example: `library-name.so.6`
- Sometimes the releases of Git repositories are abandoned, verify if the tags have newer versions
- Sometimes tarballs of the official application or library website are abandoned in favor of Git repository tarballs, verify if the Git repository tarballs are more recent

You need to know the above information because each software is different, the major reason is the "Build Instructions" organization and context of each application or library.

## Packaging Policy

Before sending your recipe to upstream (to become a public package), you must follow the following rules:

### Naming

- The recipe name can't have dots, backslashes, and NULLs

### Cross-Compilation

- All recipes must use our cross-compilers, a Cookbook [template](#templates) does cross-compilation automatically but it's not always possible, study the build system of your application or library to find the options for this or patch the configuration files.
- Don't hardcode the CPU architecture in the recipe script (this would break the multi-arch support).

### Tarballs

- Don't use the auto-generated tarballs from GitHub, they aren't static and don't verify the archive integrity.

### Versioning

- Stable versions with point releases are prefered if possible for more stability

### API Compatibility

- Respect the API compatibility of C/C++ libraries in case of major version changes, for example: if the `openssl1` recipe is available and some application need `openssl3`, you will create a recipe for `openssl3` and not rename the `openssl1` recipe, because it may break some dependent recipes.

The exception for this rule is if some recipe don't need the previous major version of the library.

Read [this](./developer-faq.md#why-are-cc-applications-and-libraries-hard-and-time-consuming-to-port) section to know why it's needed

### Checksum

- If your recipe download a tarball, you will need to create a BLAKE3 hash for it. You can learn how to do it [here](#create-a-blake3-hash-for-your-recipe).

### License

- Don't package applications or libraries lacking a license.
- Verify if the application has a known license violation, in case of doubt ask us on the [chat](https://doc.redox-os.org/book/chat.html).
- Non-free applications and assets should be approved by Jeremy Soller before and added to a subcategory of the `nonfree` category.

## Testing Area

Work-in-progress software ports goes to the `wip` category, be aware of the following conditions during your packaging process:

- A recipe is considered ready if it's mostly working inside of Redox.
- All WIP recipes must have a `#TODO:` on the beginning of the `recipe.toml` and explain what is missing.
- BLAKE3 hashes for tarballs are optional in the `wip` category (quick testing workflow)
- Try to keep the recipe with the latest stable version of the application, but not if the latest stable version is too recent (the porting process can take months).
- Once the recipe is ready, add the BLAKE3 hash if needed and move the folder to the appropriate category.

### Suggestions for TODOs

These TODOs improve the packagers cooperation and understanding.

- `not compiled or tested` - It means that your recipe may be fully or partially configured and with necessary dependencies.
- `missing script for x: insert-the-link-for-build-instructions-here` - It means that your recipe is lacking the cross-compilation script for some build system, where `x` is the build system name. After `:` you will insert the link for the build instructions of the application or library, it will help other packagers to create the script for you.
- `missing dependencies: insert-the-link-for-required-dependencies-here` - It means that the `build.dependencies` or `package.dependencies` data types are incomplete.
- `probably wrong script: insert-the-link-for-build-instructions-here` - It means that you don't know yet if your script is working.
- `probably wrong template: insert-the-link-for-build-instructions-here` - It means that you don't know yet if the Cookbook template is working.
- `probably missing dependencies: insert-the-link-for-required-dependencies-here` - It means that you don't know yet if the required dependencies are satisfied.
- `promote` - It means that the recipe is working and should be moved to the equivalent category at `recipes/*`

Other TODOs are specific and won't be covered on this list.

## Recipe

A recipe is how we call a software port on Redox, this section explains the recipe configuration and details to consider.

Create a folder at `recipes/application-category` with a file named as `recipe.toml` inside, we will modify this file to fit the application's needs.

- Recipe creation from terminal with GNU Nano:

```sh
cd ~/tryredox/redox
```

```sh
mkdir recipes/application-category/application-name
```

```sh
nano recipes/application-category/application-name/recipe.toml
```

### Recipe Configuration Example

The recipe configuration (`recipe.toml`) example below contains all supported recipe options. Adapt for your script, application, library or data files.

TOML sections and data types can also be mentioned using the `section-name.data-type-name` format for easier explanation and better explanation writing.

```toml
[source]
git = "repository-link" # source.git data type
upstream = "repository-link" # source.upstream data type
branch = "branch-name" # source.branch data type
rev = "version-tag" # source.rev data type
shallow_clone = true # source.shallow_clone data type
tar = "tarball-link.tar.gz" # source.tar data type
blake3 = "source-hash" # source.blake3 data type
patches = [ # source.patches data type
    "patch1.patch",
    "patch2.patch",
]
same_as = "../application-name" # source.same_as data type
script = """ # source.script data type
insert your script here
"""
[build]
template = "build-system" # build.template data type
cargopath = "package-directory" # build.cargopath
cargopackages = [ # build.cargopackages
    "package1",
    "package2",
]
cargoexamples = [ # build.cargoexamples
    "example1",
    "example2",
]
cargoflags = ["--option-name"] # build.cargoflags data type
configureflags = [ # build.configureflags data type
    "OPTION1=value",
    "OPTION2=value",
]
cmakeflags = [ # build.cmakeflags data type
    "-DOPTION1=value",
    "-DOPTION2=value",
]
mesonflags = [ # build.mesonflags data type
    "-Doption1=value",
    "-Doption2=value",
]
dev-dependencies = [ # build.dev-dependencies data type
    "host:tool1",
    "host:tool2",
]
dependencies = [ # build.dependencies data type
    "library1",
    "library2",
]
script = """ # build.script data type
# Uncomment the following if the package can be dynamically linked
#DYNAMIC_INIT
insert your script here
"""
[package]
dependencies = [ # package.dependencies data type
    "runtime-dependency1",
    "runtime-dependency2",
]
```

- `[source]` : Section for data types that manage the application source (only remove it if you have a `source` folder)
- `source.git` : Git repository of the application (can be removed if a Git repository is not used), you can comment out it to not allow Cookbook to force a `git pull` or change the active branch to `master` or `main`. Read the [Git Repositories](#git-repositories) section for more details.
- `source.upstream` : If you are using a fork of the application source with patches add the application upstream source here (can be removed if the upstream source is being used on the `git` data type)
- `source.branch` : application version Git branch or patched Git branch (can be removed if using a tarball or the `master` or `main` Git branches are being used)
- `source.rev` : Git tag or commit hash of the latest stable version or last working commit of the application (can be removed if you are using a tarball or waiting Rust library version updates)
- `source.shallow_clone` : Boolean data type to only download the current commit of source files (Git [shallow clone](https://github.blog/open-source/git/get-up-to-speed-with-partial-clone-and-shallow-clone/)), which can reduce the download/delta processing time a lot and save many storage space (insert `shallow_clone = true`). Read the note in the [Git Repositories](#git-repositories) section if you are doing heavy development in a fork
- `source.tar` : application source tarball (can be removed if a tarball is not used), read the [Tarballs](#tarballs) section for more details.
- `source.blake3` : application source tarball BLAKE3 hash, can be generated using the `b3sum` tool, install with the `cargo install b3sum` command (can be removed if using a Git repository or under porting)
- `source.patches` : Data type to load `.patch` files (can be removed if patch files aren't used)
- `"patch1.patch",` : The patch file name (can be removed if the `patches` data type above is not present)
- `source.same_as` : Insert the folder of other recipe to make a symbolic link to the `source` folder of other recipe, useful if you want modularity with synchronization
- `source.script` : Data type used when you need to change the build system configuration (to regenerate the GNU Autotools configuration, for example)
- `[build]` : Section for data types that manage the application compilation and packaging
- `build.template` : Insert the application build system, read the [Templates](#templates) section for more details.
- `build.cargopath` : Data type for Cargo package directory path (when `Cargo.toml` is missing in repository/tarball root directory or when package is not declared in the root directory workspace)
- `build.cargopackages` : Data type for Cargo packages
- `build.cargoexamples` : Data type for Cargo examples
- `build.cargoflags` : Data type for Cargo flags (array)
- `build.configureflags` : Data type for GNU Autotools flags (array)
- `build.cmakeflags` : Data type for CMake flags (array)
- `build.mesonflags` : Data type for Meson flags (array)
- `build.dev-dependencies` : Data type to add the build tools needed by the application or library
- `build.dev-dependencies = ["host:tool1",]` : Build tool recipe name (can be removed if the `build.dev-dependencies` data type is not present)
- `build.dependencies` : Data type to add dynamically or statically linked library dependencies, read the [Dependencies](#dependencies) section for more details.
- `build.dependencies = ["library1",]` : Library recipe name (can be removed if the `build.dependencies` data type is not present)
- `build.script` : Data type to load the custom commands for compilation and packaging
- `[package]` : Section for data types that manage the application package
- `package.dependencies` : Data type to add tools, interpreters or "data files" recipes to be installed by the package manager or build system installer
- `package.dependencies = ["runtime-dependency1",]` : Tool, interpreter or data recipe names (can be removed if the `package.dependencies` data type above is not present)

### Quick Recipe Template

This is a recipe template for a quick porting workflow.

```toml
#TODO not compiled or tested
[source]
git = "repository-link"
rev = "version-tag"
branch = "version-branch"
tar = "tarball-link"
shallow_clone = true
[build]
template = "build-system"
dependencies = [
    "library1",
]
```

You can quickly copy and paste this template on each `recipe.toml`, that way you spent less time writting and has less chances for typos.

- If your application uses a tarball, you can quickly remove the `git` and `rev` data types.
- If your application uses a Git repository, you can quickly remove the `tar` data type.
- If you don't need to pin a Git tag or commit hash for the latest stable release or last working commit, you can quickly remove the `rev` data type.
- If the application doesn't need C, C++ or patched Rust dependencies, you can quickly remove the `dependencies = []` section.

After the `#TODO` comment you will write your current porting status.

## Cookbook

The GCC and LLVM compiler frontends on Linux use the Linux target triplet by default, it will create Linux ELF binaries that don't work on Redox because it can't undertstand them.

Part of this process is to use `glibc` (GNU C Standard Library) which doesn't support Redox system calls. To make the compiler use `relibc` (Redox C Standard Library) Cookbook needs to tell the build system of the application or library to use it, and this is done with environment variables and target/platform flags for the Redox target.

Cookbook have build system templates to avoid custom commands for cross-compilation, but it's not always possible because some build systems or applications aren't standardized or adapted for cross-compilation.

(Build systems have different methods to enable cross-compilation and pass a different C standard library to the compiler, you will need to read their documentation, application/library specific configuration or hack them)

### Cross Compiler

Cookbook uses Rust/GCC forks to do cross-compilation of recipes (applications) with `relibc` to any supported CPU architecture, you can check our cross-compilers on GitLab ([GCC](https://gitlab.redox-os.org/redox-os/gcc), [LLVM](https://gitlab.redox-os.org/redox-os/llvm-project), [Rust](https://gitlab.redox-os.org/redox-os/rust) and their [pre-compiled binaries](https://static.redox-os.org/toolchain/)).

### Cross Compilation

The Cookbook default compilation type is cross-compilation because it reduces the requirements to run applications on Redox and allow us to do Redox development from Linux and other Unix-like systems.

By default Cookbook use the CPU architecture of your host system but you can change it easily on your `.config` file (`ARCH?` environment variable).

- Don't use a hardcoded CPU architecture in the `script` data types of your `recipe.toml`, it breaks cross-compilation when a different CPU architecture is used by the build system.
- All recipes must use our cross-compilers, a Cookbook template does this automatically but it's not always possible, read the build system configuration of your application/library to find these options or patch the configuration files.

### Templates

A recipe template is the build system of the application or library supported by Cookbook.

- `template = "cargo"` - Build with Cargo using cross-compilation and static linking (Rust applications with one package in the Cargo workspace).
- `template = "configure"` - Build with GNU Autotools/GNU Make using cross-compilation and dynamic linking.
- `template = "cmake"` - Build with CMake using cross-compilation and dynamic linking.
- `template = "meson"` - Build with Meson using cross-compilation and dynamic linking.
- `template = "remote"` - Download the remote Redox package of the recipe if available in the [package server](https://static.redox-os.org/pkg/)
- `template = "custom"` - Run your commands on the `script =` field and build (Any build system or installation process).

Keep in mind that some recipes may need build tools that aren't provided by the build system templates or not installed in the Podman container or your system and will need to be added in the `dev.dependencies` data type of the recipe, but remember not to add build tools or compilers already provided by the templates.

The `script =` field runs any terminal command supported by GNU Bash, it's important if the build system of the application doesn't support cross-compilation or need custom options to work on Redox (you can't use the `build.script` data type if the `custom` template is not used).

Each template (except `custom`) script supports build flags, you can add flags as an array of strings:

- `cargoflags = "foo"`
- `configureflags = [ "foo" ]`
- `cmakeflags = [ "foo" ]`
- `mesonflags = [ "foo" ]`

To find the supported Cookbook Bash functions, look the recipes using a `script =` field on their `recipe.toml` or read the [source code](https://gitlab.redox-os.org/redox-os/redox/-/tree/master/src).

- [Recipes](https://gitlab.redox-os.org/redox-os/redox/-/tree/master/recipes)

#### Cases

- applications using the Cargo build system have a `Cargo.toml` file
- applications using the GNU Autotools build system have a `configure` or `autogen.sh` file in the source tarball
- applications using the CMake build system have a `CMakeLists.txt` file
- applications using the Meson build system have a `meson.build` file

### Metapackages

Metapackages are packages without any files, just dependencies. Use the following recipe example to create a metapackage:

```toml
[package]
dependencies = [
    "package1",
    "package2",
]
```

## Cookbook - Custom Template

The `custom` template enable the `build.script =` data type to be used, this data type will run any command supported by the [GNU Bash](https://www.gnu.org/software/bash/) shell. The shell script will be wrapped with Bash functions and variables to aid the build script. The wrapper can be found in [this Cookbook source file](https://gitlab.redox-os.org/redox-os/-/blob/master/src/bin/cook.rs).


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

Each template has a Bash function to be used in the `script` data type when you need to customize the template configuration to fix the application compilation or enable/disable features.

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
- `${COOKBOOK_SOURCE}` - The `source` folder at `recipe-name/source` (application source).
- `${COOKBOOK_SYSROOT}` - The `sysroot` folder at `recipe-name/target/$TARGET/sysroot` (library sources).
- `${COOKBOOK_BUILD}` - The `build` folder at `recipe-name/target/$TARGET/build` (recipe build system).
- `${COOKBOOK_STAGE}` - The `stage` folder at `recipe-name/target/$TARGET/stage` (recipe binaries).

- For RISC-V, `${TARGET}` and `${GNU_TARGET}` is `riscv64gc-unknown-redox` and `riscv64-unknown-redox`, usually you want `${TARGET}` unless the script requires a GNU target triple.
- To get `$ARCH`, you need to add `ARCH="${TARGET%%-*}"` to the beginning of the script.

There are more variables depending on the build script that you are using.

We recommend that you use path environment variables with the `"` symbol to clean any invalid characters (like spaces) on the path, spaces are interpreted as command separators and will break the path.

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

Cookbook downloads the recipe sources on the `source` folder (`recipe-name/source`), copies the contents of this folder to the `build` folder (`recipe-name/target/$TARGET/build`), builds the sources and moves the binaries to the `stage` folder (`recipe-name/target/$TARGET/stage`).

If your recipe has library dependencies, it will copy the library source and linker objects to the `sysroot` folder to be used by the `build` folder.

- Moving the application files to the Redox filesystem

The `"${COOKBOOK_STAGE}"/` path is used to specify where the recipe files will be stored in the Redox filesystem, in most cases `/usr/bin` and `/usr/lib`.

You can see path examples for most customized recipes below:

```sh
"${COOKBOOK_STAGE}"/ # The root of the Redox build system
"${COOKBOOK_STAGE}"/usr/bin # System-wide executables directory
"${COOKBOOK_STAGE}"/usr/lib # System-wide shared and static library objects directory
"${COOKBOOK_STAGE}"/usr/share # System-wide application static data files
"${COOKBOOK_STAGE}"/etc # System-wide application static configuration files
```

### GNU Autotools script

Use this script if the application or library needs to be compiled with custom options

- Configure with dynamic linking

```toml
script = """
DYNAMIC_INIT
COOKBOOK_CONFIGURE_FLAGS+=(
    --option1
    --option2
)
cookbook_configure
"""
```

- GNU Make without Configure

```toml
script = """
DYNAMIC_INIT
COOKBOOK_CONFIGURE_FLAGS+=(
    --option1
    --option2
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

Sometimes the application tarball or repository is lacking the `configure` script or it needs to be recreated for dynamic linking, so you will need to generate this script.

- Add the following code below the `[source]` section

```toml
script = """
autotools_recursive_regenerate
"""
```

### CMake script

Use this script for applications using the CMake build system, more CMake options can be added with a `-D` before them, the customization of CMake compilation is very easy.

- CMake using dynamic linking

```toml
script = """
DYNAMIC_INIT
COOKBOOK_CMAKE_FLAGS+=(
    -DOPTION1=value
    -DOPTION2=value
)
cookbook_cmake
"""
```

- CMake inside a subfolder

```toml
script = """
DYNAMIC_INIT
COOKBOOK_CMAKE_FLAGS+=(
    -DOPTION1=value
    -DOPTION2=value
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

Use this script for applications using the Meson build system, more Meson options can be added with a `-D` before them, the customization of Meson compilation is very easy.

Keep in mind that some applications and libraries need more configuration to work.

- Meson using dynamic linking

```toml
script = """
DYNAMIC_INIT
COOKBOOK_MESON_FLAGS+=(
    -Doption1=value
    -Doption2=value
)
cookbook_meson
"""
```

- Meson inside a subfolder

```toml
script = """
DYNAMIC_INIT
COOKBOOK_MESON_FLAGS+=(
    -Doption1=value
    -Doption2=value
)
cookbook_meson "${COOKBOOK_SOURCE}"/subfolder
"""
```

### Cargo script

Use this script if you need to customize the `cookbook_cargo` function.

```toml
script = """
DYNAMIC_INIT
COOKBOOK_CARGO_FLAGS=(
    --bin foo
)
PACKAGE_PATH="subfolder" cookbook_cargo "${COOKBOOK_CARGO_FLAGS[@]}"
"""
```

If the project is roughly a simple Cargo project then `cookbook_cargo` is all that you need.

```toml
script = """
DYNAMIC_INIT
cookbook_cargo
"""
```


### Analyze the source code of a Rust application

Rust applications and libraries use the `Cargo.toml` configuration file to configure the build system and source code.

While packaging Rust applications you need to know where the main executable is located in the Cargo project, to do this you need to verify the `Cargo.toml` files of the project.

A Rust application can have one or more Cargo packages to build, read the common assumptions below:

- Most Rust applications with a `src` folder use one Cargo package, thus you can use the `cargo` template.
- Most Rust applications with multiple Cargo packages name the main package with the name of the application.

Beyond these common source code organization, there are special cases.

- In some Rust applications the `Cargo.toml` file contains one of these data types:

```toml
[[bin]]
name = "executable-name"
[[lib]]
name = "library-object-name"
```

The `[[bin]]` is what you need, the application executable is built by this Cargo package.

But some applications don't have the `[[bin]]` and `[[lib]]` data types, for these cases you need to see the source code files, in most cases at the `src` folder.

- The file named `main.rs` contains the application executable code.
- The file named `lib.rs` contains the library object code (ignore it).

(Some Rust applications use packages instead of example files for examples, to discover that see if the "examples" folder has `.rs` files (examples files) or folders with `Cargo.toml` files inside (packages) )

### Cargo packages command example

This command is used for Rust applications that use package folders inside the repository for compilation, you need to use the name on the `name` field below the `[package]` section of the `Cargo.toml` file inside the package folder (generally using the same name of the application).

(This will fix the "found virtual manifest instead of package manifest" error)

```toml
script = """
DYNAMIC_INIT
cookbook_cargo_packages application-name
"""
```

(You can use `cookbook_cargo_packages application1 application2` if it's more than one package)

#### Cargo package with flags

If you need a script for a package with flags (customization), you can use this script:

```toml
script = """
DYNAMIC_INIT
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

- The `package-name` after `package=` is where you will insert the Cargo package name of your application.
- The `--add-your-flag-here` will be replaced by the application flag.

### Cargo bins script example

Some Rust applications use bins instead of packages to build, to build them you can use this script:

```toml
script = """
DYNAMIC_INIT
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

- The `bin-name` after `binary=` is where you will insert the Cargo package name of your application.
- The `--add-your-flag-here` will be replaced by the application flags.

### Cargo flags command example

Some Rust applications have flags for customization, you can find them below the `[features]` section in the `Cargo.toml` file.

```toml
script = """
DYNAMIC_INIT
cookbook_cargo --features flag-name
"""
```

### Disable the default Cargo flags

It's common that some flag of the application doesn't work on Redox, if you don't want to spend much time testing flags that work and don't work, you can disable all of them to see if the most basic featureset of the application works with this script:

```toml
script = """
DYNAMIC_INIT
cookbook_cargo --no-default-features
"""
```

### Enable all Cargo flags

If you want to enable all flags of the application, use:

```toml
script = """
DYNAMIC_INIT
cookbook_cargo --all-features
"""
```

### Cargo profiles command example

This script is used for Rust applications using Cargo profiles.

```toml
script = """
DYNAMIC_INIT
cookbook_cargo --profile profile-name
"""
```

### Cargo examples command example

This script is used for examples on Rust applications.

```toml
script = """
DYNAMIC_INIT
cookbook_cargo_examples example-name
"""
```

(You can use `cookbook_cargo_examples example1 example2` if it's more than one example)

#### Cargo examples with flags

This script is used for Cargo examples with flags.

```toml
script = """
DYNAMIC_INIT
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

(Replace the `example1` item and others with the example names, if the application has only one example you can remove the `example2` item)

### Rename binaries

Some applications or examples use generic names for their executable files which could cause conflicts in the package installation process, to avoid this use the following command after the compilation or installation commands:

```sh
mv "${COOKBOOK_STAGE}/usr/bin/binary-name" "${COOKBOOK_STAGE}/usr/bin/new-binary-name"
```

- Duplicated names

Some recipes for Rust applications can duplicate the application name in the executable (`name_name`), you can also use the command above to fix these cases.

### Change the active source code folder

Sometimes a application don't store the source code on the root of the Git repository, but in a subfolder.

For these cases you need to change the directory of the `${COOKBOOK_SOURCE}` environment variable in the beginning of the `build.script` data type, to do this add the following command on your recipe script:

```sh
COOKBOOK_SOURCE="${COOKBOOK_SOURCE}/subfolder-name"
```

- An example for a Rust application:

```toml
script = """
DYNAMIC_INIT
COOKBOOK_SOURCE="${COOKBOOK_SOURCE}/subfolder-name"
cookbook_cargo
"""
```

### Configuration Files

Some applications require to setup configuration files from the source code or tarball, to set them up use the following script example:

```toml
[build]
template = "custom"
script = """
DYNAMIC_INIT
cookbook build system function or custom build system commands
mkdir -pv "${COOKBOOK_STAGE}"/usr/share # create the /usr/share folder inside the package
cp -rv "${COOKBOOK_SOURCE}"/configuration-file "${COOKBOOK_STAGE}"/usr/share # copy the configuration file from the application source code to the package
"""
```

Modify the script above to your needs.

### Script-based applications

Read the following scripts to package interpreted applications.

#### Adapted scripts

This script is for scripts adapted to be packaged, they contain shebangs and renamed the file to remove the script extension.

(Some applications and libraries need more configuration to work)

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

#### Non-adapted scripts

You need to use the following script examples for scripts not adapted for packaging, you need to add shebangs, rename the file to remove the script extension (`.py`) and mark as executable (`chmod a+x`).

(Some applications and libraries need more configuration to work)

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

It's the magic behind executable scripts as it make the system interpret the script as a common executable, if your script doesn't have a shebang on the beginning it can't be launched like a conventional compiled application executable.

To allow this use the following script:

```toml
script = """
mkdir -pv "${COOKBOOK_STAGE}"/usr/bin
cp "${COOKBOOK_SOURCE}"/script-name.py "${COOKBOOK_STAGE}"/usr/bin/script-name
sed -i '1 i\#!/usr/bin/env python3' "${COOKBOOK_STAGE}"/usr/bin/script-name
chmod a+x "${COOKBOOK_STAGE}"/usr/bin/script-name
"""
```

The `sed -i '1 i\#!/usr/bin/env python3' "${COOKBOOK_STAGE}"/usr/bin/script-name` command will add the shebang on the beginning of your script.

`python3` is the script interpreter in this case, use `bash` or `lua` or whatever interpreter is appropriate for your case.

There are many combinations for these script examples: you can download scripts without the `[source]` section, make customized installations, etc.

### Dynamically Linked Applications

The `DYNAMIC_INIT` acts as a marker that indicates the recipe can be
dynamically linked, it does the following things:

- Automatically sets `LDFLAGS` and `RUSTFLAGS` based on the preferred linkage
- Change GNU Autotools defaults to emit `*.so` files and do not create `*.a` files. For executables it setup the appropriate `rpath` link so `*.so` files can be discovered and linked.

See the environment variables section under configuration settings for more information.

In most cases if you want to use dynamic linking for a recipe just prepend
`DYNAMIC_INIT` in the recipe script. Depending on the recipe,
this *should* suffice. However, sometimes you *may* need to regenerate the GNU Autotools configuration,
which you can do by invoking the `autotools_recursive_regenerate` helper function (See the examples below).
This is to make sure the build system uses our `libtool` fork. In other cases, more
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
+autotools_recursive_regenerate
+"""

[build]
template = "custom"
script = """
+DYNAMIC_INIT
+cookbook_configure
"""
```

Dynamically linked applications depend on shared libraries at runtime. To
include these libraries, you must add them in the `build.dependencies` data type.

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

- Why is the dynamic linker (`ld.so`) not finding my library?

Set `LD_DEBUG=all` and re-run the application. It will show you where library objects are
being found and loaded, as well as the library search paths. You probably
forgot to add a library in the `build.dependencies` list. You can also use
`patchelf` on your host or on Redox to display all `DT_NEEDED` entries of an
object (`patchelf --print-needed <path>`). It is available by default in the
`desktop` variant.

## Sources

### Tarballs

Tarballs are the most easy way to build a C/C++ application or library because the build system is already configured (GNU Autotools is the most used), while being more fast to download and process than big Git repositories if shallow clone is not used (the system doesn't need to process many Git deltas).

Your `recipe.toml` will have the following content:

```toml
[source]
tar = "tarball-link"
```

Copy the tarball link and paste in the `tarball-link` field.

**Only use official tarballs**, GitHub auto-generates tarballs for each new release or tag of the application, but they [aren't static](https://github.blog/changelog/2023-01-30-git-archive-checksums-may-change/) (break the checksum) and [don't verify the archive integrity](https://github.blog/2023-02-21-update-on-the-future-stability-of-source-code-archives-and-hashes/).

You can find the official tarballs in the release announcement assets with the application name and ending with `tar.gz` or `tar.xz` (their URLs contain "releases" instead of "archive"), while unstable tarballs can be found on the "Source code" buttons (their URLs contain "archive").

- In most cases they are created using the [GNU Tar](https://www.gnu.org/software/tar/) tool.
- Avoid files containing the names "linux" and "x86_64" on GitHub, they are pre-built binaries for some operating system and CPU architecture, not source code.
- Some applications require Git submodules to work, you can't use tarballs if the official tarball doesn't bundle the submodules.
- Archives with `tar.xz` and `tar.bz2` are preferred as they tend to have a higher compression level, thus smaller file size.

#### Build System

In most cases the tarballs use GNU Autotools to build, it's common that the tarball method of compilation is not well documented, causing confusion for new packagers.

To investigate, you can do the following things:

- Build with the `configure` template and see if it works (sometimes you need to use some flags or customize)
- Search the Git repository of the application or library for `autogen.sh` and `configure.ac` files, it means that support for GNU Autotools is available, when some tarball is created, it comes with a `configure` file inside, this file doesn't exist on the Git repository and you need to create it by running the `autogen.sh` script.
- Sometimes these files are available but GNU Autotools is deprecated (because it's old), we recommend that you use the supported build system (CMake or Meson in most cases).

#### Links

Sometimes it's hard to find the official tarball of some software, as each project website's organization is different.

To help on this process, the [Arch Linux packages](https://archlinux.org/packages/) and [AUR](https://aur.archlinux.org/) are the most easy repositories to find tarball links in the configuration of packages.

- Arch Linux packages: Search for your application, open the application page, see the "Package Actions" category on the top right position and click on the "Source Files" button, a GitLab page will open, open the `.SRCINFO` and search for the tarball link on the "source" fields of the file.

See the [nano package](https://gitlab.archlinux.org/archlinux/packaging/packages/nano/-/blob/main/.SRCINFO?ref_type=heads#L12) example.

- AUR: Search for your application, open the application page, go to the "Sources" section on the end of the package details.

### Git Repositories

Some applications don't offer official tarballs for releases, thus you need to use their Git repository and the branch of the latest stable version (if available) or pin the tag or commit hash of the latest stable version or last working commit.

Your `recipe.toml` will have the following content:

```toml
[source]
git = "repository-link"
branch = "version-branch"
rev = "version-tag"
shallow_clone = true
```

- Shallow clone is not recommended if you forked the repository and is doing heavy development to port, if you don't want to change the recipe configuration after source fetch run the following command to disable shallow clone temporarily:

```
git fetch --unshallow
```

#### GitHub release

Each GitHub release has a tag or commit hash, you will use it to pin the lastest stable version of the application to keep code stability.

Example:

- Open the [Rust 1.74 release announcement](https://github.com/rust-lang/rust/releases/tag/1.74.0)
- The tag is `1.74.0` and the commit hash is `79e9716c980570bfd1f666e3b16ac583f0168962` and is shortened as `79e9716`

#### GitLab release commit hash

Each GitLab release has a tag or commit hash, you will use it to pin the lastest stable version of the application to keep code stability.

Example:

- Open the [Redox 0.8.0 release announcement](https://gitlab.redox-os.org/redox-os/redox/-/releases/0.8.0)
- The tag is `0.8.0` and the commit hash is `c8634bd9890afdac4438d1ff99631d600d469264` and is shortened as `c8634bd9`

## Dependencies

A application dependency can be a library (a application that offer functions to some application), a runtime (a application that satisfy some application dependency when it's executed) or a build tool (a application to configure/build some application).

Most C, C++ and Rust applications place build tools/runtime together with development libraries (packages with `-dev` suffix) in their build instructions documentation.

Example:

```sh
sudo apt-get install cmake libssl-dev
```

The `cmake` package is the build system (build tool) while the `libssl-dev` package is the library (OpenSSL) linker objects (`.a` and `.so` files), the Debian package system bundle shared/static objects on their `-dev` packages (other Linux distributions just bundle shared objects).

You would need to create a recipe of the `libssl-dev` package and add in the `build.dependencies` data type of your `recipe.toml` file, while the `cmake` package would need the `cmake` Cookbook template.

Dependencies added in the `build.dependencies` data type can be dynamically linked (if the `DYNAMIC_INIT` function is used) or statically linked (if the `DYNAMIC_INIT` function is not used), while dependencies added in the `package.dependencies` data type will be installed by the build system installer or package manager.

Mixed Rust applications have crates ending with `-sys` to use bundled or system C/C++ libraries.

If you want an easy way to find dependencies, see the Debian stable [packages list](https://packages.debian.org/stable/allpackages).

You can search them with Ctrl+F, all package names are clickable and their websites is available on the right-side of the package description/details.

If you have questions about application dependencies, feel free to ask us on the [Chat](./chat.md).

### Bundled Libraries

Some applications have bundled libraries, using CMake or a Python script, the most common case is using CMake (emulators do this in most cases).

The reason for this can be control over library versions to avoid compilation/runtime errors or a patched library with optimizations for specific tasks of the application.

In some cases some bundled library needs a Redox patch, if not it will give a compilation or runtime error.

Most applications using CMake will try to detect the system libraries on the build environment, if not they will use the bundled libraries.

The "system libraries" on this case is the recipes specified on the `build.dependencies = []` section of your `recipe.toml`.

To determine if you need to use a Redox recipe as dependency check if you find a `.patch` file on the recipe folder or if the `recipe.toml` has a `git =` field pointing to the Redox GitLab, if not you can probably use the bundled libraries without problems.

Generally applications with CMake use a `-DUSE_SYSTEM` flag to enable the "system libraries" behavior.

### Environment Variables

Sometimes specify the library recipe on the `dependencies = []` section is not enough, some build systems have environment variables to receive a custom path for external libraries.

When you add a library on your `recipe.toml` the Cookbook will copy the library source code to the `sysroot` folder at `recipes/your-category/recipe-name/target/$TARGET`, this folder has an environment variable that can be used inside the `script =` field on your `recipe.toml`.

Example:

```toml
script = """
export OPENSSL_DIR="${COOKBOOK_SYSROOT}"
cookbook_cargo
"""
```

The `export` will activate the `OPENSSL_DIR` variable in the environment, this variable is implemented by the application build system. It's a way to specify the custom OpenSSL path to the application's build system, as you can see, when the `openssl` recipe is added to the `dependencies = []` section its sources go to the `sysroot` folder.

Now the application build system is satisfied with the OpenSSL sources, the `cookbook_cargo` function calls Cargo to build it.

applications using CMake don't use environment variables but an option, see this example:

```toml
script = """
COOKBOOK_CMAKE_FLAGS+=(
    -DOPENSSL_ROOT_DIR="${COOKBOOK_SYSROOT}"
)
cookbook_cmake
"""
```

On this example the `-DOPENSSL_ROOT_DIR` option will have the custom OpenSSL path.

### Submodules

In some applications or libraries you can't use tarballs because they don't carry the necessary Git submodules of the application (most common in GitHub generated tarballs), on these cases you will need to use the Git repository or the commit of the last stable release (Cookbook download the submodules automatically).

To identify if the application uses Git submodules, check if it has external folders to other repositories (they appear with a commit hash on the right side) or the existence of a `.gitmodules` file.

Follow these steps to use the last stable version of the application when Git submodules are necessary:

- Open the application/library Git repository.
- Check the "Releases" or "Tags" buttons, in most cases the application have a stable release at "Releases".
- In both pages the commit hash of the stable release will be the first item of the announcement below the version number.
- Copy the repository link/version branch or tag and paste on your `recipe.toml`, for example:

```toml
git = "repository-link"
branch = "version-branch"
rev = "version-tag"
```

If the last stable release is too old or lacks important fixes due to low maintenance we recommend that you ignore it and use the Git repository to download/build bug fixes sent after this old version, if you are concerned about the application upstream breaking the recipe, you can use the commit of the last successful CI test.

### Configuration

The determine the application dependencies you can use Arch Linux and Gentoo as reference.

- The build instructions of C/C++ applications tend to mix necessary and optional dependencies together.
- Most Rust applications have build instructions focused on Linux and force some dependencies, some crates could not need them to work, so investigate which crates the application is using.
- Some applications and libraries have bad documentation, lack build instructions or don't explain the dependencies, for these cases you will need to read third-party sources or examine the build system.

Arch Linux and AUR are the most simple references because they separate the build tools from runtimes and build dependencies, thus you make fewer mistakes.

They also have less expanded packages, while on Debian is common to have highly expanded applications and libraries, sometimes causing confusion.

(An expanded package is when most or all optional dependencies are enabled)

But Arch Linux is not clear about the optional feature flags and minimum dependencies to build and execute a application.

Using Gentoo as reference you can learn how to make the most minimum Redox port and increase your chances to make it work on Redox.

But Gentoo modify the feature flags of their packages to be used by their package system, thus you should use the FreeBSD Ports.

#### Arch Linux and AUR

Each package page of some application has a "Dependencies" section on the package details, see the items below:

- `dependency-name` - Build or runtime dependencies, they lack the `()` symbol (required to make the application build and execute)
- `dependency-name (make)` - Build tools (required to build the application)
- `dependency-name (optional)` - applications or libraries to expand the application functionality

See the [firefox package](https://archlinux.org/packages/extra/x86_64/firefox/), for example.

- [Arch Linux Packages](https://archlinux.org/packages/)
- [AUR](https://aur.archlinux.org/)

#### Gentoo

The [Gentoo](https://gentoo.org) distribution does a wonderful job to document many applications and libraries, like source code location, dependencies, feature flags, cross-compilation and context.

It's the most complete reference for advanced packaging of applications, you can search the Gentoo packages on the [Gentoo Packages](https://packages.gentoo.org/) website.

To start you need to read the [Gentoo documentation](https://devmanual.gentoo.org/general-concepts/dependencies/) page to learn advanced packaging and some problems.

The "Dependencies" section of a Gentoo package will show a table with the following categories:

- `BDEPEND` - Host build tools (don't add them on the `dependencies = []` section of your `recipe.toml`)
- `DEPEND` - These dependencies are necessary to build the application
- `RDEPEND` - These dependencies are necessary to execute the application, can be mandatory or optional
- `PDEPEND` - Optional dependencies (customization)

The complex classification of Gentoo allow the packager to easily make a minimum build of a application on Redox, it's important because some optional dependencies can use APIs from the Linux kernel not present on Redox.

Thus the best approach is to know the minimum necessary to make the application work on Redox and expand from that.

### Build Tools

Add missing recipe build tools in the [podman/redox-base-containerfile](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/podman/redox-base-containerfile) file (for Podman builds) or install them on your system (for Native builds).

The `podman/redox-base-containerfile` file and `native_bootstrap.sh` script covers the build tools required by recipes on the [demo.toml](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/config/x86_64/demo.toml) filesystem configuration.

## Feature Flags

The application/library build systems offer flags to enable/disable features, it will increase the chance to make them work on Redox by disabling Linux-specific or unsupported features/libraries.

Sometimes you need to read the build system configuration to find important or all flags that weren't documented by the application.

### Cargo

You can find the feature flags below the `[features]` section in the `Cargo.toml` file.

### GNU Autotools

You can find the feature flags in the `INSTALL`, `README` or `configure` files.

### CMake

You can find the feature flags in the `CMakeLists.txt` file.

### Meson

You can find the feature flags in the `meson_options` file.

### FreeBSD Reference

If you can't find the application build system flags the FreeBSD port Makefiles are the best reference for feature flags to Redox as they tend to disable Linux-specific features and are adapted to cross-compilation, increasing the application/library compatiblity with non-Linux systems.

(You need to disable the application/library's build system tests to make cross-compilation work)

- [FreeBSD Ports GitHub Mirror](https://github.com/freebsd/freebsd-ports)

(Use the "Go to file" button to search for the software name)

## Building/Testing The application

Tip: If you want to avoid problems not related to Redox install the application dependencies and build to your system first (if packages for your Unix-like distribution aren't available search for Debian/Ubuntu equivalents).

To build your recipe, run:

```sh
make r.recipe-name
```

If you get an error read the log and determine if it is one of the following problems:

- Missing build tools
- Cross-compilation configuration problem
- Lack of Redox patches
- Missing C, POSIX or Linux library functions in relibc

Use this command to log any possible errors on your terminal output:

```sh
make r.recipe-name 2>&1 | tee recipe-name.log
```

If the compilation was successful the recipe can be installed in the QEMU image and tested inside of Redox to find possible runtime errors or crashes.

- To temporarily install the recipe to your QEMU image run `make p.recipe-name`
- To permanently install the recipe to your QEMU image add your recipe name (`recipe-name = {}`) below the last item in the `[packages]` section of your TOML config at `config/$ARCH/your-config.toml` and run `make image`

To test your recipe inside of Redox with Orbital, run:

```sh
make qemu
```

If you only want to test in the Redox terminal interface, run:

```sh
make qemu gpu=no
```

## Update crates

Sometimes the `Cargo.toml` and `Cargo.lock` of some Rust applications can hold a crate versions lacking Redox support or a broken Redox code path (changes on code that make the target OS fail), this will give you an error during the recipe compilation.

- The reason of fixed crate versions is explained on the [Cargo FAQ](https://doc.rust-lang.org/cargo/faq.html#why-do-binaries-have-cargolock-in-version-control-but-not-libraries).

To fix this you will need to update the crates of your recipe after the first compilation and build it again, see the ways to do it below.

(Bump a crate version on `Cargo.toml` can break some part of the source code, on this case the application needs a source code patch to use the updated API of the crate)

### One or more crates

In maintained Rust applications you just need to update some crates to have Redox support (because they frequently update the crate versions), this will avoid random breaks on the dependency chain of the application (due to ABI changes) thus you can update one or more crates to reduce the chance of breaks.

We recommend that you do this based on the errors you get during the compilation, this method is recommended for maintained applications.

- Expose the Redox build system environment variables to the current shell, go to the `source` folder of your recipe and update the crates, example:

```sh
make env
```

```sh
cd recipes/your-category/recipe-name/source
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

Most unmaintained Rust applications carry very old crate versions with lacking/broken Redox support, this method will update all crates of the dependency chain to the latest possible version based on the `Cargo.toml` configuration.

Be aware that some crates break the API stability frequently and make the applications stop working - that's why you must try the "One crate" method first.

- This method can fix locked crate versions on the dependency tree, if these locked crate versions don't change you need to bump the version of the crates locking the crate version, you will edit them in the `Cargo.toml` and run `cargo update` again (API breaks are expected).

(Also good to test the latest improvements of the libraries)

- Expose the Redox build system environment variables to the current shell, go to the `source` folder of your recipe and update the crates, example:

```sh
make env
```

```sh
cd recipes/your-category/recipe-name/source
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

If you use the above methods but the application is still using old crate versions, see this section:

- [Verify the dependency tree](./troubleshooting.md#verify-the-dependency-tree)

## Patch crates

### Redox forks

It's possible that some not ported crate has a Redox fork with patches, you can search the crate name on the [Redox GitLab](https://gitlab.redox-os.org/), generally the Redox patches stay in the `redox` branch or `redox-version` branch that follow the crate version.

To use this Redox fork on your Rust application, add this text on the end of the `Cargo.toml` in the application source code:

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
cd recipes/your-category/recipe-name/source
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

If you want to patch some crate offline with your patches, add this text on the `Cargo.toml` of the application:

```toml
[patch.crates-io]
crate-name = { path = "patched-crate-folder" }
```

It will make Cargo replace the crate based on this folder in the application source code - `recipes/your-category/your-recipe/source/patched-crate-folder` (you don't need to manually create this folder if you `git clone` the crate source code on the application source directory)

Inside this folder you will apply the patches on the crate source and rebuild the recipe.

## Cleanup

If you have some problems (outdated recipe), try to run these commands:

- This command will delete your old recipe source/binary.

```sh
make u.recipe-name
```

- This command will delete your recipe binary/source and build (fresh build).

```sh
make ur.recipe-name
```

## Search Text on Recipes

To speed up your porting workflow you can use the `grep` tool to search the recipe configuration:

```sh
cd recipes
```

```sh
grep -rnwi "text" --include "recipe.toml"
```

This command will search all match texts in the `recipe.toml` files of each recipe folder.

## Search for functions on relibc

Sometimes your application is not building because relibc lack the necessary functions, to verify if they are implemented run the following commands:

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
b3sum recipes/your-category/recipe-name/source.tar
```

It will print the generated BLAKE3 hash, copy and paste on the `blake3 =` field of your `recipe.toml`

## Verify the size of your package

To verify the size of your package use this command:

```sh
ls -1sh recipes/your-category/recipe-name/target/$TARGET
```

See the size of the `stage.pkgar` and `stage.tar.gz` files.

## Submitting MRs

If you want to add your recipe on the [build system](https://gitlab.redox-os.org/redox-os/redox) to become a Redox package on the [build server](https://static.redox-os.org/pkg/), read the [package policy](#package-policy) below.

After this you can submit your merge request with proper category, dependencies and comments.
