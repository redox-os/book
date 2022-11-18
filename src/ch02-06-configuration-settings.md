# Configuration Settings

The build system uses several makefiles, most of which are in the directory `mk`. We have grouped together most of the settings that might be interesting into `mk/config.mk`. You can modify them there, or you can temporarily change them by setting them in your environment or on the `make` command line. Open the file in your favorite editor and have a look through it, e.g.
```sh
gedit mk/config.mk &
```

Other important configuration information is contained in the **filesystem config** file, described below.

## Filesystem Config

Which packages and programs to include in the Redox image are determined by a **filesystem config** file, which is a `.toml` file, such as `config/x86_64/desktop.toml`. Open `desktop.toml` and have a look through it.
```sh
gedit config/x86_64/desktop.toml &
```

For each supported processor architecture, there are one or more filesystem configs to choose from. For `x86_64`, there are `desktop`, `demo` and `server` configurations, as well as a few others. For `i686`, there are also some stripped down configurations for legacy systems with minimal RAM. Have a look in the directory `config/x86_64` for some examples.

For more details on the filesystem config, and how to include extra packages in your build, please see [Including Programs](./ch05-03-including-programs.html).

Feel free to create your own **filesystem config**.

### Filesystem Size

Filesystem size is the total amount of space allocated for the filesystem that is built into the image, including all packages and programs. It is specified in Megabytes (MB). The typical size is 256MB, although the `demo` config is larger. The filesystem needs to be large enough to accommodate the packages that are included in the filesystem. For the *livedisk* system, don't exceed the size of your RAM, and leave room for the system to run.

The value for filesystem size is normally set from the **filesystem config** file, e.g. `config/x86_64/desktop.toml`.
```
filesystem_size = 256
```
If you wish to change it, it is recommended that you create your own filesystem config and edit it there. However, you can override it temporarily in your environment or on the `make` command line, e.g.:
```sh
make FILESYSTEM_SIZE=512 qemu
```

## ARCH, FILESYSTEM_CONFIG and CONFIG_NAME

In `mk/config.mk`, you will find the variables `ARCH`, `FILESYSTEM_CONFIG` and `CONFIG_NAME`. These three variables determine what system you are building. If you want to change them, you can edit `mk/config.mk` and replace the values. Or, you can set the values in your environment or on your `make` command line, e.g. `export ARCH=i686; make all` or `make ARCH=i686 all`. The first example sets the value for the lifetime of the current shell, while the second sets the value only or the current `make`.

- `ARCH`: the processor architecture that you are building the system for. Currently supported architectures are `x86_64` (the default), `i686` and `aarch64`. 
- `FILESYSTEM_CONFIG`: a file that describes the packages and files to include in the filesystem. See [Filesystem Config](#filesystem-config) above. The default is `config/$ARCH/desktop.toml`.
- `CONFIG_NAME`: used to determine part of the name of the Redox image. Normally the *basename* of `FILESYSTEM_CONFIG`, e.g. `desktop`. 
 
The Redox image that is built is named `build/$ARCH/$CONFIG_NAME/harddrive.img` or `build/$ARCH/$CONFIG/livedisk.iso`.

### build.sh

The script `build.sh` allows you to easily set `ARCH`, `FILESYSTEM_CONFIG` and `CONFIG_NAME` when running `make`. If you are not changing the values very often, it is recommended you set the values in `mk/config.mk` rather than use `build.sh`. But if you are testing against different architectures or  configurations, then this script can help minimize effort, errors and confusion.

`./build.sh [-a ARCH] [-c CONFIG_NAME] [-f FILESYSTEM_CONFIG] TARGET...`

The `TARGET` is any of the available `make` targets. You can also include certain variable settings such as `vga=no`.

- `-f FILESYSTEM_CONFIG` allows you to specify a filesystem config file, which can be in any location but is normally in the directory `config/$ARCH`.

  If you **do** specify `-f FILESYSTEM_CONFIG`, but not `-a` or `-c`, the file path determines the other values. Normally the file would be located at e.g. `config/x86_64/desktop.toml`. `ARCH` is determined from the second last element of the path. If the second last element is not a known `ARCH` value, you must specify `-a ARCH`. `CONFIG_NAME` is determined from the *basename* of the file.

- `-a ARCH` is the processor architecture you are building for, `x86_64`, `i686` or `aarch64`. The uppercase options `-X`, `-6` and `-A` can be used as shorthand for `-a x86_64`, `-a i686` and `-a aarch64` respectively.
  
- `-c CONFIG_NAME` is the name of the configuration, which appears in both the name of the image being built and (usually) the filesystem config.

  If you **do not** specify `-f FILESYSTEM_CONFIG`, the value of `FILESYSTEM_CONFIG` is constructed from `ARCH` and `CONFIG_NAME`, `config/$ARCH/$CONFIG_NAME.toml`. 

  The default value for `ARCH` is `x86_64` and for `CONFIG_NAME` is `desktop`, which produces a default value for `FILESYSTEM_CONFIG` of `config/x86_64/desktop.toml`.

## Other Config Values

Other interesting values in `mk/config.mk` are:

- `PREFIX_BINARY`, `REPO_BINARY`: If set to 1, the corresponding tools (**prefix**) or Redox packages (**repo**) are not compiled, rather their binaries are fetched from the **Redox Gitlab** repository. This can save lots of time during your first build. Note: If you are using **Podman**, you must set these variables in `mk/config.mk` in order for your change to have any effect. Setting them in the environment or on the command line may not be effective.
- `FILESYSTEM_SIZE`: The size in MB of the filesystem contained in the Redox image. See [Filesystem Size](#filesystem-size) before changing it.
- `REDOXFS_MKFS_FLAGS`: Flags to the program that builds the Redox filesystem. `--encrypt` enables disk encryption.
- `PODMAN_BUILD`: If set to 1, the build environment is constructed in **Podman**. See [Podman Build](./ch02-08-podman-build.md).
- `CONTAINERFILE`: The Podman containerfile. See [Podman Build](./ch02-08-podman-build.md).
