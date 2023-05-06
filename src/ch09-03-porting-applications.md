# Porting Applications using Recipes

The [Including Programs in Redox](./ch09-01-including-programs.md) page explain how to port/modify pure Rust programs, here we will explain the advanced way to port Rust programs, mixed Rust programs (Rust + C/C++ libraries, for example) and C/C++ programs.

(Before reading this page you **must** read the [Understanding Cross-Compilation for Redox](./ch08-01-advanced-build.md#understanding-cross-compilation-for-redox) and [Build System Quick Reference](./ch08-06-build-system-reference.md) pages)

Create a folder in `cookbook/recipes` with a file named as `recipe.toml` inside, we will edit this file to fit the program needs.

- Commands example:
```sh
cd ~/tryredox/redox
mkdir cookbook/recipes/program_example
nano cookbook/recipes/program_example/recipe.toml
```

Your `recipe.toml` file will look like this:

```
[source]
git = "software-repository-link.git"
branch = "branch-name"
tar = "software-tarball-link.tar.gz"
patches = [
    "patch1.patch",
    "patch2.patch",
]
[build]
template = "name"
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
- Don't remove/forget the `[build]` section (`[source]` section can be removed if you don't use `git =` and `tar =`).
- Insert `git =` to clone your software repository, if it's not available the build system will build the contents inside the `source` folder on recipe directory.
- Insert `branch =` if your want to use other branch.
- Insert `tar =` to download/extract tarballs, this can be used instead of `git =`.
- Insert `patches =` to use patch files, they need to be in the same directory of `recipe.toml` (not needed if your program compile/run without patches).
- Insert `dependencies =` if your software have dependencies, to make it work your dependencies/libraries need their own recipes (if your software doesn't need this, remove it from your `recipe.toml`).
- Insert `script =` to run your custom script (`script =` is enabled when you define your `template =` as `custom`).

Note that there are two `dependencies =`, one below the `[build]` section and other below `[package]` section.

- Below `[build]` - development libraries.
- Below `[package]` - runtime dependencies (data files).

All recipes are [statically compiled](https://en.wikipedia.org/wiki/Static_build), thus you don't need to package libraries and applications separated for binary linking, improving security and simplifying the configuration/packaging.

- [Understanding Cross-Compilation for Redox](./ch08-01-advanced-build.md#understanding-cross-compilation-for-redox)

## Cookbook Templates

The template is the type of the program/library build system, programs using an Autotools build system will have a `configure` file on the root of the repository/tarball source, programs using CMake build system will have a `CMakeLists.txt` file with all available CMake flags and a `cmake` folder, programs using Meson build system will have a `meson.build` file, Rust programs will have a `Cargo.toml` file.

- `template = "cargo"` - compile with `cargo` (Rust programs, you can't use the `script =` field).
- `template = "configure"` - compile with `configure` and `make` (you can't use the `script =` field).
- `template = "custom"` - run your custom `script =` field and compile (Any build system/installation process).

The `script =` field runs shell commands, to find the Cookbook shell commands, read the [source code](https://gitlab.redox-os.org/redox-os/cookbook/-/tree/master/src).

## Dependencies

Most C/C++/mixed Rust softwares place build system dependencies together with his own dependencies (development libraries), if you see the "Build Instructions" of most software, you will notice that it have packages without the `-dev` prefix and `-dev` packages (pure Rust programs don't use C/C++ libraries but his crates can use).

Install the packages for your Linux distribution on the "Build Instructions" of the software, see if it compiles on your Linux first (if packages for your distribution is not available, search for Debian/Ubuntu equivalents).

The packages without the `-dev` prefix can be runtime dependencies (linked at runtime) or build system dependencies (necessary to configure the compilation process), you will need to test this, feel free to ask us on [Chat](./ch13-01-chat.md).

We recommend that you add the `-dev` dependencies first, generally the Linux distribution package web interface place the library official website on package page (you can use the Debian testing [packages list](https://packages.debian.org/testing/allpackages) to search them with `Ctrl+F`, all package names are clickable and the homepage of them is available on the right side of the package description/details), inside the dependency website you will copy the tarball link or Git repository link and paste on your `recipe.toml`, according to TOML syntax (`tar = "link"` or `git = "link"`).

Create a recipe for each dependency and add inside of your main recipe `dependencies = []` section (`"recipe-name",`).

Run `make r.recipe-name` and see if it don't give errors, if it give an error it can be a dependency that require patches or missing runtime/build system dependencies, try to investigate both methods until the software compile successfully.

If you run `make r.recipe-name` and it compile successfully with just `-dev` recipes, feel free to add the packages without the `-dev` prefix on the [bootstrap.sh](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/bootstrap.sh) script or [redox-base-containerfile](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/podman/redox-base-containerfile) for Podman builds.

The `bootstrap.sh` script and `redox-base-containerfile` covers the build system packages needed by the recipes on [demo.toml](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/config/x86_64/demo.toml)

(You need to do this because each software is different, the major reason is "Build Instructions" organization)

## Testing/Building

(Compile on your Linux distribution before this step to see if all build system dependencies and software libraries are correct)

To build your recipe, run - `make r.recipe-name`

If you want to insert this recipe permanently in your QEMU image add your recipe name below the last item in `[packages]` on your TOML config (`config/x86_64/desktop.toml`, for example).

- Example - `recipe-name = {}` or `recipe-name = "recipe"` (if you have `REPO_BINARY=1` in your `.config`).

To install your compiled recipe on QEMU image, run `make image`.

If you had a problem, use this command to log any possible errors on your terminal output:
```sh
make r.recipe-name 2>&1 | tee recipe-name.log
```

The recipe sources will be extracted/cloned on the `source` folder inside of your recipe folder, the binaries go to `target` folder.

## Cleanup

If you have some problems (outdated recipe), try to run these commands:

- `make c.recipe` - it will wipe your old recipe binary.
- `scripts/rebuild-recipe.sh recipe-name` - it will delete your recipe source/binary and compile (fresh build).
