# Including Programs in Redox

Redox's **Cookbook** toolchain makes packaging a program to include in a build fairly
straightforward. First, we will show how to add an existing program for inclusion. Then we will show how to create a new program to be included. In [Coding and Building](./ch09-02-coding-and-building.md), we discuss the development cycle in more detail.

The Cookbook build system uses [TOML](https://toml.io/en/) file format for configuration files, these are the available templates for your `recipe.toml` files:

- `template = "cargo"` - compile with `cargo` (Rust programs).
- `template = "configure"` - compile with `configure` and `make`.
- `template = "custom"` - run your custom script `script =` and compile.

## Existing Package

Redox has many frequently used packages and programs that are available for inclusion. Each package has a recipe in the directory `cookbook/recipes/packagename`. Adding an existing package to your build is as simple as adding it to `config/$ARCH/myfiles.toml`, or whatever name you choose for your `.toml` configuration definition. Here we will add the `games` package, which contains several low-def games.

### Set up the Redox Build Environment

- Follow the steps in [Building Redox](./ch02-05-building-redox.md) or [Podman Build](./ch02-06-podman-build.md) to create the Redox Build Environment on your host computer.
- Check that `CONFIG_NAME` in `mk/config.mk` is `desktop`.
- Build the system as described. This will take quite a while the first time.
- Run the system in **QEMU**.
  ```sh
  cd ~/tryredox/redox
  make qemu
  ```
  Assuming you built the default configuration `desktop` for `x86_64`, none of the Redox games (e.g. `/bin/minesweeper`) have been included yet.
- On your Redox emulation, log into the system as user `user` with an empty password.
- Open a `Terminal` window by clicking on the icon in the toolbar at the bottom of the Redox screen, and type `ls /bin`. You will see that `minesweeper` **is not** listed.
- Type `Ctrl-Alt-G` to regain control of your cursor, and click the upper right corner of the Redox window to exit QEMU.

### Set up your Configuration

Read through [Configuration Settings](./ch02-07-configuration-settings.md). Then do the following.
- From your `redox` base directory, copy an existing configuration, then edit it.
  ```sh
  cd ~/tryredox/redox
  cp config/x86_64/desktop.toml config/x86_64/myfiles.toml
  gedit config/x86_64/myfiles.toml &
  ```
- Look for the `[packages]` secion and add the package to the configuration. You can add the package anywhere in the `[packages]` section, but by convention, we add them to the end or to an existing related area of the section.
  ```toml
  ...
  [packages]
  ...
  uutils = {}

  # Add this line:
  games = {}
  ...
  ```

- Change your `CONFIG_NAME` in [.config](./ch02-07-configuration-settings.md#config) to refer to your `myfiles.toml` configuration definition.
  ```sh
  gedit .config &
  ```
  ```
  # Add this line:
  CONFIG_NAME?=myfiles
  ```
- Save all your changes and exit the editor.

### Build the System

- In your base `redox` folder, e.g. `~/tryredox/redox`, build the system and run it in **QEMU**.
  ```sh
  cd ~/tryredox/redox
  make all
  make qemu
  ```
- On your Redox emulation, log into the system as user `user` with an empty password.
- Open a `Terminal` window by clicking it on the icon in the toolbar at the bottom of the Redox screen, and type `ls /bin`. You will see that `minesweeper` **is** listed.
- In the terminal window, type `minesweeper`. Play the game using the arrow keys or `WSAD`,`space` to reveal a spot, `f` to flag a spot when you suspect a mine is present. When you type `f`, an `F` character will appear.

And that's it! Sort of. 

### Dependencies

Some packages may have dependencies, which will have their own recipes. You can look at the `recipe.toml` or `recipe.sh` file in the `cookbook/recipes/PACKAGE` directory to see what dependencies exist for your package, and verify that you have a recipe for each dependency as well. Some packages may also require libraries such as `sdl` or build tools such as `ninja-build`. Make sure you install those required items. See [Install Prerequisite Packages](./ch08-01-advanced-build.md#install-pre-requisite-packages-and-emulators)  or [Podman Adding Libraries](./ch08-02-advanced-podman-build.md#adding-libraries-to-the-build) for examples.

## Modifying an Existing Package

If you want to make changes to an existing Redox package for your own purposes, you can do your work in the directory `cookbook/recipes/PACKAGE/source`. The cookbook process will not fetch sources if they are already present in that folder. However, if you intend to do significant work or to contribute changes to Redox, please follow [Coding and Building](./ch09-02-coding-and-building.md).

## Create your own - Hello World

To create your own program to be included, you will need to create the recipe. This example walks through adding the "hello world"
program that `cargo new` automatically generates to a local build of the operating system.

This process is largely the same for other Rust crates and even non-Rust programs.

### Setting up the recipe

The cookbook will only build programs that have a recipe defined in
`cookbook/recipes`. To create a recipe for Hello World, first create a
directory `cookbook/recipes/helloworld`. Inside this directory create a file
`recipe.toml` and add these lines to it:

```toml
[build]
template = "cargo"
```

The `[build]` section defines how cookbook should build our project. There are
several templates but `"cargo"` should be used for Rust projects.

The `[source]` section of the recipe tells Cookbook how fetch the sources for a program from a git or tarball URL.
This is done if `cookbook/recipes/PACKAGE/source` does not exist, during `make fetch` or during the fetch step of `make all`. For this example, we will simply develop in the `source` directory, so no `[source]` section is necessary.

### Writing the program

Since this is a Hello World example, we are going to have Cargo write the code for us. In `cookbook/recipes/helloworld`, do the following:

```sh
mkdir source
cd source
cargo init --name="helloworld"
```

This creates a `Cargo.toml` file and a `src` directory with the Hello World program.

### Adding the program to the Redox build

To be able to access a program from within Redox, it must be added to the
filesystem. As [above](#existing-package), create a filesystem config `config/x86_64/myfiles.toml` or similar by copying an existing configuration, and modify `CONFIG_NAME` in [.config](./ch02-07-configuration-settings.md#config) to be `myfiles`. Open `config/x86_64/myfiles.toml` and add `helloworld = {}` to the `[packages]` section.
During the creation of the Redox image, the build system installs those packages on the image filesystem.

```toml
[packages]
userutils = {}
...
# Add this line:
helloworld = {}
```

Then, to build the Redox image, including your program, go to your `redox` base directory and run `make rebuild`.
```sh
cd ~/tryredox/redox
make rebuild
```

## Running your program

Once the rebuild is finished, run `make qemu`, and when the GUI starts, log in to Redox, open the terminal, and run `helloworld`. It should print

```
Hello, world!
```

Note that the `helloworld` binary can be found in `/bin` on Redox (`ls file:/bin`).

