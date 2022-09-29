# Building Redox

Woah! You made it this far, all the way to here. Congrats! Now we gotta build Redox. This process is for **x86_64** machines. There are also similar processes for [i686](./ch02-07-i686.html) and [AArch64](./ch02-08-aarch.html).

The build process fetches files from the Redox Gitlab server. From time to time, errors may occur, which may result in you being asked to provide a username and password during the build process. If this happens, first check for typos in the git URL. If that doesn't solve the problem and you don't have a Redox gitlab login, try again later, and if it continues to happen, you can let us know through [chat](./ch06-03-chat.html), or send an email to [info@redox-os.org](mailto:info@redox-os.org)

The build process for the current release (0.8.0) is tested on Pop!_OS/Ubuntu/Debian. There is partial support for several other distros. Please join the [chat](./ch06-03-chat.html) if you have interest in finding out the current state of building on one of the partially supported platforms.

## Preparing the Build

### Bootstrap Prerequisites And Fetch Sources

If you're on a Linux or macOS computer, you can just run the bootstrapping script, which does the build preparation for you. Run the following commands:

```sh
$ sudo apt-get install curl
$ mkdir -p ~/tryredox
$ cd ~/tryredox
$ curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/bootstrap.sh -o bootstrap.sh
$ time bash -e bootstrap.sh
```

You will be asked to confirm various installations. Answer in the affirmative (*y* or *1* as appropriate).
The above does the following:
 - creates a parent folder called "tryredox". Within that folder, it will create another folder called "redox" where all the sources will reside.
 - installs the pre-requisite packages using your operating system's package manager(Pop!_OS/Ubuntu/Debian apt, Redhat/Centos/Fedora dnf, Arch Linux pacman).
 - clones the Redox code from GitLab and checks out a redox-team tagged version of the different subprojects intended for the community to test and submit success/bug reports for.

 Note that `curl -sf` operates silently, so if there are errors, you may get an empty or incorrect version of bootstrap.sh. Check for typos in the command and try again. If you continue to have problems, join the [chat](./ch06-03-chat.html) and let us know.

Please be patient, this can take 5 minutes to an hour depending on the hardware and network you're running it on. Once it completes, update your path in the current shell with
```sh
$ source ~/.cargo/env
```

### Tweak the filesystem size

The filesystem size is specified in MegaBytes.  The default is 256MB. You might want a bigger size, like 2GB(2048MB). The filesystem needs to be large enough to accommodate the packages that are included in the filesystem. For the *livedisk* system, don't exceed the size of your RAM, and leave room for the system to run.

 - Open with your favourite text editor(vim or emacs) `redox/mk/config.mk`
   ```
   $ cd ~/tryredox/redox
   $ gedit mk/config.mk &
   ```
 - Look for **FILESYSTEM_SIZE** and change the value in MegaBytes
   ```
   FILESYSTEM_SIZE?=2048
   ```

There are several other settings you can modify, have a look at `redox/mk/config.mk` to see what applies to you. 

### Add/remove packages in the filesystem

If you want to try a headless server or one of the other predefined configurations, in `mk/config.mk`, change **FILESYSTEM_CONFIG** to point to one of the `.toml` configuration files in `config/x86_64`, e.g. `config/x86_64/server.toml` or whichever filesystem config suits your purposes. The demo configuration is `config/x86_64/demo.toml`. You may need to adjust **FILESYSTEM_SIZE** to accommodate the contents of your configuration. You can add programs to the filesystem by following the instructions [here](./ch05-03-compiling-program.html).


## Compiling The Entire Redox Project

Now we have:
 - fetched the sources
 - tweaked the settings to our liking
 - possibly added our very own source/binary package to the filesystem

We are ready to build the entire Redox Operating System Image.

### Build all the components and packages

To build all the components, and the packages to be included in the filesystem.

```sh
$ cd ~/tryredox/redox
$ time make all
```
This will make the target `build/hardrive.img`, which you can run with an emulator.

Give it a while. Redox is big. This will do the following:
- fetch some sources for the core tools from the Redox-os source servers, then build them.  As it progressively cooks each package, it fetches the respective package's sources and builds it.
- create a few empty files holding different parts of the final image filesystem.
- using the newly built core tools, build the non-core packages into one of those filesystem parts.
- fill the remaining filesystem parts appropriately with stuff built by the core tools to help boot Redox.
- merge the different filesystem parts into a final Redox Operating System respective image ready-to-run in Qemu.


### Run in an emulator

You can immediately run this image in an emulator with the following command.
```sh
$ make qemu
```

The emulator will display the Redox GUI. See **Using the emulation** in [Running in a virtual machine](./ch02-02-running-vm.html) for general instructions and [Trying out Redox](./ch02-09-trying-out-redox.html) for things to try.

#### Run with no GUI

To run the emulation with no GUI, use
```
$ script ~/my_log.txt
$ make qemu vga=no
$ exit
```
Running with no GUI is the recommended method of capturing console and debug output from the system or from your text-only program. The `script` command creates a new shell, capturing all input and output from the text console to the log file with the given name. Remember to type `exit` after the emulation terminates, in order to properly flush the output to the log file and terminate `script`'s shell.

If you have problems running the emulation, you can try `make qemu kvm=no` or `make qemu iommu=no` to turn off various virtualization features.

#### Running The Redox Console With A Qemu Tap For Network Testing

Expose Redox to other computers within a LAN. Configure Qemu with a "TAP" which will allow other computers to test Redox client/server/networking capabilities.

Here are the steps to configure Qemu Tap:
**WIP**

### Building Redox Live CD/USB Image

For a *livedisk* or installable image, use:
```sh
$ cd ~/tryredox/redox
$ time make live
```
This will make the target `build/livedisk.iso`, which can be copied to a USB drive or CD for booting or installation. See **Creating a bootable USB drive or CD** in [Running Redox on real hardware](./ch02-03-real-hardware.html) for instructions on creating a USB drive and booting from it.


Note
----

If you intend on contributing to Redox or its subprojects, please read [Creating a Proper Pull Request](./ch06-10-creating-proper-pull-requests.html) so you understand our use of forks and set up your repository appropriately.

If you encounter any bugs, errors, obstructions, or other annoying things, please join the [Redox chat](./ch06-03-chat.html) or report the issue to the [Redox repository]. Thanks!

[Redox repository]: https://gitlab.redox-os.org/redox-os/redox
