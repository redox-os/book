# Including a Program in a Redox Build

Redox's cookbook makes packaging a program to include in a build fairly
straightforward. First, we will show how to add an existing program for inclusion. Then we will show how to create a new program to be included.

## Existing Package

Redox has many frequently used packages and programs that are available for inclusion. Each package has a recipe in the directory `cookbook/recipes/packagename`. Adding a package to your build is as simple as adding it to `config/$ARCH/myfiles.toml`, or whatever name you choose for your `.toml` configuration definition. Here we will add the `sodium` editor.

First, copy an existing configuration, then edit it.
```sh
$ cp config/x86_64/desktop.toml config/x86_64/myfiles.toml
$ gedit config/x86_64/myfiles.toml &
```

Look for the `[packages]` secion and add the package to the configuration.
```toml
...
[packages]
...
sodium = {}
...
```

And point the `FILESYSTEM_CONFIG` variable in `mk/config.mk` at your `.toml` configuration definition.
```sh
$ gedit mk/config.mk &
```
```toml
...
FILESYSTEM_CONFIG?=config/x86_64/myfiles.toml
...
```

And that's it! Sort of. Some packages may have dependencies, which will have their own recipes. You can look at the `recipe.toml` or `recipe.sh` file in the `cookbook/recipes/packagename` directory to see what dependencies exist for your package, and verify that you have a recipe for each dependency as well. Some packages may also require libraries such as `sdl` or build tools such as `ninja-build`. Make sure you install those required items. See [Install Prerequisite Packages](./ch02-07-advanced-build.html#install-pre-requisite-packages-and-emulators) for examples.

### Modifying an Existing Package

If you want to make contributions to an existing Redox package, you can do your work in the directory `cookbook/recipes/packagename/source`. The cookbook process will not fetch sources if they are already present in that folder.

## Create your own - Hello World

To create your own program to be included, you will need to create the recipe. This example walks through adding the "hello world"
program that `cargo new` automatically generates to a local build of the operating system.

This process is largely the same for other Rust crates and even non-Rust programs.

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
several templates but `"cargo"` should be used for Rust projects.

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
filesystem. As [above](#existing-package), create a filesystem config `config/x86_64/myfiles.toml` or similar by copying an existing configuration, and modify `FILESYSTEM_CONFIG` in `mk/config.mk` to refer to it. Open `config/x86_64/myfiles.toml` and add `helloworld = {}` to the `[packages]` section.
During the filesystem (re)build, the build system uses cookbook to package all
the applications in this table, and then installs those packages to the new
filesystem.

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
directory, it may be necessary to run `touch config/x86_64/myfiles.toml` before running make.

## Step Four: Running your program

Go up to your working directory root, e.g. `~/tryredox/redox`, and run `make all`. Once the rebuild is
finished, run `make qemu`, and when the GUI starts, log in to Redox, open the terminal, and run
`helloworld`. It should print

```shell
Hello, world!
```

Note that the `helloworld` binary can be found in `/bin` on Redox (`ls file:/bin`).

