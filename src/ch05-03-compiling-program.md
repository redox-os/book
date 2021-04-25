# Including a Program in a Redox Build

Thanks to redox' cookbook, building programs is a snap. This example walks
through setting up the hello world program that `cargo new` automatically
generates to be included in a build of the operating system (from source).
This process is largely the same for other rust programs and even non-rust
programs.

## Step One: Setting up the recipe

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

## Step Two: Writing the program

Since this is a hello world example, this step is very straightforward. Simply
create `cookbook/recipes/helloworld/source`. In that directory, run `cargo
init --name="helloworld"`.

For cargo projects that already exist, either include a URL to the git
repository in the recipe and let cookbook pull the sources automatically during
the first build, or simply copy the sources into the `source` directory.

## Step Three: Add the program to the redox build

To be able to access your program from redox, it must be added to the
filesystem. Open `filesystem.toml` and find the `[packages]` table. During the
filesystem build, the build system uses cookbook to package all the
applicationsin this table, and then installs those packages to the new
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
directory, it is nessesary to `touch filesystem.toml` before running `make qemu`.


## Step Three: Running your program

Go up to your `redox/` directory and run `make all`. Once it finishes running,
run `make qemu`, log in to redox, open the terminal, and run `helloworld`.
It should print

```shell
Hello, world!
```

Note that the `helloworld` binary can be found in `file:/bin` in the VM (`ls
file:/bin`).
