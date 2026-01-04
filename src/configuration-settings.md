# Configuration Settings

The Redox build system applies configuration settings from various places to determine the final Redox image. Most of these settings ultimately come from the build system's [environment variables](#environment-variables) (or similarly-named Make variables) and the contents of the chosen [filesystem configuration](#filesystem-configuration) file.

- [Environment Variables](#environment-variables)
  - [.config](#config)
  - [Cookbook Configuration](#cookbook-configuration)
  - [Command Line](#command-line)
  - [mk/config.mk](#mkconfigmk)
  - [build.sh](#buildsh)
- [Filesystem Configuration](#filesystem-configuration)
  - [CPU Architecture Codenames](#cpu-architecture-codenames)
  - [Filesystem Size](#filesystem-size)
  - [Filesystem Customization](#filesystem-customization)
    - [Creating a custom filesystem configuration](#creating-a-custom-filesystem-configuration)
    - [Adding a package to the filesystem configuration](#adding-a-package-to-the-filesystem-configuration)
  - [Binary Packages](#binary-packages)
    - [REPO_BINARY](#repo_binary)
  - [Local Recipe Changes](#local-recipe-changes)
  - [Cookbook Offline Mode](#cookbook-offline-mode)

## Environment Variables

The default values for the build system's environment variables are mostly defined in the `mk` directory&mdash;particularly in [`mk/config.mk`](#mkconfigmk). Local changes from the default values, however, should be applied in the [`.config`](#config) file, or temporarily on the `make` [command line](#command-line).

The build system uses GNU Make and Cookbook to coordinate the build system in order. The [build system reference](./build-system-reference.md#cookbook) and [porting application guide](./porting-applications.md#cookbook) have more information about Cookbook.

Three important variables of interest are `ARCH`, `CONFIG_NAME`, and `BOARD`, as they specify the system to be built. These, and other important environment variables, can be seen in the following table:

| Variable | Definition |
|:---------|:-----------|
|`ARCH`| Specifies the [CPU architecture](#architecture-names) that the system is to be built for. The default value is `x86_64`. |
| `CONFIG_NAME` | Determines the name of the filesystem configuration, and is normally used to construct the `FILESYSTEM_CONFIG` name (the `desktop` variant is used by default). |
| `BOARD` | For single board computers such as Raspberry Pi 3B+ (`raspi3bp`) that require special configuration. Defaults to empty. |
| `FILESYSTEM_CONFIG` | Determines the filesystem configuration file location. See the [Filesystem Configuration](#filesystem-configuration) section below. The default value is `config/$ARCH/$BOARD/$CONFIG_NAME.toml` or `config/$ARCH/$CONFIG_NAME.toml` if `$BOARD` is empty, but this can be changed if the desired configuration file is in a different location. |
| `QEMU_MEM` | Sets the QEMU RAM memory quantity, e.g., `QEMU_MEM=2048`. |
| `QEMU_SMP` | Sets the QEMU CPU core quantity, e.g.,  `QEMU_SMP=4`. |
| `PREFIX_BINARY` | If set to 0 (`PREFIX_BINARY=0`), the build system will build the Redox toolchain from source and will not download the toolchain binaries from the Redox build server. |
| `PREFIX_USE_UPSTREAM_RUST_COMPILER` | If set to 1 (`PREFIX_BINARY=1`) the build system will download the Rust compiler from rustup (Rust upstream compiler binaries) instead of building it (only used with `PREFIX_BINARY=0`) |
| `REPO_BINARY` | If set to 1 (`REPO_BINARY=1`), the build system will download/install pre-compiled packages from the Redox package server by default, rather than build them from source (i.e., recipes). |
| `REPO_OFFLINE` | Enable the offline mode of Cookbook where recipe sources will not be updated and use less Internet connection as possible. |
| `REPO_NONSTOP` | Enable the nonstop mode of Cookbook where recipe build failure will not stop the compilation of other recipes. |
| `FILESYSTEM_SIZE` | The size in MB of the filesystem contained in the final Redox image. See the [Filesystem Size](#filesystem-size) section before changing it. |
| `REDOXFS_MKFS_FLAGS` | Flags to the program that builds the Redox filesystem. The `--encrypt` option enables disk encryption. |
| `PODMAN_BUILD` | If set to 0 (`PODMAN_BUILD?=0`), the build system will use the build environment from your Linux distribution or Unix-like system instead of Podman. See the [Native Build](./building-redox.md) page for more information. |
| `FSTOOLS_IN_PODMAN` | If set to 1 (`FSTOOLS_IN_PODMAN=1`), the build system will build the installer inside Podman to avoid FUSE in the host system. See the [Installing without FUSE](./advanced-podman-build.md#installing-without-fuse) page for more information. |
| `FSTOOLS_NO_MOUNT` | If set to 1 (`FSTOOLS_NO_MOUNT=1`), the installer will not use FUSE to create images. See the [Installing without FUSE](./advanced-podman-build.md#installing-without-fuse) section for more information. |
| `CONTAINERFILE` | The Podman container configuration file. See the [Podman Build](./podman-build.md) page for more information. |
| `COOKBOOK_MAKE_JOBS` | The number of maximum CPU cores used when building recipes, default is using all CPU cores from `nproc`. |
| `CI` | If set to any value (`CI=1`), the build system will not activate TUI, and parallel execution of the build step is disabled .|
| `COOKBOOK_LOGS` | A boolean option (`true`/`false`) to let the build system save build logs in `build/logs/$TARGET` directory. The default value is `true` if TUI is enabled, `false` otherwise. |
| `COOKBOOK_VERBOSE` | A boolean option (`true`/`false`) to print more information about the build process. The default value is `true`. |

The Redox image that is built is typically named `build/$ARCH/$CONFIG_NAME/harddrive.img` or `build/$ARCH/$CONFIG/livedisk.iso`.

### .config

The purpose of the `.config` file is to allow default configuration settings to be changed without explicitly setting those changes in every `make` command (or modifying the contents of the `mk` directory). The file is also included in the `.gitignore` list to ensure it won't be committed by accident.

To permanently override the settings in the [`mk/config.mk`](#mkconfigmk) section, add a `.config` file to the `redox` base directory (i.e., where `make` commands are run) and set the overriding values in that file.

For example, the following configuration specifies the `desktop-minimal` image variant will be built for the `i586` CPU architecture. These settings will be applied implicitly to all subsequent `make` commands:

```
ARCH?=i586
CONFIG_NAME?=desktop-minimal
```

> 📝 **Note:** Comments are supported using the `#` character
> 📝 **Note:** Any QEMU option can be inserted
> 📝 **Note:** if [`podman_bootstrap.sh`](./podman-build.md#new-working-directory) was run previously, the `.config` file may already exist.
> 💡 **Tip:** when adding environment variables in the `.config` file, don't forget the `?` symbol at the end of variable names. This allows the variable to be overridden on the command line or in the environment. In particular, `PODMAN_BUILD?=1` *must* include the question mark to function correctly.

### Cookbook Configuration

In addition to `.config`, `cookbook.toml` is a configuration file that is used by Cookbook and has more customization. Any configuration in this file will override configuration from `.config` or environment variables. The `cookbook.toml` configuration below can be used as a template:

```toml
# These options have defaults set below
#[cook]
#jobs = <nproc>
#nonstop = false
#offline = false
#tui = true
#logs = true
#verbose = true

[mirrors]
# The uncommented option below is the default if [mirrors] is not set
# see the list of GNU FTP mirrors at: https://www.gnu.org/prep/ftp.en.html
"ftp.gnu.org/gnu" = "mirrors.ocf.berkeley.edu/gnu"
# "github.com/foo/bar" = "github.com/baz/bar" 
```

The `cookbook.toml` file mainly configures Cookbook options (`[cook]`) and mirrors (`[mirror]`). Mirrors are used to replace code and binary sources used across Cookbook, useful for a quick way to use alternative sources when the main server is offline or slow. 

Each Cookbook configuration defaults to environment variables which are:

| Environment Variable | How to use the variable | Definition in cookbook.toml |
|:---------------------|:------------------------|:----------------------------|
|`CI` | `CI=1`, `CI=` | `cook.tui` (disables TUI if variable is set) |
|`COOKBOOK_MAKE_JOBS` |  `COOKBOOK_MAKE_JOBS=4` | `cook.jobs`|
|`COOKBOOK_LOGS`  | `COOKBOOK_LOGS=true` | `cook.logs`|
|`COOKBOOK_OFFLINE`  | `COOKBOOK_OFFLINE=true` (see notes) | `cook.logs`|
|`COOKBOOK_VERBOSE`  | `COOKBOOK_VERBOSE=false` (see notes) | `cook.verbose`|
|`COOKBOOK_NONSTOP`  | `COOKBOOK_NONSTOP=true` | `cook.nonstop`|

> 📝 **Note:** `REPO_OFFLINE=1` and `REPO_NONSTOP=1` are the recommended ways to set options instead of `COOKBOOK_OFFLINE=true` and `COOKBOOK_NONSTOP=true`
> 📝 **Note:** `.config` cannot be used to save `COOKBOOK_*` options as those are not Makefile variables, so you need to use `cookbook.toml` to make options persist
> 💡 **Tip:** Running Cookbook with `CI=1 COOKBOOK_LOGS=true COOKBOOK_NONSTOP=true COOKBOOK_VERBOSE=false` will hide successful build logs in the terminal
> 💡 **Tip:** Mirrors option can also be used to override [binary builds](#repo_binary) source URL.

#### Changing the QEMU CPU Core and Memory Quantity

For example, to change the CPU core and RAM memory quantities used when running the Redox image in QEMU, add the following environment variables to your `.config` file:

```
QEMU_SMP?=<number-of-threads>
QEMU_MEM?=<number-in-mb>
```

### Command Line

The default settings in `mk/config.mk` can be manually overridden by explicitly setting them on the `make` command line.

For example, the following command builds the `demo` image variant and loads it into QEMU:

```sh
make CONFIG_NAME=demo qemu
```

Some environment variables can also be set for the lifetime of the current shell by setting them at the command line:

```sh
export ARCH=i586; make all
```

Overriding settings in this way is only temporary, however. Additionally, for those using the [Podman Build](./podman-build.md), some settings may be ignored when using this method. For best results, use [`.config`](#config).

### mk/config.mk

The Redox build system uses several Makefiles, most of which are in the `mk` directory. Most settings of interest have have been grouped together in `mk/config.mk`.

Feel free to open `mk/config.mk` in your favorite editor and have a look through it; just be sure not to apply any changes:

```sh
nano mk/config.mk
```

The `mk/config.mk` file should never be modified directly, especially if you are contributing to the Redox project, as doing so could create conflicts in the `make pull` command.

To apply lasting changes to environment variables, please refer to the [`.config`](#config) section. To apply changes only *temporarily*, see the [Command Line](#command-line) section.

#### build.sh

The `build.sh` script allows you to easily set `ARCH`, `FILESYSTEM_CONFIG` and `CONFIG_NAME` when running `make`. If you are not changing the values very often, it is recommended that you set the values in [`.config`](#config) rather than use `build.sh`. But if you are testing against different CPU architectures or configurations, this script can help minimize effort, errors and confusion.

```sh
./build.sh [-a <ARCH>] [-c <CONFIG_NAME>] [-f <FILESYSTEM_CONFIG>] <TARGET> ...
```

The `TARGET` parameter may be any valid `make` target, although the recommended target is `qemu`. Additional variable settings may also be included, such as `gpu=no`

| Option | Description |
|:-------|:------------|
| `-a <ARCH>` | The CPU architecture you are building for, `x86_64`, `i586`, `aarch64` or `riscv64gc`. Uppercase options `-X`, `-5`, `-A`, `-R` can be used as shorthands for `-a x86_64`, `-a i586`, `-a aarch64` and `riscv64gc`, respectively. |
| `-c <CONFIG_NAME>` | The name of the filesystem configuration which appears in the name of the image being built. |
| `-f <FILESYSTEM_CONFIG>` | Determines the filesystem configuration file location, which can be in any location but is normally in directory `config/$ARCH`.<br><br>📝 **Note:** If you *do* specify `-f <FILESYSTEM_CONFIG>`, but not `-a` or `-c`, the file path determines the other values. Normally the file would be located at e.g., `config/x86_64/desktop.toml`. `ARCH` is determined from the second-to-last element of the path. If the second last element is not a known `ARCH` value, you must specify `-a ARCH`. `CONFIG_NAME` is determined from the *basename* of the file. |

The default value of `FILESYSTEM_CONFIG` is constructed from `ARCH` and `CONFIG_NAME`: `config/$ARCH/$CONFIG_NAME.toml`.

The default values for `ARCH` and `CONFIG_NAME` are `x86_64` and `desktop`, respectively. These produce a default `FILESYSTEM_CONFIG` value of `config/x86_64/desktop.toml`.

## Filesystem Configuration

The packages to be included in the final Redox image are determined by the chosen **filesystem configuration** file, which is a `.toml` file (e.g., `config/x86_64/desktop.toml`). Open `desktop.toml` and have a look through it:

```sh
nano config/x86_64/desktop.toml
```

For each supported CPU architecture, there are some filesystem configurations to choose from. For `x86_64`, there are `desktop`, `demo` and `server` configurations, as well as a few others. For `i586`, there are also some stripped down configurations for embedded devices or legacy systems with minimal RAM. Feel free to browse the `config/x86_64` directory for more examples.

For more details on the filesystem configuration, and how to add additional packages to the build image, please see the [Including Programs in Redox](./including-programs.md) page.

Feel free to create your own **filesystem configuration**.

### CPU Architecture Codenames

The Redox build system supports cross-compilation to other CPU architectures. The CPU architecture that Redox is built for (specified by the `ARCH` environment variable) usually determines the filesystem configuration file that will be used by the build system.

See the currently supported CPU architectures by Redox below:

| CPU Architecture | Other Aliases |
|:---------------- |:----------- |
| `i586` | x86 (32-bit), IA32 , `x86` |
| `x86_64` | x86 (64-bit), `x86-64`, `amd64`, `x64` |
| `aarch64` | ARM (64-bit), ARMv8, `ARM64` |
| `riscv64gc` | RISC-V (64-bit) |

The filesystem configurations for a given CPU architecture can be found in the [`config`](https://gitlab.redox-os.org/redox-os/redox/-/tree/master/config) folder's correspondingly named sub-directory (e.g. `config/x86_64`).

### Filesystem Size

The filesystem size is the total amount of storage space allocated for the filesystem that is built into the image, including all programs. It is specified in Megabytes (MB). The typical size is 512MB, although some configs (e.g., `demo`) are larger. The filesystem must be large enough to accommodate the packages included in the filesystem. For a *livedisk* system, the filesystem must not exceed the size of your system's RAM, and must also leave room for the package's installation and system execution.

The filesystem size is normally set from the **filesystem configuration** file, e.g. `config/x86_64/demo.toml`.

```toml
[general]
...
filesystem_size = 768
...
```

To change this, it is recommended that you create your own filesystem configuration and apply changes there. However, this can be temporarily overridden on the `make` command line, e.g.:

```sh
make FILESYSTEM_SIZE=512 image qemu
```

> ⚠️ **Warning:** setting the `filesystem_size` value too low will produce an error resembling the following:
> 
> ```
> thread 'main' panicked at src/lib.rs:94:53:
> called `Result::unwrap()` on an `Err` value: Error(Path("/tmp/redox_installer_759506/include/openssl/.pkgar.srtp.h"), State { next_error: Some(Os { code: 28, kind: StorageFull, message: "No space left on device" }), backtrace: InternalBacktrace { backtrace: None } })
> ```

### Filesystem Customization

The Redox image can be customized by tweaking the configuration files at `config/your-cpu/*.toml`. However, it is recommended that you create your own configuration file and apply changes there.
(The configuration files at `config/your-cpu` can override the data type values from the filesystem templates at `config`)

#### Creating a custom filesystem configuration

The following items describe the process for creating a custom filesystem configuration file (`my-desktop.toml`):

1. Create the `my-desktop.toml` file from an existing filesystem configuration:

    ```sh
    cp config/your-cpu-arch/desktop.toml config/your-cpu-arch/my_desktop.toml
    ```

2. Add the following to the `.config` file to set the new configuration as the build system's default:

    ```
    CONFIG_NAME?=my_desktop
    ```

Many filesystem configuration settings can be adjusted. See the templates in the `config` folder for reference.

> 💡 **Tip:** files named with the prefix "`my-`" in the `redox` repo are git-ignored. Be sure to follow this convention for all custom filesystem configurations to avoid accidentally committing them to the Redox project.

#### Adding a package to the filesystem configuration

In the following example, the `acid` package is added to the `my_desktop.toml` configuration:

1. Open the `my-desktop.toml` file:

    ```sh
    nano config/your-cpu/my-desktop.toml
    ```

2. Add the `acid` package to the `[packages]` section:

    ```toml
    [packages]
    acid = {}
    ```

3. Build the `acid` package and update the Redox image:

    ```sh
    make rp.acid
    ```

Done! The `acid` package is now included in your Redox image.

### Binary Packages

By default, the Redox build system builds all packages from source (i.e., recipes). If you want to use [pre-compiled packages](https://static.redox-os.org/pkg/) from our build server, however, there's a TOML option for it.

This is useful for some purposes, such as producing development builds, confirming package status from the Redox package server, and reducing image build time with large programs.

1. Open the `my-desktop.toml` file:

    ```sh
    nano config/your-cpu/my-desktop.toml
    ```

2. Add the binary package below the `[packages]` section:

    ```toml
    [packages]
    ...
    new-package = "binary"
    ...
    ```

3. Download and add the binary package on your Redox image:

    ```sh
    make image
    ```

4. Open QEMU to verify your binary package:

    ```sh
    make qemu
    ```

#### REPO_BINARY

In the previous example, the build system's default behavior was overridden by explicitly setting a package to use a pre-built binary. To configure the build system to download pre-built packages by *default*, however, we can set the `REPO_BINARY` environment variable (`REPO_BINARY?=1`).

When `REPO_BINARY` is enabled, the Redox image is made to use pre-built binaries for all packages assigned to `{}`; when `REPO_BINARY` is *disabled*, however, those same packages are compiled from source (i.e., recipes).

For example:

```toml
[packages]
...
package-name1 = {} # use the REPO_BINARY setting ("source" if 0; "binary" if 1)
package-name2 = "binary" # pre-built package
package-name3 = "source" # source-based recipe
...
```

### Local Recipe Changes

By default every time a recipe build is triggered Cookbook will update the recipe source. Cookbook will check the tarball BLAKE3 hash from the recipe configuration (`recipe.toml`), or pull from the `origin` remote when the recipe source is a Git repository. This will also remove local changes that are not saved in a branch.

To preserve and use local changes and skip updating the source for a specific recipe, change the recipe type to `"local"` in the filesystem configuration, for example:

```toml
[packages]
...
package-name = "local"
...
```

An old way for preserving and using local changes by commenting out the `[source]` section at the top of the file of a `recipe.toml` is also working but less recommended as it's prone to merge conflicts when pulling Redox repository:

```toml
# [source]
# git = "https://gitlab.redox-os.org/redox-os/games.git"
```


### Cookbook Offline Mode

Cookbook also has a mode where it will reduce Internet activity by adding `REPO_OFFLINE=1` into `.config`. This mode is useful when you are in places where the Internet is slow or absent, or when you want a fixed build system state or faster incremental compilation.

In this mode, Cookbook will not update the source of any recipe or a package binary if also set with `REPO_BINARY=1`. It also adds the `--offline` option to some Cargo build methods inside recipes where it is supported. When Cookbook or Cargo must access the Internet because sources do not exist locally it will throw an error instead.

To temporarily allow Cookbook and Cargo to have Internet activity and update sources, run `make f.package-name` (single recipe source fetch) or `make fetch` (to fetch all enabled recipe sources), as these commands will ignore the `REPO_OFFLINE` environment variable.
