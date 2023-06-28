# Configuration Settings

There are many configurable settings that affect what edition of Redox you build, and how you build it.

## mk/config.mk

The build system uses several makefiles, most of which are in the directory `mk`. We have grouped together most of the settings that might be interesting into `mk/config.mk`. However, it's not recommended that you change them there, especially if you are contributing to the Redox project. See [.config](#config) below.

Open `mk/config.mk` in your favorite editor and have a look through it (but don't change it), e.g.
```sh
gedit mk/config.mk &
```

## Environment and Command Line

You can temporarily override some of the settings in `mk/config.mk` by setting them either in your environment or on the `make` command line, e.g.
```sh
make CONFIG_NAME=demo qemu
```

Overriding the settings in this way is only temporary. Also, if you are using [Podman Build](./ch02-06-podman-build.md), some settings may be ignored, so you are best to use [.config](#config).

## .config

To permanently override any of the settings in [mk/config.mk](#mkconfigmk), create a file `.config` in your `redox` base directory (i.e. where you run the `make` command). Set the values in that file, e.g.
```
ARCH?=i686
CONFIG_NAME?=desktop-minimal
```

If you used [podman_bootstrap.sh](./ch02-06-podman-build.md#new-working-directory), this file may have been created for you already. The setting `PODMAN_BUILD?=1` must include the `?=` operator, as Podman Build changes its value during the build process.

The purpose of `.config` is to allow you to change your configuration settings without worrying that they will end up in a Pull Request. `.config` is in the `.gitignore` list, so you won't accidentally commit it.

### Architecture Names

The Redox build system support cross-compilation to any processor architecture defined by the `ARCH?` environment variable, these are the supported architectures based on the folders inside the [config](https://gitlab.redox-os.org/redox-os/redox/-/tree/master/config) folder.

- i686 - `i686`
- x86_64 - `x86_64`
- ARM64 - `aarch64`

## Filesystem Config

Which packages and programs to include in the Redox image are determined by a **filesystem config** file, which is a `.toml` file, such as `config/x86_64/demo.toml`. Open `demo.toml` and have a look through it.
```sh
gedit config/x86_64/demo.toml &
```

For each supported processor architecture, there are one or more filesystem configs to choose from. For `x86_64`, there are `desktop`, `demo` and `server` configurations, as well as a few others. For `i686`, there are also some stripped down configurations for legacy systems with minimal RAM. Have a look in the directory `config/x86_64` for some examples.

For more details on the filesystem config, and how to include extra packages in your build, please see [Including Programs in Redox](./ch09-01-including-programs.md).

Feel free to create your own **filesystem config**.

### Filesystem Size

Filesystem size is the total amount of space allocated for the filesystem that is built into the image, including all packages and programs. It is specified in Megabytes (MB). The typical size is 256MB, although the `demo` config is larger. The filesystem needs to be large enough to accommodate the packages that are included in the filesystem. For the *livedisk* system, don't exceed the size of your RAM, and leave room for the system to run.

The value for filesystem size is normally set from the **filesystem config** file, e.g. `config/x86_64/demo.toml`.
```
filesystem_size = 768
```
If you wish to change it, it is recommended that you create your own filesystem config and edit it there. However, you can override it temporarily in your environment or on the `make` command line, e.g.:
```sh
make FILESYSTEM_SIZE=512 qemu
```

## ARCH, FILESYSTEM_CONFIG and CONFIG_NAME

In `mk/config.mk`, you will find the variables `ARCH`, `CONFIG_NAME` and `FILESYSTEM_CONFIG`. These three variables determine what system you are building. 

- `ARCH`: the processor architecture that you are building the system for. Currently supported architectures are `x86_64` (the default), `i686` and `aarch64`. 
- `CONFIG_NAME`: used to determine part of the name of the Redox image, and normally used to build the `FILESYSTEM_CONFIG` name (`desktop` by default). 
- `FILESYSTEM_CONFIG`: a file that describes the packages and files to include in the filesystem. See [Filesystem Config](#filesystem-config) above. The default is `config/$ARCH/$CONFIG_NAME.toml`, but you can change it if your config file is in a different location.

If you want to change them permanently, edit [.config](#config) in your `redox` base directory and and provide new values. 
```sh
gedit .config &
```
```
ARCH?=i686
CONFIG_NAME?=desktop_minimal
```

Or, you can set the values temporarily in your environment or on your `make` command line, e.g. `export ARCH=i686; make all` or `make ARCH=i686 all`. The first example sets the value for the lifetime of the current shell, while the second sets the value only or the current `make`.

The Redox image that is built is named `build/$ARCH/$CONFIG_NAME/harddrive.img` or `build/$ARCH/$CONFIG/livedisk.iso`.

### build.sh

The script `build.sh` allows you to easily set `ARCH`, `FILESYSTEM_CONFIG` and `CONFIG_NAME` when running `make`. If you are not changing the values very often, it is recommended you set the values in [.config](#config) rather than use `build.sh`. But if you are testing against different architectures or  configurations, then this script can help minimize effort, errors and confusion.

`./build.sh [-a ARCH] [-c CONFIG_NAME] [-f FILESYSTEM_CONFIG] TARGET...`

The `TARGET` is any of the available `make` targets, although the recommended target is `qemu`. You can also include certain variable settings such as `vga=no`.

- `-f FILESYSTEM_CONFIG` allows you to specify a filesystem config file, which can be in any location but is normally in the directory `config/$ARCH`.

  If you **do** specify `-f FILESYSTEM_CONFIG`, but not `-a` or `-c`, the file path determines the other values. Normally the file would be located at e.g. `config/x86_64/desktop.toml`. `ARCH` is determined from the second last element of the path. If the second last element is not a known `ARCH` value, you must specify `-a ARCH`. `CONFIG_NAME` is determined from the *basename* of the file.

- `-a ARCH` is the processor architecture you are building for, `x86_64`, `i686` or `aarch64`. The uppercase options `-X`, `-6` and `-A` can be used as shorthand for `-a x86_64`, `-a i686` and `-a aarch64` respectively.
  
- `-c CONFIG_NAME` is the name of the configuration, which appears in both the name of the image being built and (usually) the filesystem config.

  If you **do not** specify `-f FILESYSTEM_CONFIG`, the value of `FILESYSTEM_CONFIG` is constructed from `ARCH` and `CONFIG_NAME`, `config/$ARCH/$CONFIG_NAME.toml`. 

  The default value for `ARCH` is `x86_64` and for `CONFIG_NAME` is `desktop`, which produces a default value for `FILESYSTEM_CONFIG` of `config/x86_64/desktop.toml`.

## REPO_BINARY

If `REPO_BINARY` set to 1 (`REPO_BINARY?=1`), your build system will become binary-based for recipes, this is useful for some purposes, such as making development builds, test package status and save time with heavy softwares.

You can have a mixed binary/source build, when you enable `REPO_BINARY` it treat every recipe with a `{}` a binary package and recipes with `"recipe"` are treated as source, both inside of your TOML config (`config/$ARCH/$CONFIG_NAME.toml`), example:
```
recipe1 = {} # binary package
recipe2 = "recipe" # source
```
## Other Config Values

You can override other variables in your [.config](#config). Some interesting values in `mk/config.mk` are:

- `PREFIX_BINARY` - If set to 1 (`PREFIX_BINARY?=1`), the build system don't compile from toolchain sources but download/install them from Redox CI server. This can save lots of time during your first build. Note: If you are using **Podman**, you must set these variables in [.config](#config) in order for your change to have any effect. Setting them in the environment or on the command line may not be effective.
- `REPO_BINARY` - If set to 1 (`REPO_BINARY?=1`), the build system don't compile from recipe sources but download/install packages from Redox package server.
- `FILESYSTEM_SIZE`: The size in MB of the filesystem contained in the Redox image. See [Filesystem Size](#filesystem-size) before changing it.
- `REDOXFS_MKFS_FLAGS`: Flags to the program that builds the Redox filesystem. `--encrypt` enables disk encryption.
- `PODMAN_BUILD`: If set to 1 (`PODMAN_BUILD?=1`), the build environment is constructed in **Podman**. See [Podman Build](./ch02-06-podman-build.md).
- `CONTAINERFILE`: The Podman containerfile. See [Podman Build](./ch02-06-podman-build.md).
