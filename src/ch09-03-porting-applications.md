# Porting Applications using Recipes

The [Including Programs in Redox](./ch09-01-including-programs.md) page explain how to create pure Rust program recipes, here we will explain how to create non-Rust programs or mixed Rust programs (Rust + C/C++ libraries, for example).

Create a folder in `cookbook/recipes` with a file named as `recipe.toml` inside, we will edit this file to fit the program needs.

- Commands example:
```
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
    "patch2.patch"
]
[build]
template = "name"
dependencies = [
    "library1",
    "library2"
]
script = """
insert your script here
"""
[package]
dependencies = [
    "runtime1",
    "runtime2"
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

- `template = "cargo"` - compile with `cargo` (pure/mixed Rust programs).
- `template = "configure"` - compile with `configure` and `make` (non-CMake programs).
- `template = "custom"` - run your custom script `script =` and compile (Any build system/installation process).

## Testing/Building

To build your recipe, run - `make r.recipe-name`

If you want to insert this recipe permanently in your QEMU image add your recipe name below the last item in `[packages]` on your TOML config (`config/x86_64/desktop.toml`, for example).

- Example - `recipe-name = {}` or `recipe-name = "recipe"` (if you have `REPO_BINARY=1` in your `.config`).

To install your compiled recipe on QEMU image, run `make image`.

If you had a problem, use this command to log any possible errors on your terminal output:

- `make r.recipe-name 2>&1 | tee recipe-name.log`

## Cleanup

If you have some problems (outdated recipe), try to run these commands:

- `make c.recipe` - it will wipe your old recipe binary.
- `scripts/rebuild-recipe.sh recipe-name` - it will delete your recipe source/binary and compile (fresh build).
