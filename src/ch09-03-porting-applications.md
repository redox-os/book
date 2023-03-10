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
tar = "software-tarball-link.tar.gz"
patches = [
    "patch1.patch",
    "patch2.patch"
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
```
- Insert `git =` to clone your software repository, if it's not available the build system will build the contents inside the `source` folder on recipe directory.
- Insert `tar =` to download/extract tarballs, this can be used instead of `git =`.
- Insert `patches =` to use patch files, they need to be in the same directory of `recipe.toml` (not needed if your program compile/run without patches).
- Insert `dependencies =` if your software have dependencies, to make it work your dependencies/libraries need their own recipes (if your software doesn't need this, remove it from your `recipe.toml`).
- Insert `script =` to run your custom script (`script =` is enabled when you define your `template =` as `custom`).

## Cookbook Templates

- `template = "cargo"` - compile with `cargo` (Rust programs).
- `template = "configure"` - compile with `configure` and `make` (non-CMake programs).
- `template = "custom"` - run your custom script `script =` and compile (Any build system/installation process).
