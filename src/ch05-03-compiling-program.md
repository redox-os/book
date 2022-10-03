# Including a Program in a Redox Build

Redox's cookbook makes packaging a program to include in a build fairly
straightforward. First, we will show how to add an existing package for inclusion. Then we will show how to create a new program to be included.

## Existing Package

Redox has many frequently used packages that are available for inclusion. Each package has a recipe in the directory `cookbook/recipes/packagename`. Adding a package to your build is as simple as adding it to `config/$ARCH/myfiles.toml`, or whatever name you choose for your `.toml` configuration definition. Here we will add the `sodium` editor.

First, copy an existing configuration, then edit it.
```sh
$ cp config/x86_64/desktop.toml config/x86_64/myfiles.toml
$ gedit config/x86_64/myfiles.toml &
```

Add the package to the configuration.
```toml
[packages]
...
sodium = {}
```

And point the **FILESYSTEM_CONFIG** at your `.toml` configuration definition.
```sh
$ gedit mk/config.mk &
```
```toml
...
FILESYSTEM_CONFIG?=config/x86_64/myfiles.toml
```

And that's it! Sort of. Some packages may have dependencies, which will have their own recipes. You can look at the `recipe.toml` or `recipe.sh` file in the `cookbook/recipes/packagename` directory to see what dependencies exist for your package, and verify that you have a recipe for each dependency as well.

## Hello World

To create your own program to be included, you will need to create the recipe. This example walks through adding the "hello world"
program that `cargo new` automatically generates to a local build of the operating system.

This process is largely the same for other rust crates and even non-rust
programs.

### Step One: Setting up the recipe

The cookbook will only build programs that have a recipe defined in
`cookbook/recipes`. To create a recipe for hello world, first create a
directory `cookbook/recipes/helloworld`. Inside this directory create a file
`recipe.toml` and add these lines to it:

```toml
[build]
template = "cargo"
```

The `[build]` section defines how cookbook should build our project. There are
several templates but `"cargo"` should be used for rust projects.

Cookbook will fetch the sources for a program from a git or tarball URL
specified in the `[source]` section of this file if
`cookbook/recipes/program_name/source` does not exist, and will also fetch
updates when running `make fetch`.

For this example, there is no upstream URL to fetch the sources from, hence no
`[source]` section. Instead, we will simply develop in the `source` directory.

### Step Two: Writing the program

Since this is a hello world example, this step is very straightforward. Simply
create `cookbook/recipes/helloworld/source`. In that directory, run `cargo
init --name="helloworld"`.

For cargo projects that already exist, either include a URL to the git
repository in the recipe and let cookbook pull the sources automatically during
the first build, or simply copy the sources into the `source` directory.

### Step Three: Add the program to the redox build

To be able to access a program from within Redox, it must be added to the
filesystem. Open `redox/filesystem.toml` and find the `[packages]` table.
During the filesystem (re)build, the build system uses cookbook to package all
the applicationsin this table, and then installs those packages to the new
filesystem. Simply add `helloworld = {}` anywhere in this table.

```toml
[packages]
#acid = {}
#binutils = {}
contain = {}
coreutils = {}
#dash = {}
extrautils = {}
#
# 100+ omitted for brevity
#
pkgutils = {}
ptyd = {}
randd = {}
redoxfs = {}
#rust = {}
smith = {}
#sodium = {}
userutils = {}

# Add this line:
helloworld = {}
```

In order to rebuild the filesystem image to reflect changes in the `source`
directory, it is nessesary to run `touch filesystem.toml` before running make.

## Step Three: Running your program

Go up to your `redox/` directory and run `make all`. Once the rebuild is
finished, run `make qemu`, log in to Redox, open the terminal, and run
`helloworld`. It should print

```shell
Hello, world!
```

Note that the `helloworld` binary can be found in `file:/bin` in the VM (`ls
file:/bin`).

