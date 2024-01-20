# Troubleshooting the Build

In case you need to do some troubleshooting of the build process, this is a brief overview of the Redox toolchain, with some troubleshooting tips. This chapter is a work in progress.

- [Setting Up](#setting-up)
    - [bootstrap.sh](#bootstrapsh)
    - [git clone](#git-clone)
- [Building the System](#building-the-system)
    - [.config and mk/config.mk](#config-and-mkconfigmk)
    - [Prefix](#prefix)
    - [Podman](#podman)
    - [Filesystem Config](#filesystem-config)
    - [Fetch](#fetch)
    - [Cookbook](#cookbook)
    - [Create the Image with  FUSE](#create-the-image-with-fuse)
- [Solving Compilation Problems](#solving-compilation-problems)
    - [Update your build system](#update-your-build-system)
    - [Update your branch](#update-your-branch)
    - [Update relibc](#update-relibc)
    - [Update crates](#update-crates)
    - [Verify the dependency tree](#verify-the-dependency-tree)
- [Debug Methods](#debug-methods)
    - [Recipes](#recipes)
        - [Rust](#rust)
- [Kernel Panics in QEMU](#kernel-panics-in-qemu)
    - [Kill the Frozen QEMU Process](#kill-the-frozen-qemu-process)

## Setting Up

### bootstrap.sh

When you run `bootstrap.sh` or `podman_bootstrap.sh`, the Linux tools and libraries required to support the toolchain and build process are installed. Then the `redox` project is cloned from the Redox GitLab. The `redox` project does not contain the Redox sources, it mainly contains the build system. The `cookbook` subproject, which contains recipes for all the packages to be included in Redox, is also copied as part of the clone.

Not all Linux distributions are supported by `bootstrap.sh`, so if you are on an unsupported distribution, try `podman_bootstrap.sh` for [Podman](https://podman.io/) builds, or have a look at [podman_bootstrap.sh](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/podman_bootstrap.sh) and try to complete the setup up manually.

If you want to support your distribution/OS without Podman, you can try to install the Debian/Ubuntu package equivalents for your distribution/OS from your package manager/software store, you can see them on [this](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/bootstrap.sh#L228) section of `bootstrap.sh`.

The `bootstrap.sh` script and `redox-base-containerfile` covers the build system packages needed by the recipes on [demo.toml](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/config/x86_64/demo.toml)

(Note that some distributions/OSes may have environment problems hard to fix, on these systems Podman will avoid some headaches)

### git clone

If you did not use `bootstrap.sh` or `podman_bootstrap.sh` to set up your environment, you can get the sources with:

```sh
git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive
```

If you are missing the `cookbook` project or other components, ensure that you used the `--recursive` flag when doing `git clone`. Ensure that all the libraries and packages required by Redox are installed by running `bootstrap.sh -d` or, if you will be using the Podman build, `podman_bootstrap.sh -d`.

## Building the System

When you run `make all`, the following steps occur.

### .config and mk/config.mk

- `make` scans [.config](./ch02-07-configuration-settings.md#config) and [mk/config.mk](./ch02-07-configuration-settings.md#mkconfigmk) for settings, such as the CPU architecture, config name, and whether to use **Podman** during the build process. Read through [Configuration Settings](./ch02-07-configuration-settings.md) to make sure you have the settings that are best for you.

### Prefix

The Redox toolchain, referred to as **Prefix** because it is prefixed with the architecture name, is downloaded and/or built. Custom versions of `cargo`, `rustc`, `gcc` and many other tools are created. They are placed in the `prefix` directory. 

If you have a problem with the toolchain, try `rm -rf prefix`, and everything will be reinstalled the next time you run `make all`.

### Podman

If enabled, the Podman environment is set up. [Podman](./ch02-06-podman-build.md) is recommended for distros other than Pop!_OS, Ubuntu and Debian.

If your build appears to be missing libraries, have a look at [Debugging your Podman Build Process](./ch02-06-podman-build.md#debugging-your-build-process).
If your Podman environment becomes broken, you can use `podman system reset` and `rm -rf build/podman`. In some cases, you may need to do `sudo rm -rf build/podman`.

If you have others problems with Podman, read the [Troubleshooting Podman](./ch08-02-advanced-podman-build.md#troubleshooting-podman) chapter.

### Filesystem Config

The list of Redox packages to be built is read from the [filesystem config](./ch02-07-configuration-settings.md#filesystem-config) file, which is specified in [.config](./ch02-07-configuration-settings.md#config) or `mk/config.mk`. If your package is not being included in the build, check that you have set `CONFIG_NAME` or `FILESYSTEM_CONFIG`, then check the config file.

### Fetch

Each recipe source is downloaded using `git` or `tar`, according to the `[source]` section of `cookbook/recipes/recipe-name/recipe.toml`. Source is placed in `cookbook/recipes/recipe-name/source`. Some recipes use the older `recipe.sh` format instead. 

If you are doing work on a recipe, you may want to comment out the `[source]` section of the recipe. To discard your changes to the source for a recipe, or to update to the latest version, uncomment the `[source]` section of the recipe, and use `rm -rf source target` in the recipe directory to remove both the source and any compiled code.

After all recipes are fetched, a tag file is created as `build/$ARCH/$CONFIG_NAME/fetch.tag`, e.g. `build/x86_64/desktop/fetch.tag`. If this file is present, fetching is skipped. You can remove it manually, or use `make rebuild`, if you want to force refetching.

### Cookbook

Each recipe is built according to the `recipe.toml` file. The compiled recipe is placed in the `target` directory, in a subdirectory named based on the CPU architecture. These tasks are done by various Redox-specific shell scripts and commands, including `repo.sh`, `cook.sh` and `Cargo`. These commands make assumptions about `$PATH` and `$PWD`, so they might not work if you are using them outside the build process.

If you have a problem with a package you are building, try `rm -rf target` in the recipe directory. A common problem when building on non-Debian systems is that certain packages will fail to build due to missing libraries. Try using [Podman Build](./ch02-06-podman-build.md).

After all packages are cooked, a tag file is created as `build/$ARCH/$CONFIG_NAME/repo.tag`. If this file is present, cooking is skipped. You can remove it manually, or use `make rebuild`, which will force refetching and rebuilding.

### Create the Image with FUSE

To build the final Redox image, `redox_installer` uses [FUSE](https://github.com/libfuse/libfuse), creating a virtual filesystem and copying the packages into it. This is done outside of Podman, even if you are using Podman Build.

On some Linux systems, FUSE may not be permitted for some users, or `bootstrap.sh` might not install it correctly. Investigate whether you can address your FUSE issues, or join the [chat](./ch13-01-chat.md) if you need advice.

## Solving Compilation Problems

- Check your Rust version (run `make env` and `cargo --version`, then `exit`), make sure you have **the latest version of Rust nightly!**.

    - [rustup.rs](https://www.rustup.rs) is recommended for managing Rust versions. If you already have it, run `rustup`.

- Verify if your `make` and `nasm` are up-to-date.
- Verify if the build system is using the latest commit by running the `git branch -v` command.
- Verify if the submodules are using the latest pinned commit, to do this run:

```sh
cd submodule-name
```

```sh
git branch -v
```

- Verify if the recipe source is using the latest commit of the default branch, to do this run:

```sh
cd cookbook/recipes/some-category/recipe-name/source
```

```sh
git branch -v
```

- Run `make clean pull` to remove all your compiled binaries and update the sources.
- Sometimes there are merge requests that briefly break the build, so check the [Chat](./ch13-01-chat.md) if anyone else is experiencing your problems.
- Sometimes both the source and the binary of some recipe is wrong, run `make ucr.recipe-name` and verify if it fix the problem.

    - Example:

    ```sh
    make ucr.recipe-name
    ```

### Update your build system

Sometimes your build system can be outdated because you forgot to run `make pull` before other commands, read [this](./ch08-06-build-system-reference.md#update-the-build-system) section to learn the complete way to update the build system.

In case of API changes on the source code or configuration changes on the build system you can use `make clean all` to wipe your binaries and build them again, if it doesn't work you need to download a new copy of the build system by running the `bootstrap.sh` script or using this command:

```sh
git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive
```

After that, run:

```sh
cd redox
```

```sh
make all
```

### Update your branch

If you are doing local changes on the build system, probably you left your branch active on the folder (instead of `master` branch).

New branches don't sync automatically with `master`, thus if the `master` branch receive new commits, you wouldn't use them because your branch is outdated.

To fix this, run:

```sh
git checkout master
```

```sh
git pull
```

```sh
git checkout your-branch
```

```sh
git merge master
```

Or

```sh
git checkout master
```

```sh
git pull
```

```sh
git merge your-branch master
```

If you want an anonymous merge, read [this](./ch09-02-coding-and-building.md#anonymous-commits).

### Update relibc

An outdated relibc copy can contain bugs (already fixed on recent versions) or outdated crates, read [this](./ch08-06-build-system-reference.md#update-relibc) section to learn how to update it.

### Update crates

Sometimes a Rust program use an old crate version lacking Redox support, read [this](./ch09-03-porting-applications.md#update-crates) section to learn how to update them.

### Verify the dependency tree

Some crates take a long time to do a new release (years in some cases), thus these releases will hold old versions of other crates, versions where the Redox support is not available (causing errors during the program compilation).

The `redox_syscall` crate is the most affected by this, some crates hold a very old version of it and will require patches (`cargo update -p` alone doesn't work).

To identify which crates are using old versions of Redox crates you will need to verify the dependency tree of the program, inside the program source directory, run:

```sh
cargo tree --target=x86_64-unknown-redox
```

This command will draw the dependency tree and you will need to find the crate name on the hierarchy.

If you don't want to find it, you can use a `grep` pipe to see all crate versions used in the tree, sadly `grep` don't preserve the tree hierarchy, thus it's only useful to see versions and if some patched crate works (if the patched crate works all crate matches will report the most recent version).

To do this, run:

```sh
cargo tree --target=x86_64-unknown-redox | grep crate-name
```

## Debug Methods


- Use the following command for advanced logging:

```sh
make some-command 2>&1 | tee file-name.log
```

- You can write to the `debug:` scheme, which will output on the console, but you must be `root`. This is useful if you are debugging an app where you need to use Orbital but still want to capture messages.

- Currently, the build system strips function names and other symbols from programs, as support for symbols is not implemented on Redox.

### Recipes

You will see the available debug methods for recipes on this section.

- If you change the recipe build mode (`release` to `debug` or the opposite) while debugging, don't forget to rebuild with `make cr.recipe-name` because the build system may not detect the changes.

#### Rust

Rust programs can carry assertions, checking and symbols, but they are disabled by default.

- `COOKBOOK_DEBUG` - This environment variable will build the Rust program with assertions, checking and symbols.
- `COOKBOOK_NOSTRIP` - This environment variable will package the recipe with symbols.

(Debugging with symbols inside of Redox is not supported yet)

To enable them you can use these commands or scripts:

- Enable the `COOKBOOK_DEBUG` environment variable for one command and build a recipe:

```sh
COOKBOOK_DEBUG=true make r.recipe-name
```

- Enable the `COOKBOOK_DEBUG` environment variable for multiple commands and build a recipe:

```sh
export COOKBOOK_DEBUG=true
make r.recipe-name
```

- Enable the `COOKBOOK_DEBUG` and `COOKBOOK_NOSTRIP` environment variables for one command and build a recipe:

```sh
COOKBOOK_DEBUG=true COOKBOOK_NOSTRIP=true make r.recipe-name
```

- Enable the `COOKBOOK_DEBUG` and `COOKBOOK_NOSTRIP` environment variables for multiple commands and build a recipe:

```sh
export COOKBOOK_DEBUG=true
export COOKBOOK_NOSTRIP=true
make r.recipe-name
```

- Enable the `COOKBOOK_DEBUG` environment variable inside the `recipe.toml`:

```toml
template = "custom"
script = """
COOKBOOK_DEBUG=true
cookbook_cargo
"""
```

- Enable the `COOKBOOK_DEBUG` and `COOKBOOK_NOSTRIP` environment variables inside the `recipe.toml`:

```toml
template = "custom"
script = """
COOKBOOK_DEBUG=true
COOKBOOK_NOSTRIP=true
cookbook_cargo
"""
```

- Backtrace

A backtrace helps you to detect bugs that happen with not expected input parameters, you can trace back through the callers to see where the bad data is coming from.

You can see how to use it below:

- Start QEMU with logging:

```sh
make qemu 2>&1 | tee file-name.log
```

- Enable this environment variable globally (on Redox):

```sh
export RUST_BACKTRACE=full
```

- Run the program and repeat the bug (capturing a backtrace in the log file)
- Close QEMU
- Open the log file, copy the backtrace and paste in an empty text file

- Run the `backtrace.sh` script in the `redox` directory (on Linux):

```sh
scripts/backtrace.sh -r recipe-name -b your-backtrace.txt
```

It will print the file and line number for each entry in the backtrace.

(This is the most simple example command, use the `-h` option of the `backtrace.sh` script to see more combinations)

## Kernel Panics in QEMU

If you receive a kernel panic in QEMU, capture a screenshot and send to us on [Matrix](./ch13-01-chat.md) or create an issue on [GitLab](https://gitlab.redox-os.org/redox-os/kernel/-/issues).

### Kill the Frozen QEMU Process

Run:

```sh
pkill qemu-system
```
