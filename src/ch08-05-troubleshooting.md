# Troubleshooting the Build

In case you need to do some troubleshooting of the build process, this is a brief overview of the Redox toolchain, with some troubleshooting tips. This chapter is a work in progress.

## Setting Up

### Bootstrap.sh

When you run `bootstrap.sh` or `podman_bootstrap.sh`, the Linux packages and libraries required to support the toolchain and build process are installed. Then the `redox` project is cloned from the Redox GitLab. The `redox` project does not contain the Redox source, it mainly contains the build system. The `cookbook` subproject, which contains recipes for all the packages to be included in Redox, is also copied as part of the clone.

Not all Linux distros are supported by `bootstrap.sh`, so if you are on an unsupported distro, try `podman_bootstrap.sh`, or have a look at [podman_bootstrap.sh](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/podman_bootstrap.sh) and try to complete the setup up manually.

### Git Clone

If you did not use `bootstrap.sh` or `podman_bootstrap.sh` to set up your environment, you can get the sources with
```sh
git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive
```

If you are missing the `cookbook` project or other components, ensure that you used the `--recursive` flag when doing `git clone`. Ensure that all the libraries and packages required by Redox are installed by running `bootstrap.sh -d` or, if you will be using the Podman build, `podman_bootstrap.sh -d`.

## Building the System

When you run `make all`, the following steps occur.

### .config and mk/config.mk

`make` scans [.config](./ch02-07-configuration-settings.md#config) and [mk/config.mk](./ch02-07-configuration-settings.md#mkconfigmk) for settings, such as the target architecture, config name, and whether to use **Podman** during the build process. Read through [Configuration Settings](./ch02-07-configuration-settings.md) to make sure you have the settings that are best for you.

### Prefix

The Redox toolchain, referred to as **Prefix** because it is prefixed with the architecture name, is downloaded and/or built. Custom versions of `cargo`, `rustc`, `gcc` and many other tools are created. They are placed in the `prefix` directory. 

If you have a problem with the toolchain, try `rm -rf prefix`, and everything will be reinstalled the next time you run `make all`.

### Podman

If enabled, the Podman environment is set up. [Podman](./ch02-06-podman-build.md) is recommended for distros other than Pop!_OS/Ubuntu/Debian.

If your build appears to be missing libraries, have a look at [Debugging your Podman Build Process](./ch02-06-podman-build.md#debugging-your-build-process).
If your Podman environment becomes broken, you can use `podman system reset` and `rm -rf build/podman`. In some cases, you may need to do `sudo rm -rf build/podman`.

If you have others problems with Podman, read the [Troubleshooting Podman](./ch08-02-advanced-podman-build.md#troubleshooting-podman) chapter.

### Filesystem Config

The list of Redox packages to be built is read from the [filesystem config](./ch02-07-configuration-settings.md#filesystem-config) file, which is specified in [.config](./ch02-07-configuration-settings.md#config) or `mk/config.mk`. If your package is not being included in the build, check that you have set `CONFIG_NAME` or `FILESYSTEM_CONFIG`, then check the config file.

### Fetch

Each package's source is downloaded using `git` or `tar`, according to the `[source]` section of `cookbook/recipes/PACKAGE/recipe.toml` (where PACKAGE is the name of the package). Source is placed in `cookbook/recipes/PACKAGE/source`. Some packages use the older `recipe.sh` instead. 

If you are doing work on a package, you may want to comment out the `[source]` section of the recipe. To discard your changes to the source for a package, or to update to the latest version, uncomment the `[source]` section of the recipe, and use `rm -rf source target` in the `PACKAGE` directory to remove both the source and any compiled code.

After all packages are fetched, a tag file is created as `build/$ARCH/$CONFIG_NAME/fetch.tag`, e.g. `build/x86_64/desktop/fetch.tag`. If this file is present, fetching is skipped. You can remove it manually, or use `make rebuild`, if you want to force refetching.

### Cook

Each package is built according to the `recipe.toml` file. The compiled package is placed in the `target` directory, in a subdirectory named based on the target architecture. These tasks are done by various Redox-specific shell scripts and commands, including `repo.sh`, `cook.sh` and `Xargo`. These commands make assumptions about $PATH and $PWD, so they might not work if you are using them outside the build process.

If you have a problem with a package you are building, try `rm -rf target` in the `PACKAGE` directory. A common problem when building on non-Debian systems is that certain packages will fail to build due to missing libraries. Try using [Podman Build](./ch02-06-podman-build.md).

After all packages are cooked, a tag file is created as `build/$ARCH/$CONFIG_NAME/repo.tag`. If this file is present, cooking is skipped. You can remove it manually, or use `make rebuild`, which will force refetching and rebuilding.

### Create the Image with FUSE

To build the final Redox image, `redox_installer` uses [FUSE](https://github.com/libfuse/libfuse), creating a virtual filesystem and copying the packages into it. This is done outside of Podman, even if you are using Podman Build.

On some Linux systems, FUSE may not be permitted for some users, or `bootstrap.sh` might not install it correctly. Investigate whether you can address your FUSE issues, or join the [chat](./ch13-01-chat.md) if you need advice.

