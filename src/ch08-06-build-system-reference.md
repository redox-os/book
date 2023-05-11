# Build System Quick Reference

The build system creates and/or uses several files that you may want to know about. There are also several `make` targets mentioned above, and a few extras that you may find useful. Here's a quick summary. All file paths are relative to your `redox` base directory.

### Build System Organization

  - `Makefile` - The main makefile for the system, it loads all the other makefiles.
  - `.config` - Where you change your build system settings. It is loaded by the Makefile. It is ignored by `git`.
  - `mk/config.mk` - The build system's own settings are here. You can override these settings in your `.config`, don't change them here.
  - `mk/*.mk` - The rest of the makefiles. You should not need to change them.
  - `podman/redox-base-containerfile` - The file used to create the image used by Podman Build. The installation of Ubuntu packages needed for the build is done here. See [Adding Ubuntu Packages to the Build](./ch08-02-advanced-podman-build.md#adding-ubuntu-packages-to-the-build) if you need to add additional Ubuntu packages.
  - `config/$(ARCH)/$(CONFIG_NAME).toml` - The TOML config of your current build with system settings/paths and recipes/packages to be included in the Redox image that will be built, e.g. `config/x86_64/desktop.toml`.
  - `config/$(ARCH)/server.toml` - The server variant with system components only (try this config if you have boot problems on QEMU/real hardware).
  - `config/$(ARCH)/desktop.toml` - The default build config with system components and the Orbital desktop environment.
  - `config/$(ARCH)/demo.toml` - The desktop build with optional programs and games.
  - `config/$(ARCH)/ci.toml` - The continuous integration config, recipes added here become packages on [CI server](https://static.redox-os.org/pkg/).
  - `config/$(ARCH)/dev.toml - The desktop build with GCC and Rust included.
  - `config/$(ARCH)/resist.toml` - The build with the `resist` POSIX test suite.
  - `config/$(ARCH)/acid.toml` - The build with the `acid` stress test suite.
  - `config/$(ARCH)/jeremy.toml` - The build of [Jeremy Soller](https://soller.dev/) (creator/BDFL of Redox) with the recipes that he is testing in the moment.
  - `cookbook/recipes/recipe-name/recipe.toml` - For each Redox package (represented here as `recipe-name`), there is a directory that contains its recipe, usually `recipe.toml`, but in some older recipes, `recipe.sh` is used. The recipe contains instructions for obtaining sources via tarball or git, then creating executables or other files to include in the Redox filesystem. Note that a recipe can contain dependencies that cause other recipes to be built, even if the dependencies are not otherwise part of your Redox build.
  - `cookbook/recipes/recipe-name/source` - The directory where the recipe sources are extracted/cloned to this folder.
  - `cookbook/recipes/recipe-name/target` - The directory where the recipe binaries are stored (based on processor architecture).
  - `cookbook/recipes/recipe-name/target/${TARGET}` - The directory for the recipes binaries of the processor architecture.
  - `cookbook/recipes/recipe-name/target/${TARGET}/build` - The directory of the recipe build system.
  
    If the build system is `cargo`, this directory will contain the `target` folder with build artifacts.
  
    If the build system is `configure` (autotools/autoconf), this is the directory that the `configure` script is run from and where the build artifacts will be stored.
  - `cookbook/recipes/recipe-name/target/${TARGET}/stage` - The directory where recipe binaries go before the packaging, after `make all`, `make rebuild` or `make r.recipe-name` call, the installer will extract the recipe package on the QEMU image, generally at `/bin` or `/lib` on Redox filesystem hierarchy.
  - `cookbook/recipes/recipe-name/target/${TARGET}/sysroot` - The directory of recipe build dependencies (libraries), for example: `lib/libexample.a`
  - `cookbook/recipes/recipe-name/target/${TARGET}/stage.pkgar` - Redox package file.
  - `cookbook/recipes/recipe-name/target/${TARGET}/stage.sig` - Signature for the `tar` package format.
  - `cookbook/recipes/recipe-name/target/${TARGET}/stage.tar.gz` - Legacy `tar` package format, produced for compatibility reasons as we work to migrate the repositories over to `pkgar`.
  - `cookbook/recipes/recipe-name/target/${TARGET}/stage.toml` - Contains the runtime dependencies of the package and is part of both packaging formats.
  - `cookbook/*` - Part of the Cookbook system, these scripts and utilities help build the recipes.
  - `prefix/*` - Tools used by the cookbook system. They are normally downloaded during the first system build. If you are having a problem with the build system, you can remove the `prefix` directory and it will be recreated during the next build.
  - `$(BUILD)` - The directory where the build system will place the final image. Usually `build/$(ARCH)/$(CONFIG_NAME)`, e.g. `build/x86_64/desktop`.
  - `$(BUILD)/harddrive.img` - The Redox image file, to be used by QEMU or VirtualBox for virtual machine execution on a Linux host.
  - `$(BUILD)/livedisk.iso` - The Redox bootable image file, to be copied to a USB drive or CD for live boot and possible installation.
  - `$(BUILD)/fetch.tag` - An empty file that, if present, tells the build system that fetching of package sources has been done.
  - `$(BUILD)/repo.tag` - An empty file that, if present, tells the build system that all packages required for the Redox image have been successfully built. **The build system will not check for changes to your code when this file is present.** Use `make rebuild` to force the build system to check for changes.
  - `build/podman` - The directory where Podman Build places the container user's home directory, including the container's Rust installation. Use `make container_clean` to remove it. In some situations, you may need to remove this directory manually, possibly with root privileges.
  - `build/container.tag` - An empty file, created during the first Podman Build, so Podman Build knows a reusable Podman image is available. Use `make container_clean` to force a rebuild of the Podman image on your next `make rebuild`.
  
### Make Commands

You can combine `make` targets, but order is significant. For example, `make r.games image` will build the `games` package and create a new Redox image, but `make image r.games` will make the Redox image before it builds the package.

  - `make all` - Builds the entire system, checking for changes and only building as required. Only use this for the first build. If the system was successfully built previously, this command may report `Nothing to be done for 'all'`, even if some packages have changed. Use `make rebuild` instead.
  - `make rebuild` - Rebuilds the entire system. Forces a check of recipes for changes. This may include downloading changes from GitLab. This should be your normal `make` target.
  - `make qemu` - If a `$(BUILD)/harddrive.img` file exists, QEMU is run using that image. If you want to force a rebuild first, use `make rebuild qemu`. Sometimes `make qemu` will detect a change and rebuild, but this is not typical. If you are interested in a particular combination of QEMU command line options, have a look through `mk/qemu.mk`.
  - `make virtualbox` - The same as `make qemu`, but for [VirtualBox](https://www.virtualbox.org/).
  - `make live` - Creates a bootable image, `$(BUILD)/livedisk.iso`. Packages are not usually rebuilt. 
  - `make r.recipe-name` - Build a single recipe, checking if the recipe source has changed, and creating the executable, etc. Change the `recipe-name` part with the name of your recipe, e.g. `make r.games`. The package is built even if it is not in your filesystem config.
  - `make r.recipe2 r.recipe2` - Build two or more recipes with one command (cumulative compilation).
  - `make c.recipe-name` - Removes the binary of the recipe `recipe-name`.
  - `make c.recipe2 c.recipe2` - Clean two or more recipe binaries with one command (cumulative cleanup).
  - `make image` - Builds a new QEMU image, `$(BUILD)/harddrive.img`, without checking if any recipes have changed. Not recommended, but it can save you some time if you are just updating one recipe with `make r.recipe-name`.
  - `make c.recipe r.recipe image qemu` - Clean a recipe binary, build a recipe source, create a new QEMU image and open QEMU (the build system support cumulative cross-option).
  - `make clean` - Removes all recipe binaries (Note that `make clean` may require some tools to be built).
  - `make pull` - Update the sources for the build system without building.
  - `make fetch` - Update recipe sources, according to each recipe, without building them. Only the recipes that are included in your `(CONFIG_NAME).toml` are fetched. Does nothing if `$(BUILD)/fetch.tag` is present. You won't need this.
  - `make repo` - Package the recipe binaries, according to each recipe. Does nothing if `$(BUILD)/repo.tag` is present. You won't need this.
  - `make gdb` - Connects `gdb` to the Redox image in QEMU. Join us on [chat](./ch13-01-chat.md) if you want to use this.
  - `make mount` - Mounts the Redox image as a filesystem at `$(BUILD)/filesystem`. **Do not use this if QEMU is running**, and remember to use `make unmount` as soon as you are done. This is not recommended, but if you need to get a large file onto or off of your Redox image, this is available as a workaround.
  - `make unmount` - Unmounts the Redox image filesystem. Use this as soon as you are done with `make mount`, and **do not start QEMU** until this is done.
  - `make env` - Creates a shell with the build environment initialized. If you are using Podman Build, the shell will be inside the container, and you can use it to debug build issues such as missing packages.
  - `make container_su` - After creating a container shell using `make env`, and while that shell is still running, use `make container_su` to enter the same container as `root`. See [Debugging your Build Process](./ch08-02-advanced-podman-build.md#debugging-your-build-process).
  - `make container_clean` - If you are using Podman Build, this will discard images and other files created by it.
  - `make container_touch` - If you have removed the file `build/container.tag`, but the container image is still usable, this will recreate the `container.tag` file and avoid rebuilding the container image.
  - `make container_kill` - If you have started a build using Podman Build, and you want to stop it, `Ctrl-C` may not be sufficient. Use this command to terminate the most recently created container.

### Scripts

You can use these scripts to perform actions not implemented as commands in the Cookbook build system.

- `scripts/changelog.sh` - show the changelog of all Redox components/recipes.
- `scripts/find-recipe.sh` - show all files installed by a recipe package.
- `scripts/rebuild-recipe.sh` - alternative to `make r.recipe` and `make c.recipe` that clean your recipe source/binary (delete `source`, `source.tar` and `target` in recipe folder) to make a new clean build.

Write the path of the script and the name of your recipe:
```
scripts/rebuild-recipe.sh recipe
```

### Configuration

- [Configuration Settings](./ch02-07-configuration-settings.md)
