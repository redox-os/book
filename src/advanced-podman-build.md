# Advanced Podman Build

To make the Redox build process more consistent across platforms, we are using **Rootless Podman** for major parts of the build.

Before reading through this section, make sure you have already read:
- [Podman Build](./podman-build.md)
- [Build System Reference](./build-system-reference.md)

This chapter provides a detailed discussion, including tips, tricks and troubleshooting, as well as some extra detail for those who might want to leverage or improve Redox's use of Podman.

## Build Environment

- Environment and command line Variables, other than `ARCH`, `CONFIG_NAME` and `FILESYSTEM_CONFIG`, are not passed to the part of `make` that is done in **Podman**. You must set any other configuration variables, e.g. `REPO_BINARY`, in [.config](./configuration-settings.md#config) and not on the command line or on your environment.

- If you are building your own software to add in Redox, and you need to install additional packages using `apt-get` for the build, follow the [Adding Packages to the Build](#adding-packages-to-the-build) section.

## Installation

Most of the packages required for the build are installed in the container as part of the build process. However, some packages need to be installed on the host operating system. You may also need to install an emulator such as **QEMU**. For most Linux distributions, this is done for you in the `podman_bootstrap.sh` script.

If you can't use the `podman_bootstrap.sh` script, you need to install at least:

- Podman 4.0 or later
- Rust
- libfuse 3.x (to build an image)
- QEMU (to run the image)

You can attempt to install the necessary packages below.

### Pop!_OS/Ubuntu/Debian

```sh
sudo apt-get install git make curl podman fuse fuse-overlayfs slirp4netns qemu-system-x86 qemu-kvm qemu-system-arm qemu-system-riscv
```

> ⚠️ **Warning:** Ubuntu 22.04 ships with old Podman (3.x version), which will have issues. The official [Podman installation guide](https://podman.io/docs/installation#ubuntu) requires Ubuntu 20.10 and newer to operate. If you do use the 22.04 version or older, please read [Gory Details](#gory-details).

### Arch Linux

```sh
sudo pacman -S --needed git make curl podman fuse3 fuse-overlayfs slirp4netns qemu-system-x86 qemu-system-arm qemu-system-riscv
```

### Fedora

```sh
sudo dnf install git-all make curl podman fuse3 fuse-overlayfs slirp4netns qemu-system-x86 qemu-kvm qemu-system-arm qemu-system-riscv
```

### OpenSUSE

```sh
sudo zypper install git make curl podman fuse fuse-overlayfs slipr4netns
```

### FreeBSD

```sh
sudo pkg install git gmake curl fusefs-libs3 podman
```

### MacOS

Building Redox using MacOS is experimental at the moment, even if using Podman you will experience [clock skew](https://github.com/containers/podman/issues/26185) which breaks the Makefile caching mechanism.

We recommend you to install QEMU, VirtualBox or [UTM](https://mac.getutm.app/) and create ARM64 or x86-64 Linux distribution virtual machine to build Redox and follow Podman or Native Build using the Linux distribution of your choice.

If you insist on using MacOS, please read [Installing without FUSE](#installing-without-fuse). Otherwise, you will have a problem installing FUSE which requires you to turn off [SIP](https://en.wikipedia.org/wiki/System_Integrity_Protection) for Apple Silicon-based MacOS.

- Homebrew

```sh
sudo brew install git make curl osxfuse podman fuse-overlayfs slirp4netns
```

- MacPorts

```sh
sudo port install git gmake curl osxfuse podman
```

### NixOS

Before building Redox with NixOS, you must have configured Podman on your system. Just follow the instructions of the [NixOS wiki](https://nixos.wiki/wiki/Podman):

```nix
{ pkgs, ... }:
{
  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
  ];
}
        
```

You will then have to configure your user to be able to use Podman:
```nix
users.extraUsers.${user-name} = {
  subUidRanges = [{ startUid = 100000; count = 65536; }];
  subGidRanges = [{ startGid = 100000; count = 65536; }];
};
```

The last step is to activate the development shell:
```sh
nix develop --no-warn-dirty --command $SHELL
```


## `build/container.tag`

The building of the **image** is controlled by the *tag* file `build/container.tag`. If you run `make all` with `PODMAN_BUILD=1` in `.config`, the file `build/container.tag` will be created after the image is built. This file tells `make` that it can skip the image update after the first time.

Many targets in the Makefiles `mk/*.mk` include `build/container.tag` as a dependency. If the *tag* file is missing, building any of those targets may trigger an image to be created, which can take some time.

When you move to a new working directory, if you want to save a few minutes, and you are confident that your **image** is correct and your `poduser` home directory `build/podman/poduser` is valid, you can do

```sh
make container_touch
```

This will create the file `build/container.tag` without rebuilding the image. However, it will fail if the image does not exist. If it fails, just do a normal `make`, it will create the container when needed.

## Installing without FUSE

If installing FUSE is difficult for your operating system, you can avoid installing it by adding `FSTOOLS_IN_PODMAN=1` in the `.config` file. It makes the installer run inside Podman. If you do set it, then you can avoid installing FUSE and Rust altogether in your host system.

An additional environment variable (`FSTOOLS_NO_MOUNT`) can also be set to not use FUSE during image creation, however image creation relies on correct files permission bit and ownership which means it only can be used within Podman. This configuration can be used as a last resort if FUSE is not working at all.

## Cleaning Up

To remove the **base image**, any lingering containers, `poduser`'s home directory, including the **Rust** installation, and `build/container.tag`, run:

```sh
make container_clean
```

- To verify that everything has been removed

```sh
podman ps -a
```

- Show any remaining images or containers

```sh
podman images
```

- Remove **all** images and containers. You still may need to remove `build/container.tag` if you did not do `make container_clean`.

```sh
podman system reset
```

**Note:**

- `make clean` does **not** run `make container_clean` and will **not** remove the container image.
- If you already did `make container_clean`, doing `make clean` will not work.

## Debugging Your Build Process

If you are developing your own components and wish to do one-time debugging to determine what library you are missing in the **Podman Build** environment, the following instructions can help. Note that your changes will not be persistent. After debugging, **you must** [Add your Libraries to the Build](#adding-packages-to-the-build). With `PODMAN_BUILD=1`, run the following command:

```sh
make container_shell
```

- Within that environment, you can build the Redox components with:

```sh
make repo
```

- If you need to change `ARCH` or `CONFIG_NAME`, run:

```sh
./build.sh -a ARCH -c CONFIG_NAME repo
```

**Note**: Your changes will not persist once both shells have been exited.

Type `exit` on both shells once you have determined how to solve your problem.

## Adding Packages to the Build

> 📝 **Note:** This section is no longer being recommended as the primary way to do development on new recipes. Any new dependencies should be compiled in a Cookbook recipe using the `host:recipe-name` syntax.

This method can be used if you want to make changes/testing inside the Debian container with `make env`. 

The default **Containerfile**, `podman/redox-base-containerfile`, imports all required packages for a normal Redox build.

However, you cannot easily add packages after the **base image** is created. You must add them to your own Containerfile and rebuild the container image. 

Copy `podman/redox-base-containerfile` and add to the list of packages in the initial `apt-get`.

```sh
cp podman/redox-base-containerfile podman/my-containerfile
```

```sh
nano podman/my-containerfile
```

```
...
        xxd \
        rsync \
        MY_PACKAGE \
...
```

Make sure you include the continuation character `\` at the end of each line except after the last package.


Then, edit [.config](./configuration-settings.md#config), and change the variable `CONTAINERFILE` to point to your Containerfile, e.g.

```
CONTAINERFILE?=podman/my-containerfile
```

If your Containerfile is newer than `build/container.tag`, a new **image** will be created. You can force the image to be rebuilt with `make container_clean`.

If you feel the need to have more than one image, you can change the variable `IMAGE_TAG` in `mk/podman.mk` to give the image a different name.

If you just want to install the packages temporarily, run `make env`, open a new terminal tab/windows, run `make container_shell` and use `apt install` on this tab/window.

## Summary of Podman-related Make Targets, Variables and Podman Commands

- `PODMAN_BUILD` - If set to 1 in [.config](./configuration-settings.md#config), or in the environment, or on the `make` command line, much of the build process takes place in **Podman**.

- `CONTAINERFILE`-  The name of the containerfile used to build the image. This file includes the `apt-get` command that installs all the necessary packages into the image. If you need to add packages to the build, edit your own containerfile and change this variable to point to it.

- `make build/container.tag` - If no container image has been built, build one. It's not necessary to do this, it will be done when needed.

- `make container_touch` - If a container image already exists and `poduser`'s home directory is valid, but there is no *tag* file, create the *tag* file so a new image is not built.

- `make container_clean` - Remove the container image, `poduser`'s home directory and the *tag* file.

- `make container_shell` - Start an interactive Podman `bash` shell in the same environment used by `make`; for debugging the `apt-get` commands used during image build.

- `make env` - Start an interactive `bash` shell with the `prefix` tools in your PATH. Automatically determines if this should be a Podman shell or a host shell, depending on the value of `PODMAN_BUILD`.

- `make repo` or `./build.sh -a ARCH -c CONFIG repo` - Used while in a Podman shell to build all the Redox component packages. `make all` will not complete successfully, since part of the build process must take place on the host.

- `podman system reset` - Use this command when `make container_clean` is not sufficient to solve problems caused by errors in the container image. It will remove all images, use with caution. If you are using **Podman** for any other purpose, those images will be deleted as well.

## Gory Details

If you are interested in how we are able to use your working directory for builds in **Podman**, the following configuration details may be interesting.

Historically, we've used `--userns keep-id` which the *container's* `root` user is actually mapped to your User ID on the host system. It was necessary in Podman 3.x and previous versions as Podman user mapping was not quite good and often broke with [tar](https://github.com/containers/podman/issues/14655) and [buildah](https://github.com/containers/buildah/issues/1818). In Podman 4.x onwards that it no longer necessary and we can drop it.

For Ubuntu 22.04 there's a temporary fix to it by [manually updating crun](https://github.com/microsoft/vscode-remote-release/issues/11042#issuecomment-3044713731).

The working directory is made available in the container by **mounting** it as a **volume**. The **Podman** option:

```sh
--volume "`pwd`":$(CONTAINER_WORKDIR):Z
```

takes the directory that `make` was started in as the host working directory, and **mounts** it at the location `$CONTAINER_WORKDIR`, normally set to `/mnt/redox`. The `:Z` at the end of the name indicates that the mounted directory should not be shared between simultaneous container instances. It is optional on some Linux distros, and not optional on others.

For our invocation of Podman, we set the PATH environment variable as an option to `podman run`. This is to avoid the need for our `make` command to run `.bashrc`, which would add extra complexity. The `ARCH`, `CONFIG_NAME` and `FILESYSTEM_CONFIG` variables are passed in the environment to allow you to override the values in `mk/config.mk` or `.config`, e.g. by setting them on your `make` command line or by using `build.sh`.

We also set `PODMAN_BUILD=0` in the environment, to ensure that the instance of `make` running in the container knows not to invoke **Podman**. This overrides the value set in `.config`.

In the **Containerfile**, we use as few `RUN` commands as possible, as **Podman** commits the image after each command. And we avoid using `ENTRYPOINT` to allow us to specify the `podman run` command as a list of arguments, rather than just a string to be processed by the entrypoint shell.

Containers in our build process are run with `--rm` to ensure the container is discarded after each use. This prevents a proliferation of used containers. However, when you use `make container_clean`, you may notice multiple items being deleted. These are the partial images created as each `RUN` command is executed while building.

Container images and container data is normally stored in the directory `$HOME/.local/share/containers/storage`. The following command removes that directory in its entirety. However, the contents of any **volume** are left alone:

```sh
podman system reset
```
