# Porting Applications using Recipes

The [Including Programs in Redox](./ch09-01-including-programs.md) page explain how to port/modify pure Rust programs, here we will explain the advanced way to port Rust programs, mixed Rust programs (Rust + C/C++ libraries, for example) and C/C++ programs.

(Before reading this page you **must** read the [Understanding Cross-Compilation for Redox](./ch08-01-advanced-build.md#understanding-cross-compilation-for-redox) and [Build System Quick Reference](./ch08-06-build-system-reference.md) pages)

## Recipe

A recipe is how we call a software port on Redox, on this section we will explain the recipe structure and things to consider.

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
rev = "commit-revision"
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
- Don't remove/forget the `[build]` section (`[source]` section can be removed if you don't use `git =` and `tar =` or have the `source` folder present on your recipe folder).
- Insert `git =` to clone your software repository, if it's not available the build system will build the contents inside the `source` folder on recipe directory.
- Insert `branch =` if your want to use other branch.
- Insert `rev =` if you want to use a commit revision (SHA1).
- Insert `tar =` to download/extract tarballs, this can be used instead of `git =`.
- Insert `patches =` to use patch files, they need to be in the same directory of `recipe.toml` (not needed if your program compile/run without patches).
- Insert `dependencies =` if your software have dependencies, to make it work your dependencies/libraries need their own recipes (if your software doesn't need this, remove it from your `recipe.toml`).
- Insert `script =` to run your custom script (`script =` is enabled when you define your `template =` as `custom`).

Note that there are two `dependencies =`, one below the `[build]` section and other below `[package]` section.

- Below `[build]` - development libraries.
- Below `[package]` - runtime dependencies (data files).

## Cookbook Templates

The template is the type of the program/library build system, programs using an Autotools build system will have a `configure` file on the root of the repository/tarball source, programs using CMake build system will have a `CMakeLists.txt` file with all available CMake flags and a `cmake` folder, programs using Meson build system will have a `meson.build` file, Rust programs will have a `Cargo.toml` file.

- `template = "cargo"` - compile with `cargo` (Rust programs, you can't use the `script =` field).
- `template = "configure"` - compile with `configure` and `make` (you can't use the `script =` field).
- `template = "custom"` - run your custom `script =` field and compile (Any build system/installation process).

The `script =` field runs any shell command, it's useful if the software use a script to build from source or need custom options that Cookbook don't support.

To find the supported Cookbook shell commands, look the recipes using a `script =` field on their `recipe.toml` or read the [source code](https://gitlab.redox-os.org/redox-os/cookbook/-/tree/master/src).

- [Recipes](https://gitlab.redox-os.org/redox-os/cookbook/-/tree/master/recipes)

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
```
[source]
git = "repository-link.git"
rev = "commit-revision-hash"
```
This same logic applies for every Git frontend and is more easy to find, manage and patch than tarballs.

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

All recipes are [statically compiled](https://en.wikipedia.org/wiki/Static_build), thus you don't need to package libraries and applications separated for binary linking, improving security and simplifying the configuration/packaging.

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

## Update crates

In some cases the `Cargo.lock` of some Rust program can have a version of some crate that don't have Redox patches (old) or broken Redox support (changes on code that make the target OS fail), this will give you an error during the recipe compilation.

The reason of fixed crate versions is explained [here](https://doc.rust-lang.org/cargo/faq.html#why-do-binaries-have-cargolock-in-version-control-but-not-libraries).

To fix this, update the crates of your recipe after the first compilation of the recipe and compile it again.

- Go to the `source` folder of your recipe and run `cargo update`, example:

```sh
cd cookbook/recipes/recipe-name/source
cargo update
make c.recipe-name
make r.recipe-name


## Cleanup

If you have some problems (outdated recipe), try to run these commands:

- `make c.recipe` - it will wipe your old recipe binary.
- `scripts/rebuild-recipe.sh recipe-name` - it will delete your recipe source/binary and compile (fresh build).

## Submitting MRs

If you want to add your recipe on [Cookbook](https://gitlab.redox-os.org/redox-os/cookbook) to become a Redox package on [CI server](https://static.redox-os.org/pkg/), you can submit your merge request with proper dependencies and comments.

We recommend that you make a commit for each new recipe and say the build dependencies on comments, it's preferable that you test it before the MR, but you can send it non-tested with a `#TODO` on the first line of the `recipe.toml` file.