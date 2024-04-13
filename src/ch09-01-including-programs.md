# Including Programs in Redox

(Before reading this page you must read the [Build System Quick Reference](./ch08-06-build-system-reference.md) page)

This page will teach you how to add programs on the Redox image, it's a simplified version of the [Porting Applications using Recipes](./ch09-03-porting-applications.md) page.

- [Existing Recipe](#existing-recipe)
  - [Setup the Redox Build Environment](#setup-the-redox-build-environment)
  - [Setup Your Configuration](#setup-your-configuration)
  - [Build the System](#build-the-system)
  - [Dependencies](#dependencies)
  - [Update crates](#update-crates)
- [Using a Script](#using-a-script)
  - [Pre-script](#pre-script)
  - [Post-script](#post-script)
- [Modifying an Existing Recipe](#modifying-an-existing-recipe)
- [Create Your Own Hello World](#create-your-own-hello-world)
  - [Setting up the recipe](#setting-up-the-recipe)
  - [Writing the program](#writing-the-program)
  - [Adding the program to the Redox image](#adding-the-program-to-the-redox-image)
- [Running your program](#running-your-program)

The Cookbook system makes the packaging process very simple. First, we will show how to add an existing program for inclusion. Then we will show how to create a new program to be included. In [Coding and Building](./ch09-02-coding-and-building.md), we discuss the development cycle in more detail.

## Existing Package

Redox has many programs that are available for inclusion. Each program has a recipe in the directory `cookbook/recipes/recipe-name`. Adding an existing program to your build is as simple as adding it to `config/$ARCH/myfiles.toml`, or whatever name you choose for your `.toml` configuration definition. Here we will add the `games` package, which contains several terminal games.

### Setup the Redox Build Environment

- Follow the steps in [Building Redox](./ch02-05-building-redox.md) or [Podman Build](./ch02-06-podman-build.md) to create the Redox Build Environment on your system.
- Build the system as described. This will take quite a while the first time.
- Run the system in **QEMU**.

```sh
cd ~/tryredox/redox
```

```sh
make qemu
```

Assuming you built the default configuration `desktop` for `x86_64`, none of the Redox games (e.g. `/usr/bin/minesweeper`) have been included yet.

- On your Redox emulation, log into the system as user `user` with an empty password.
- Open a `Terminal` window by clicking on the icon in the toolbar at the bottom of the Redox screen, and type `ls /usr/bin`. You will see that `minesweeper` **is not** listed.
- Type `Ctrl-Alt-G` to regain control of your cursor, and click the upper right corner of the Redox window to exit QEMU.

### Setup your Configuration

Read the [Configuration Settings](./ch02-07-configuration-settings.md) page and follow the commands below.

- From your `redox` base directory, copy an existing configuration and edit it.

```sh
cd ~/tryredox/redox
```

```sh
cp config/x86_64/desktop.toml config/x86_64/myfiles.toml
```

```sh
nano config/x86_64/myfiles.toml
```

- Look for the `[packages]` secion and add the package to the configuration. You can add the package anywhere in the `[packages]` section, but by convention, we add them to the end or to an existing related area of the section.

```toml
...
[packages]
# Add the item below under the "[packages]" section
games = {}
...
```

- Add the `CONFIG_NAME` environment variable on your [.config](./ch02-07-configuration-settings.md#config) to use the `myfiles.toml` configuration.

```sh
nano .config
```

```
# Add the item below
CONFIG_NAME?=myfiles
```

- Save your changes with Ctrl+X and confirm with `y`

### Build the System

- In your base `redox` folder, e.g. `~/tryredox/redox`, build the system and run it in **QEMU**.

```sh
cd ~/tryredox/redox
```

```sh
make all
```

```sh
make qemu
```

Or

```sh
cd ~/tryredox/redox
```

```sh
make all qemu
```

- On your Redox emulation, log into the system as user `user` with an empty password.
- Open a `Terminal` window by clicking it on the icon in the toolbar at the bottom of the Redox screen, and type `ls /usr/bin`. You will see that `minesweeper` **is** listed.
- In the terminal window, type `minesweeper`. Play the game using the arrow keys or `WSAD`,`space` to reveal a spot, `f` to flag a spot when you suspect a mine is present. When you type `f`, an `F` character will appear.

If you had a problem, use this command to log any possible errors on your terminal output:

```sh
make r.recipe-name 2>&1 | tee recipe-name.log
```

And that's it! Sort of. 

### Dependencies

Read [this](./ch09-03-porting-applications.md#dependencies) section to learn how to handle recipe dependencies.

### Update crates

Read [this](./ch09-03-porting-applications.md#update-crates) to learn how to update crates on Rust programs.

## Modifying an Existing Recipe

If you want to make changes to an existing recipe for your own purposes, you can do your work in the directory `cookbook/recipes/recipe-name/source`. The Cookbook process will not download sources if they are already present in that folder. However, if you intend to do significant work or to contribute changes to Redox, please read the [Coding and Building](./ch09-02-coding-and-building.md) page.

## Create Your Own Hello World

To create your own program to be included, you will need to create the recipe. This example walks through adding the "Hello World" program that the `cargo new` command automatically generates to the folder of a Rust project.

This process is largely the same for other Rust programs.

### Setting Up The Recipe

The Cookbook will only build programs that have a recipe defined in
`cookbook/recipes`. To create a recipe for the Hello World program, first create the directory `cookbook/recipes/hello-world`. Inside this directory create the "recipe.toml" file and add these lines to it:

```toml
[build]
template = "cargo"
```

The `[build]` section defines how Cookbook should build our project. There are
several templates but `"cargo"` should be used for Rust projects.

The `[source]` section of the recipe tells Cookbook how to download the Git repository/tarball of the program.

This is done if `cookbook/recipes/recipe-name/source` does not exist, during `make fetch` or during the fetch step of `make all`. For this example, we will simply develop in the `source` directory, so no `[source]` section is necessary.

### Writing the program

Since this is a Hello World example, we are going to have Cargo write the code for us. In `cookbook/recipes/hello-world`, do the following:

```sh
mkdir source
```

```sh
cd source
```

```sh
cargo init --name="hello-world"
```

This creates a `Cargo.toml` file and a `src` directory with the Hello World program.

### Adding the program to the Redox image

To be able to run a program inside of Redox, it must be added to the filesystem. As [above](#existing-package), create a filesystem config `config/x86_64/myfiles.toml` or similar by copying an existing configuration, and modify `CONFIG_NAME` in [.config](./ch02-07-configuration-settings.md#config) to be `myfiles`. Open `config/x86_64/myfiles.toml` and add `hello-world = {}` below the `[packages]` section.

During the creation of the Redox image, the build system installs those packages on the image filesystem.

```toml
[packages]
# Add the item below
hello-world = {}
```

To build the Redox image, including your program, run the following commands:

```sh
cd ~/tryredox/redox
```

```sh
make r.hello-world image
```

## Running your program

Once the rebuild is finished, run `make qemu`, and when the GUI starts, log in to Redox, open the terminal, and run `helloworld`. It should print

```
Hello, world!
```

Note that the `hello-world` binary can be found in `/usr/bin` on Redox.
