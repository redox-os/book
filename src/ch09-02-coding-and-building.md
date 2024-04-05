# Coding and Building

(Before reading this page you must read the [Build System Quick Reference](./ch08-06-build-system-reference.md) page)

- [Working with Git](#working-with-git)
  - [Anonymous commits](#anonymous-commits)
- [Using Multiple Windows](#using-multiple-windows)
- [Set up your Configuration](#set-up-your-configuration)
- [The Recipe](#the-recipe)
- [Git Clone](#git-clone)
- [Edit your Code](#edit-your-code)
- [Check your Code on Linux](#check-your-code-on-linux)
- [The Full Rebuild Cycle](#the-full-rebuild-cycle)
- [Test Your Changes](#test-your-changes)
  - [Test Your Changes (out of the Redox build system)](#test-your-changes-out-of-the-redox-build-system)
  - [Testing On Real Hardware](#testing-on-real-hardware)
    - [Full bootable image creation](#full-bootable-image-creation)
    - [Partial bootable image creation](#partial-bootable-image-creation)
    - [Flash the bootable image on your USB device](#flash-the-bootable-image-on-your-usb-device)
    - [Burn your CD/DVD with the bootable image](#burn-your-cddvd-with-the-bootable-image)
- [Update crates](#update-crates)
- [Search Text On Files](#search-text-on-files)
- [Checking In your Changes](#checking-in-your-changes)
- [Shortening the Rebuild Cycle](#shortening-the-rebuild-cycle)
  - [Build your Package for Redox](#build-your-package-for-redox)
  - [Make a New QEMU Image](#make-a-new-qemu-image)
  - [Most Quick Trick To Test Changes](#most-quick-trick-to-test-changes)
  - [Insert Text Files On QEMU (quickest method)](#insert-text-files-on-qemu-quickest-method)
  - [Insert files on the QEMU image using a recipe](#insert-files-on-the-qemu-image-using-a-recipe)
  - [Insert Files On The QEMU Image](#insert-files-on-the-qemu-image)
- [Working with an unpublished version of a crate](#working-with-an-unpublished-version-of-a-crate)
- [A Note about Drivers](#a-note-about-drivers)
- [Development Tips](#development-tips)
- [Visual Studio Code Configuration](#visual-studio-code-configuration)
- [VS Code Tips and Tricks](#vs-code-tips-and-tricks)
  - [Start in the "source" folder](#start-in-the-source-folder)
  - [Add it to your "Favorites" bar](#add-it-to-your-favorites-bar)
  - [Wait a Couple of Minutes](#wait-a-couple-of-minutes)
  - [Save Often](#save-often)
  - [Don't Use it for the whole of Redox](#dont-use-it-for-the-whole-of-redox)
  - [Don't Build the System in a VS Code Terminal](#dont-build-the-system-in-a-vs-code-terminal)

## Working with Git

Before starting the development, read through [Creating Proper Pull Requests](./ch12-04-creating-proper-pull-requests.md), which describes how the Redox team uses Git.

In this example, we will discuss creating a **fork** of the `games` package, pretending you are going to create a `Merge Request` for your changes. **Don't actually do this**. Only create a fork when you have changes that you want to send to Redox upstream.

### Anonymous commits

If you are new to Git, it request your username and email before the first commit on some offline repository, if you don't want to insert your personal information, run:

- Repository

```sh
cd your-repository-folder
```

```sh
git config user.name 'Anonymous'
```

```sh
git config user.email '<>'
```

This command will make you anonymous only on this repository.

- Global

```sh
git config --global user.name 'Anonymous'
```

```sh
git config --global user.email '<>'
```

This command will make you anonymous in all repositories of your user.

## Using Multiple Windows

For clarity and ease of use, we will be using a couple of `Terminal` windows on your host system, each running a different bash shell instance.
1. The `Build` shell, normally at `~/tryredox/redox` or whatever your base `redox` directory is.
2. The `Coding` shell, normally at `~/tryredox/redox/cookbook/recipes/games/source`.

## Set up your Configuration

To get started, follow the steps in [Including a Program in a Redox Build](./ch09-01-including-programs.md) to include the `games` package in your `myfiles` configuration file. In your `Terminal` window, go to your `redox` base directory and run:

```sh
make qemu
```

On Redox, run `minesweeper` as described in the link above. Type the letter `f` and you will see `F` appear on your screen. Use `Ctrl-Alt-G` to regain control of your cursor, and click the upper right corner to exit QEMU.

Keep the `Terminal` window open. That will be your `Build` shell.

## The Recipe

Let's walk through contributing to the Redox subpackage `games`, which is a collection of low-def games. We are going to modify `minesweeper` to display **P** instead of **F** on flagged spots.

The `games` package is built in the folder `cookbook/recipes/games`. When you `clone` the `redox` base package, it includes a file `cookbook/recipes/games/recipe.toml`. The recipe tells the build system how to get the source and how to build it.

When you build the system and include the `games` package, the toolchain does a `git clone` into the directory `cookbook/recipes/games/source`. Then it builds the package in the directory `cookbook/recipes/games/target`.

Edit the recipe so it does not try to automatically clone the sources. 
- Create a `Terminal` window running `bash` on your host system, which we will call your `Coding` shell.
- Change to the `games` directory.
- Open `recipe.toml` in an editor.

```sh
cd ~/tryredox/redox/cookbook/recipes/games
```

```sh
nano recipe.toml
```

- Comment out the `[source]` section at the top of the file.

```
# [source]
# git = "https://gitlab.redox-os.org/redox-os/games.git"
```

- Save your changes.

## Git Clone

To set up this package for contributing, do the following in your `Coding` shell.
- Delete the source and target directories in `cookbook/recipes/games`.
- Clone the package into the `source` directory, either specifying it in the `git clone` or by moving it after `clone`.

```sh
rm -rf source target
```

```sh
git clone https://gitlab.redox-os.org/redox-os/games.git --origin upstream --recursive
```

```sh
mv games source
```

- If you are making a change that you want to contribute, (you are not, **don't actually do this**) at this point you should follow the instructions in [Creating Proper Pull Requests](./ch12-04-creating-proper-pull-requests.md), replacing `redox.git` with `games.git`. Make sure you fork the correct repository, in this case [redox-os/games](https:/gitlab.redox-os.org/redox-os/games). Remember to create a new branch before you make any changes.

- If you want to Git Clone a remote repoitory (main repoitory/your fork), you can add these sections on your `recipe.toml`:

```toml
[source]
git = your-git-link
branch = your-branch # optional
```

## Edit your Code

- Using your favorite code editor, make your changes. We use `gedit` in this example, from your `Coding` shell. You can also use [VS Code](#vs-code-tips-and-tricks).

```sh
cd source
```

```sh
nano src/minesweeper/main.rs
```

- Search for the line containing the definition of the `FLAGGED` constant (around line 36), and change it to `P`.

```rust
const FLAGGED: &'static str = "P";
```

## Check your Code on Linux

Most Redox applications are source-compatible with Linux without being modified. You can (and should) build and test your program on Linux.
- From within the `Coding` shell, go to the `source` directory and use the Linux version of `cargo` to check for errors.

```sh
cargo check
```

(Since much of the code in `games` is older (pre-2018 Rust), you will get several warnings. They can be ignored)

  You could also use `cargo clippy`, but `minesweeper` is not clean enough to pass.
- The `games` package creates more than one executable, so to test `minesweeper` on Linux, you need to specify it to `cargo`. In the `source` directory, do:

```sh
cargo run --bin minesweeper
```

## The Full Rebuild Cycle

After making changes to your package, you should `make rebuild`, which will check for any changes to packages and make a new Redox image. `make all` and `make qemu` do not check for packages that need to be rebuilt, so if you use them, your changes may not be included in the system. Once you are comfortable with this process, you can try [some tricks to save time](#shortening-the-rebuild-cycle).
- Within your `Build` shell, in your `redox` directory, do:

```sh
tee build.log
```

```sh
make rebuild
```

```sh
exit
```

The [script](https://manpages.ubuntu.com/manpages/jammy/man1/script.1.html) command starts a new shell and logs all the output from the `make` command.
  
The `exit` command is to exit from `script`. Remember to exit the `script` shell to ensure all log messages are written to `build.log`. There's also a [trick](https://manpages.ubuntu.com/manpages/jammy/man1/script.1.html#signals) to flush the log.

- You can now scan through `build.log` to check for errors. The file is large and contains many ANSI Escape Sequences, so it can be hard to read. However, if you encountered a fatal build error, it will be at the end of the log, so skip to the bottom and scan upwards.

## Test Your Changes

In the Redox instance started by `make qemu`, test your changes to `minesweeper`.

- Log in with user `user` and no password.
- Open a `Terminal` window.
- Type `minesweeper`.
- Use your arrow keys or `WSAD` to move to a square and type `f` to set a flag. The character `P` will appear.


Congratulations! You have modified a program and built the system! Next, create a bootable Redox with your change. 
- If you are still running QEMU, type `Ctrl-Alt-G` and click the upper right corner of the Redox window to exit.
- In your `Build` shell, in the `redox` directory, do:

```sh
make live
```

In the directory `build/x86_64/myfiles`, you will find the file `livedisk.iso`. Follow the instructions for [Running on Real Hardware](./ch02-02-real-hardware.md) and test out your change.

### Test Your Changes (out of the Redox build system)

[Redoxer](https://gitlab.redox-os.org/redox-os/redoxer) is the tool used to build and run Rust programs (and C/C++ programs with zero dependencies) for Redox, it download the Redox toolchain and use Cargo.

#### Commands

- Install the tool

```sh
cargo install redoxer
```

- Install the Redox toolchain

```sh
redoxer toolchain
```

- Build the Rust program or library with Redoxer

```sh
redoxer build
```

- Run the Rust program on Redox

```sh
redoxer run
```

- Test the Rust program or library with Redoxer

```sh
redoxer test
```

- Run arbitrary executable (`echo hello`) with Redoxer

```sh
redoxer exec echo hello
```

### Testing On Real Hardware

You can use the `make live` command to create bootable images, it will be used instead of `make image`.

This command will create the file `build/your-cpu-arch/your-config/livedisk.iso`, you will burn this image on your USB drive, CD or DVD disks (if you have an USB drive, [Popsicle](https://github.com/pop-os/popsicle) is a simple program to flash your device).

#### Full bootable image creation

- Update your recipes and create a bootable image:

```sh
make rebuild live
```

#### Partial bootable image creation

- Build your source changes on some recipe and create a bootable image (no QEMU image creation):

```sh
make cr.recipe-name live
```

- Manually update multiple recipes and create a bootable image (more quick than `make rebuild`):

```sh
make r.recipe1 r.recipe2 live
```

#### Flash the bootable image on your USB device

If you don't have a GUI/display server to run Popsicle, you can use the Unix tool `dd`, follow the steps below:

- Go to the files of your Cookbook configuration:

```sh
cd build/your-cpu-arch/your-config
```

- Flash your device with `dd`

First you need to find your USB device ID, use this command to show the IDs of all connected disks on your computer:

```sh
ls /dev/disk/by-id
```

Search for the items beginning with `usb` and find your USB device model, you will copy and paste this ID on the `dd` command below (don't use the IDs with `part-x` in the end).

```sh
sudo dd if=livedisk.iso of=/dev/disk/by-id/usb-your-device-model oflag=sync bs=4M status=progress
```

In the `/dev/disk/by-id/usb-your-device-model` path you will replace the `usb-your-device-model` part with your USB device ID obtained before.

**Double-check the "of=/dev/disk/by-id/usb-your-device-model" part to avoid data loss**

#### Burn your CD/DVD with the bootable image

- Go to the files of your Cookbook configuration:

```sh
cd build/your-cpu-arch/your-config
```

- Verify if your optical disk device can write on CD/DVD

```sh
cat /proc/sys/dev/cdrom/info
```

Check if the items "Can write" has `1` (Yes) or `0` (No), it also show the optical disk devices on the computer: `/dev/srX`.

- Burn the disk with [xorriso](https://www.gnu.org/software/xorriso/)

```sh
xorriso -as cdrecord -v -sao dev=/dev/srX livedisk.iso
```

In the `/dev/srX` part, the `x` letter is your optical device number.

## Update crates

- [Porting Applications using Recipes](./ch09-03-porting-applications.md#update-crates)

## Search Text On Files

To find which package contains a particular command, crate or function call, you can use the `grep` command.

This will speed up your development workflow.

- Command examples

```sh
grep -rnw "redox-syscall" --include "Cargo.toml"
```

This command will find any "Cargo.toml" file that contains the phrase "redox-syscall". Helpful for finding which package contains a command or uses a crate.

```sh
grep -rni "physmap" --include "*.rs"
```

This command will find any ".rs" file that contains the string "physmap". Helpful for finding where a function is used or defined.

Options context:

- `-n` - display the line number of the specified text on each file.
- `-r` - Search directories recursively.
- `-w` - Match only whole words.
- `-i` - Ignore case distinctions in patterns and data.

- [grep explanation](https://www.geeksforgeeks.org/grep-command-in-unixlinux/) - GeeksforGeeks article explaining the `grep` program.

## Checking In your Changes

Don't do this now, but if you were to have permanent changes to contribute to a package, at this point, you would `git push` and create a Merge Request, as described in [Creating Proper Pull Requests](./ch12-04-creating-proper-pull-requests.md).

If you were contributing a new package, such as porting a Rust application to Redox, you would need to check in the `recipe.toml` file. It goes in the `cookbook` subproject. You may also need to modify a filesystem config file, such as `config/demo.toml`. It goes in the `redox` project. You must fork and do a proper Pull Request for each of these projects. Please coordinate with the Redox team via [Chat](./ch13-01-chat.md) before doing this.

## Shortening the Rebuild Cycle

To skip some of the steps in a full `rebuild`, here are some tricks.

### Build your Package for Redox

You can build just the `games` package, rather than having `make rebuild` check every package for changes. This can help shorten the build cycle if you are trying to resolve issues such as compilation errors or linking to libraries.
- In your `Build` shell, in the `redox` directory, type:

```sh
make r.games
```

Redox's makefiles have a rule for `r.PACKAGE`, where `PACKAGE` is the name of a Redox package. It will make that package, ready to load into the Redox filesystem.

Once your Redox package has been successfully built, you can use `make rebuild` to create the image, or, if you are confident you have made all packages successfully, you can skip a complete rebuild and just [make a new image](#make-a-new-qemu-image).

If you had a problem, use this command to log any possible errors on your terminal output:

```sh
make cr.recipe-name 2>&1 | tee recipe-name.log
```

### Make a New QEMU Image

Now that all the packages are built, you can make a Redox image without the step of checking for modifications. 

- In your `Build` shell, in the `redox` directory, do:

```sh
make image qemu
```

- `make image` skips building any packages (assuming the last full make succeeded), but it ensures a new image is created, which should include the package you built in the previous step.

### Most Quick Trick To Test Changes

Run:

```sh
make cr.recipe-name image qemu
```

This command will [build just your modified recipe](#build-your-package-for-redox), then [update your QEMU image with your modified recipe](#make-a-new-qemu-image) and run QEMU with a GUI.

### Insert Text Files On QEMU (quickest method)

If you need to move text files, such as shell scripts or command output, from or to your Redox instance running on QEMU, use your Terminal window that you used to start QEMU. To capture the output of a Redox command, run `script` before starting QEMU.

```sh
tee qemu.log
```

```sh
make qemu
```

```
redox login: user
# execute your commands, with output to the terminal
# exit QEMU
# exit the shell started by script
```

```sh
exit
```

The command output will now be in the file qemu.log. Note that if you did not exit the `script` shell, the output may not be complete.

To transfer a text file, such as a shell script, onto Redox, use the Terminal window with copy/paste.

```
redox login: user
```

```sh
cat > myscript.sh << EOF
# Copy the text to the clipboard and use the Terminal window paste
  EOF
```

If your file is large, or non-ascii, or you have many files to copy, you can use the process described in [Patch an Image](#insert-files-on-qemu-image). However, you do so at your own risk.

Files you create while running QEMU remain in the Redox image, so long as you do not rebuild the image. Similarly, files you add to the image will be present when you run QEMU, so long as you do not rebuild the image.

Make sure you are **not running QEMU**. Run `make mount`. You can now use your file browser to navigate to `build/x86_64/myfiles/filesystem`. Copy your files into or out of the Redox filesystem as required. Make sure to exit your file browser window, and use `make unmount` before running `make qemu`.

Note that in some circumstances, `make qemu` may trigger a rebuild (e.g. `make` detects an out of date file). If that happens, the files you copied into the Redox image will be lost.

### Insert files on the QEMU image using a recipe

You can use a Redox package to put your files inside of the Redox filesystem, on this example we will use the recipe `myfiles` for this:

- Create the `source` folder inside the `myfiles` recipe directory and move your files to it:

```sh
mkdir cookbook/recipes/other/myfiles/source
```

- Add the `myfiles` recipe below the `[packages]` section on your Cookbook configuration at `config/your-cpu-arch/your-config.toml`:

```
[packages]
...
myfiles = {}
...
```

- Build the recipe and create a new QEMU image:

```sh
make r.myfiles image
```

- Open QEMU to verify your files:

```sh
make qemu
```

This recipe will make the Cookbook package all the files on the `source` folder to be installed on the `/home/user` directory on your Redox filesystem.

This is the only way keep your files after the `make image` command.

### Insert Files On The QEMU Image

If you feel the need to skip creating a new image, and you want to directly add a file to the existing Redox image, it is possible to do so. However, this is not recommended. You should use a recipe to make the process repeatable. But here is how to access the Redox image as if it were a Linux filesystem.

- **NOTE:** You must ensure that Redox is not running in QEMU when you do this.

- In your `Build` shell, in the `redox` directory, type:

```sh
make mount
```

The Redox image is now mounted as a directory at `build/x86_64/your-config/filesystem`.

- Unmount the filesystem and test your image. **NOTE:** You must unmount before you start QEMU.

```sh
cd ~/tryredox/redox
```

```sh
make unmount
```

```sh
make qemu
```

## Working with an unpublished version of a crate

Some recipes use Cargo dependencies (Cargo.toml) with recipe dependencies (recipe.toml), if you are making a change to one of these Cargo dependencies, your merged changes will take a while to appear on [crates.io](https://crates.io/) as we publish to there instead of using our GitLab fork.

To test your changes quickly, follow these tutorials on Cargo documentation:

- [Overriding Dependencies](https://doc.rust-lang.org/cargo/reference/overriding-dependencies.html)
- [Working with an unpublished minor version](https://doc.rust-lang.org/cargo/reference/overriding-dependencies.html#working-with-an-unpublished-minor-version)

## A Note about Drivers

Drivers are a special case for rebuild. The source for drivers is fetched both for the `drivers` recipe and the `drivers-initfs` recipe. The `initfs` recipe also copies some drivers from `drivers-initfs` during the build process. If your driver is included in `initfs`, you need to keep all three in sync. The easiest solution is to write a build shell script something like the following, which should be run in your `redox` base directory. (**Note**: This assumes your driver code edits are in the directory `cookbook/recipes/drivers`. Don't accidentally remove your edited code.)

```sh
rm -rf cookbook/recipes/drivers-initfs/{source,target} cookbook/recipes/initfs/target
```

```sh
cp -R cookbook/recipes/drivers/source cookbook/recipes/drivers-initfs
```

```sh
make rebuild
```

```sh
make qemu
```

## Development Tips

- Make sure your build system is up-to-date, read [this](./ch08-06-build-system-reference.md#update-the-build-system) section in case of doubt.
- If some program can't build or work properly, remember that something could be missing/hiding on [relibc](https://gitlab.redox-os.org/redox-os/relibc), some function or bug.
- If you have some error on QEMU, remember to test different settings or check your operating system (Debian, Ubuntu and Pop OS! are the recommend Linux distributions to do testing/development for Redox).
- Remember to log all errors, you can use this command as example:

```sh
your-command 2>&1 | tee file-name.log
```

- If you have a problem that seems to not have a solution, think on simple/stupid things, sometimes you are very confident on your method and forget obvious things (it's very common).
- If you want a more quick review of your Merge Request, make it small, Jeremy will read it more fast.
- If your big Merge Request is taking too long to merge try to shrink it with other small MRs, make sure it don't break anything, if this method break your changes, don't shrink.

## Visual Studio Code Configuration

Before you start the VS Code IDE to do Redox development, you need to run this command on your terminal:

```sh
rustup target add x86_64-unknown-redox
```

If the code that you are working on includes directives like `#[cfg(target_os = "redox)]`, that code will be disabled by default. To enable live syntax and compiler warnings for that code, add the following line to your VS Code config file (`.vscode/settings.json`):

```
"rust-analyzer.cargo.target": "x86_64-unknown-redox"
```

## VS Code Tips and Tricks

Although not for every Rustacean, **VS Code** is helpful for those who are working with unfamiliar code. We don't get the benefit of all its features, but the Rust support in VS Code is very good.

If you have not used VS Code with Rust, here's an [overview](https://code.visualstudio.com/docs/languages/rust). VS Code installation instructions are [here](https://code.visualstudio.com/docs/setup/linux).

After installing the `rust-analyzer` extension as described in the overview, you get access to several useful features.
- Inferred types and parameter names as inline hints.
- Peeking at definitions and references.
- Refactoring support.
- Autoformat and clippy on Save (optional).
- Visual Debugger (if your code can run on Linux).
- Compare/Revert against the repository with the Git extension. 

Using VS Code on individual packages works pretty well, although it sometimes take a couple of minutes to kick in. Here are some things to know.

### Start in the "source" folder

In your `Coding` shell, start VS Code, specifying the `source` directory.

```sh
code ~/tryredox/redox/cookbook/recipes/games/source
```

Or if you are in the `source` directory, just `code .` with the period meaning the `source` dir.

### Add it to your "Favorites" bar

VS Code remembers the last project you used it on, so typing `code` with no directory or starting it from your Applications window or Favorites bar will go back to that project.

After starting VS Code, right click on the icon and select `Add to Favorites`.

### Wait a Couple of Minutes

You can start working right away, but after a minute or two, you will notice extra text appear in your Rust code with inferred types and parameter names filled in. This additional text is just *hints*, and is not permanently added to your code.

### Save Often

If you have made significant changes, `rust-analyzer` can get confused, but this can usually be fixed by doing `Save All`.

### Don't Use it for the whole of Redox

VS Code cannot grok the gestalt of Redox, so it doesn't work very well if you start it in your `redox` base directory. It can be handy for editing recipes, config and make files. And if you want to see what you have changed in the Redox project, click on the Source Control icon on the far left, then select the file you want to compare against the repository.

### Don't Build the System in a VS Code Terminal

In general, it's not recommended to do a system build from within VS Code. Use your `Build` window. This gives you the flexibility to exit Code without terminating the build.
