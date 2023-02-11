# Advanced Podman Build

To make the Redox build process more consistent across platforms, we are using **Rootless Podman** for major parts of the build. The basics of using Podman are described [here](./ch02-06-podman-build.md). This chapter provides a detailed discussion, including tips, tricks and troubleshooting, as well as some extra detail for those who might want to leverage or improve Redox's use of Podman.

## Build Environment

- Environment and Command Line Variables, other than ARCH, CONFIG_NAME and FILESYSTEM_CONFIG, are not passed to the part of `make` that is done in **Podman**. You must set any other config variables, e.g. `REPO_BINARY`, in [.config](./ch02-07-configuration-settings.md#config) and not on the command line or in your environment.

- If you are building your own software to include in Redox, and you need to install additional packages using `apt-get` for the build, follow [Adding Libraries to the Build](#adding-libraries-to-the-build).

## Minimum Installation

Most of the packages required for the build are installed in the container as part of the build process. However, some packages need to be installed on the host computer. You may also need to install an emulator such as **QEMU**. For most Linux distros, this is done for you in `podman_bootstrap.sh`, but you can do a minimum install by following the instructions below.

Note that the Redox filesystem parts are merged using [FUSE](https://github.com/libfuse/libfuse). `podman_bootstrap.sh` installs `libfuse` for most platforms, if it is not already included. If you have problems with the final assembly of Redox, check that `libfuse` is installed and you are able to use it.

### Pop!_OS

```sh
sudo apt-get install podman
```

### Ubuntu

```sh
sudo apt-get install podman curl git make libfuse-dev
```

### ArchLinux

```sh
sudo pacman -S --needed git podman fuse
```

### Fedora

```sh
sudo dnf install podman
```

## build/container.tag

The building of the **image** is controlled by the *tag* file `build/container.tag`. If you run `make all` with `PODMAN_BUILD=1`, the file `build/container.tag` will be created after the image is built. This file tells `make` that it can skip updating the image after the first time.

Many targets in the Makefiles `mk/*.mk` include `build/container.tag` as a dependency. If the *tag* file is missing, building any of those targets may trigger an image to be created, which can take some time.

When you move to a new working directory, if you want to save a few minutes, and you are confident that your **image** is correct and your `poduser` home directory `build/podman/poduser` is valid, you can do
```sh
make container_touch
```
This will create the file `build/container.tag` without rebuilding the image. However, it will fail if the image does not exist. If it fails, just do a normal `make`, it will create the container when needed.

## Cleaning Up

To remove the **base image**, any lingering containers, `poduser`'s home directory, including the **Rust** install, and `build/container.tag`, use
```sh
make container_clean
```

To check that everything has been removed,
```sh
podman ps -a
podman images
```
will show any remaining images or containers. If you need to do further cleanup,
```
podman system reset
```
will remove **all** images and containers. You still may need to remove `build/container.tag` if you did not do `make container_clean`. 

In some rare instances, `poduser`'s home directory can have bad file permissions, and you may need to do 
```sh
sudo chown -R `id -un`:`id -gn` build/podman
```
where `` `id -un` `` is your User ID and `` `id -gn` `` is your effective Group ID. Be sure to `make container_clean` after that.

**Note:**
- `make clean` does **not** run `make container_clean` and will **not** remove the container image.
- If you already did `make container_clean`, doing `make clean` could trigger an image build and a Rust install in the container. It invokes `cargo clean` on various components, which it must run in a container, since the build is designed to not require **Cargo** on your host machine. If you have Cargo installed on the host and in your PATH, you can use `make PODMAN_BUILD=0 clean` to clean without building a container. 

## Debugging your Build Process

If you are developing your own components and wish to do one-time debugging to determine what library you are missing in the **Podman Build** environment, the following instructions can help. Note that your changes will not be persistent. After debugging, **you must** [Add your Libraries to the Build](#adding-libraries-to-the-build). With `PODMAN_BUILD=1`, run the command:
```sh
make container_shell
```

This will start a `bash` shell in the **Podman** container environment, as a normal user without `sudo` privilege. Within that environment, you can build the Redox components with:
```sh
make repo
```
or, if you need to change `ARCH` or `CONFIG_NAME`,
```sh
./build.sh -a ARCH -c CONFIG_NAME repo
```

If you need `root` privileges, while you are **still running** the above `bash` shell, go to a separate **Terminal** or **Console** window on the host, and type:
```sh
cd ~/tryredox/redox
make container_su
```

You will then be running bash with `root` privilege in the container, and you can use `apt-get` or whatever tools you need, and it will affect the environment of the user-level `container_shell` above. Do not precede the commands with `sudo` as you are already `root`. And remember that you are in an **Ubuntu** instance.

**Note**: Your changes will not persist once both shells have been exited.

Type `exit` on both shells once you have determined how to solve your problem.

## Adding Libraries to the Build

The default **Containerfile**, `podman/redox-base-containerfile`, imports all required packages for a normal Redox build.

However, you cannot easily add packages after the **base image** is created. You must add them to your own Containerfile and rebuild the container image. 

Copy `podman/redox-base-containerfile` and add to the list of packages in the initial `apt-get`.
```sh
cp podman/redox-base-containerfile podman/my-containerfile
gedit podman/my-containerfile &
```
```
...
        xxd \
        rsync \
        MY_PACKAGE \
...
```
Make sure you include the continuation character `\` at the end of each line except after the last package.


Then, edit [.config](./ch02-07-configuration-settings.md#config), and change the variable `CONTAINERFILE` to point to your Containerfile, e.g.
```
CONTAINERFILE?=podman/my-containerfile
```

If your Containerfile is newer than `build/container.tag`, a new **image** will be created. You can force the image to be rebuilt with `make container_clean`.

If you feel the need to have more than one image, you can change the variable `IMAGE_TAG` in `mk/podman.mk` to give the image a different name.

## Troubleshooting Podman

If you have problems setting Podman to rootless mode, use these commands:

(These commands were taken from the official [Podman rootless wiki] and [Shortcomings of Rootless Podman], then it could be broken/wrong in the future, read the wiki to see if the commands match, we will try to update the method to work with everyone)

- Install `podman`, `crun`, `slirp4netns` and `fuse-overlayfs` packages on your system.
- `podman ps -a` - this command will show all your Podman containers, if you want to remove all of them, run `podman system reset`.
- Take this [step] if necessary (if the Podman of your distribution use cgroup V2), you will need to edit the `containers.conf` file on `/etc/containers` or your user folder at `~/.config/containers`, change the line `runtime = "runc"` to `runtime = "crun"`.
- Execute `cat /etc/subuid` and `cat /etc/subgid` to see user/group IDs (UIDs/GIDs) available for Podman.

If you don't want to edit the file, you can use this command:

`sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 yourusername`

You can use the values `100000-165535` for your user, just edit the two text files, we recommend `sudo nano /etc/subuid` and `sudo nano /etc/subgid`, when you finish, press Ctrl+X to save the changes.

- After the change on the UID/GID values, execute the command `podman system migrate`.
- If you have a network problem on the container, execute the command:

`sudo sysctl net.ipv4.ip_unprivileged_port_start=443` - This command will allow port connection without root.

- Hopefully, you have a working Podman build now (if you still have problems with Podman, check the [Troubleshooting](./ch08-05-troubleshooting.md) chapter or join us on the [Redox Support] room)

Let us know if you have improvements for Podman troubleshooting on [Redox Dev] room.

- If you want to use the tool `ping` on the containers, execute this command:

`sudo sysctl -w "net.ipv4.ping_group_range=0 $MAX_GID"`

[Podman rootless wiki]: https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md
[Shortcomings of Rootless Podman]: https://github.com/containers/podman/blob/main/rootless.md
[step]: https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md#cgroup-v2-support
[Redox Support]: https://matrix.to/#/#redox-support:matrix.org
[Redox Dev]: https://matrix.to/#/#redox-dev:matrix.org

## Summary of Podman-related Make Targets, Variables and Podman Commands

- `PODMAN_BUILD`: If set to 1 in [.config](./ch02-07-configuration-settings.md#config), or in the environment, or on the `make` command line, much of the build process takes place in **Podman**.

- `CONTAINERFILE`: The name of the containerfile used to build the image. This file includes the `apt-get` command that installs all the necessary packages into the image. If you need to add packages to the build, edit your own containerfile and change this variable to point to it.

- `make build/container.tag`: If no container image has been built, build one. It's not necessary to do this, it will be done when needed.

- `make container_touch`: If a container image already exists and `poduser`'s home directory is valid, but there is no *tag* file, create the *tag* file so a new image is not built.

- `make container_clean`: Remove the container image, `poduser`'s home directory and the *tag* file.

- `make container_shell`: Start an interactive Podman `bash` shell in the same environment used by `make`; for debugging the `apt-get` commands used during image build.

- `make env`: Start an interactive `bash` shell with the `prefix` tools in your PATH. Automatically determines if this should be a Podman shell or a host shell, depending on the value of `PODMAN_BUILD`.

- `make repo` or `./build.sh -a ARCH -c CONFIG repo`: Used while in a Podman shell to build all the Redox component packages. `make all` will not complete successfully, since part of the build process must take place on the host.

- `podman exec --user=0 -it CONTAINER bash`: Use this command in combination with `make container_shell` or `make env` to get `root` access to the Podman build environment, so you can temporarily add packages to the environment. `CONTAINER` is the name of the active container as shown by `podman ps`. For temporary, debugging purposes only.

- `podman system reset`: Use this command when `make container_clean` is not sufficient to solve problems caused by errors in the container image. It will remove all images, use with caution. If you are using **Podman** for any other purpose, those images will be deleted as well.

## Gory Details

If you are interested in how we are able to use your working directory for builds in **Podman**, the following configuration details may be interesting.

We are using **Rootless Podman**'s `--userns keep-id` feature. Because Podman is being run Rootless, the *container's* `root` user is actually mapped to your User ID on the host. Without the `keep-id` option, a regular user in the container maps to a phantom user outside the container. With the `keep-id` option, a user in the container that has the same User ID as your host User ID, will have the same permissions as you.

During the creation of the **base image**, Podman invokes [Buildah](https://buildah.io/) to build the image. Buildah does not allow User IDs to be shared between the host and the container in the same way that Podman does. So the base image is created without `keep-id`, then the first container created from the image, having `keep-id` enabled, triggers a remapping. Once that remapping is done, it is reused for each subsequent container.

The working directory is made available in the container by **mounting** it as a **volume**. The **Podman** option:
```
--volume "`pwd`":$(CONTAINER_WORKDIR):Z
```
takes the directory that `make` was started in as the host working directory, and **mounts** it at the location `$CONTAINER_WORKDIR`, normally set to `/mnt/redox`. The `:Z` at the end of the name indicates that the mounted directory should not be shared between simultaneous container instances. It is optional on some Linux distros, and not optional on others.

For our invocation of Podman, we set the PATH environment variable as an option to `podman run`. This is to avoid the need for our `make` command to run `.bashrc`, which would add extra complexity. The `ARCH`, `CONFIG_NAME` and `FILESYSTEM_CONFIG` variables are passed in the environment to allow you to override the values in `mk/config.mk` or `.config`, e.g. by setting them on your `make` command line or by using `build.sh`.

We also set `PODMAN_BUILD=0` in the environment, to ensure that the instance of `make` running in the container knows not to invoke **Podman**. This overrides the value set in `.config`.

In the **Containerfile**, we use as few `RUN` commands as possible, as **Podman** commits the image after each command. And we avoid using `ENTRYPOINT` to allow us to specify the `podman run` command as a list of arguments, rather than just a string to be processed by the entrypoint shell.

Containers in our build process are run with `--rm` to ensure the container is discarded after each use. This prevents a proliferation of used containers. However, when you use `make container_clean`, you may notice multiple items being deleted. These are the partial images created as each `RUN` command is executed while building.

Container images and container data is normally stored in the directory `$HOME/.local/share/containers/storage`. The command
```sh
podman system reset
```
removes that directory in its entirety. However, the contents of any **volume** are left alone.
