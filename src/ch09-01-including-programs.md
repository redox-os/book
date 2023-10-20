# Including Programs in Redox

(Before reading this page you must read the [Build System Quick Reference](./ch08-06-build-system-reference.md) page)

- [Existing package](#existing-package)
  - [Set up the Redox Build Environment](#set-up-the-redox-build-environment)
  - [Set up your Configuration](#set-up-your-configuration)
  - [Build the System](#build-the-system)
  - [Dependencies](#dependencies)
  - [Update crates](#update-crates)
- [Using a Script](#using-a-script)
  - [Pre-script](#pre-script)
  - [Post-script](#post-script)
- [Modifying an Existing Package](#modifying-an-existing-package)
- [Create your own - Hello World](#create-your-own---hello-world)
  - [Setting up the recipe](#setting-up-the-recipe)
  - [Writing the program](#writing-the-program)
  - [Adding the program to the Redox build](#adding-the-program-to-the-redox-build)
- [Running your program](#running-your-program)

The Cookbook system makes the packaging process very simple. First, we will show how to add an existing program for inclusion. Then we will show how to create a new program to be included. In [Coding and Building](./ch09-02-coding-and-building.md), we discuss the development cycle in more detail.

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
Or

```sh
cd ~/tryredox/redox
make all qemu
```

- On your Redox emulation, log into the system as user `user` with an empty password.
- Open a `Terminal` window by clicking it on the icon in the toolbar at the bottom of the Redox screen, and type `ls /bin`. You will see that `minesweeper` **is** listed.
- In the terminal window, type `minesweeper`. Play the game using the arrow keys or `WSAD`,`space` to reveal a spot, `f` to flag a spot when you suspect a mine is present. When you type `f`, an `F` character will appear.

If you had a problem, use this command to log any possible errors on your terminal output:

- `make r.recipe-name 2>&1 | tee recipe-name.log`

And that's it! Sort of. 

### Dependencies

The majority of Rust programs use crates without C/C++ dependencies (Build Instructions without Linux distribution packages), on these cases you just need to port the necessary crates (if they give errors) or implement missing stuff on `relibc` (you will need to update the Rust `libc` crate).

If the "Build Instructions" of the Rust program have Linux distribution packages to install, it's a mixed Rust/C/C++ program, read [Dependencies](./ch09-03-porting-applications.md#dependencies) to port these programs.

### Update crates

In some cases the `Cargo.lock` of some Rust program can have a version of some crate that don't have Redox patches (old) or broken Redox support (changes on code that make the target OS fail), this will give you an error during the recipe compilation.

- [Update crates](./ch09-03-porting-applications.md#update-crates)

## Using a Script

The "script" template type executes shell commands. However, in order to keep scripts small, a lot of the script definition is done for you. [Pre-script](#pre-script) goes before your `script` content, and [Post-script](#post-script) goes after.

### Pre-script

```
# Add cookbook bins to path
export PATH="${COOKBOOK_ROOT}/bin:${PATH}"

# This puts cargo build artifacts in the build directory
export CARGO_TARGET_DIR="${COOKBOOK_BUILD}/target"

# This adds the sysroot includes for most C compilation
#TODO: check paths for spaces!
export CFLAGS="-I${COOKBOOK_SYSROOT}/include"
export CPPFLAGS="-I${COOKBOOK_SYSROOT}/include"

# This adds the sysroot libraries and compiles binaries statically for most C compilation
#TODO: check paths for spaces!
export LDFLAGS="-L${COOKBOOK_SYSROOT}/lib --static"

# These ensure that pkg-config gets the right flags from the sysroot
export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_PATH=
export PKG_CONFIG_LIBDIR="${COOKBOOK_SYSROOT}/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="${COOKBOOK_SYSROOT}"

# cargo template
COOKBOOK_CARGO="${COOKBOOK_REDOXER}"
COOKBOOK_CARGO_FLAGS=(
    --path "${COOKBOOK_SOURCE}"
    --root "${COOKBOOK_STAGE}"
    --locked
    --no-track
)
function cookbook_cargo {
    "${COOKBOOK_CARGO}" install "${COOKBOOK_CARGO_FLAGS[@]}"
}

# configure template
COOKBOOK_CONFIGURE="${COOKBOOK_SOURCE}/configure"
COOKBOOK_CONFIGURE_FLAGS=(
    --host="${TARGET}"
    --prefix=""
    --disable-shared
    --enable-static
)
COOKBOOK_MAKE="make"
COOKBOOK_MAKE_JOBS="$(nproc)"
function cookbook_configure {
    "${COOKBOOK_CONFIGURE}" "${COOKBOOK_CONFIGURE_FLAGS[@]}"
    "${COOKBOOK_MAKE}" -j "${COOKBOOK_MAKE_JOBS}"
    "${COOKBOOK_MAKE}" install DESTDIR="${COOKBOOK_STAGE}"
}
```

### Post-script

```
# Strip binaries
if [ -d "${COOKBOOK_STAGE}/bin" ]
then
    find "${COOKBOOK_STAGE}/bin" -type f -exec "${TARGET}-strip" -v {} ';'
fi

# Remove libtool files
if [ -d "${COOKBOOK_STAGE}/lib" ]
then
    find "${COOKBOOK_STAGE}/lib" -type f -name '*.la' -exec rm -fv {} ';'
fi

# Remove cargo install files
for file in .crates.toml .crates2.json
do
    if [ -f "${COOKBOOK_STAGE}/${file}" ]
    then
        rm -v "${COOKBOOK_STAGE}/${file}"
    fi
done
```

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

