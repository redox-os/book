# Coding and Building

(Before reading this page you must read the [Build System](./build-system-reference.md) page)

This page explain common development tasks on the Redox build system.

- [Visual Studio Code Configuration](#visual-studio-code-configuration)
- [VS Code Tips and Tricks](#vs-code-tips-and-tricks)
- [Development Tips](#development-tips)
- [Working with Git](#working-with-git)
  - [Anonymous commits](#anonymous-commits)
- [Using Multiple Windows](#using-multiple-windows)
- [Setup your Configuration](#setup-your-configuration)
- [The Recipe](#the-recipe)
- [Git Clone](#git-clone)
- [Edit your Code](#edit-your-code)
- [Verify Your Code on Linux](#verify-your-code-on-linux)
- [Update The Redox Image](#update-the-redox-image)
- [Test Your Changes](#test-your-changes)
  - [Test Your Changes (out of the Redox build system)](#test-your-changes-out-of-the-redox-build-system)
  - [Testing On Real Hardware](#testing-on-real-hardware)
    - [Full bootable image creation](#full-bootable-image-creation)
    - [Partial bootable image creation](#partial-bootable-image-creation)
    - [Flash the bootable image on your USB device](#flash-the-bootable-image-on-your-usb-device)
    - [Burn your CD/DVD with the bootable image](#burn-your-cddvd-with-the-bootable-image)
- [Update crates](#update-crates)
- [Search Text On Files](#search-text-on-files)
- [Redox Image](#redox-image)
  - [Build Your Recipe for Redox](#build-your-recipe-for-redox)
  - [Make A New Redox Image](#make-a-new-redox-image)
  - [Most Quick Way To Test Your Changes](#most-quick-way-to-test-your-changes)
  - [Insert Text Files On QEMU (quickest method)](#insert-text-files-on-qemu-quickest-method)
  - [Insert Files In The Redox image Using a Recipe](#insert-files-in-the-redox-image-using-a-recipe)
  - [Insert Files In The QEMU Image](#insert-files-in-the-qemu-image)
- [Working with an unpublished version of a crate](#working-with-an-unpublished-version-of-a-crate)
- [How to update initfs](#how-to-update-initfs)

## Visual Studio Code Configuration

Before you start the VS Code IDE to do Redox development you need to run the following command on your terminal:

```sh
rustup target add x86_64-unknown-redox
```

(If you aren't building Redox to x86_64 change `x86_64` in `x86_64-unknown-redox` to the CPU code that you are using)

If the code that you are working on includes directives like `#[cfg(target_os = "redox)]`, that code will be disabled by default. To enable live syntax and compiler warnings for that code, add the following line to your VS Code config file (`.vscode/settings.json`):

```json
"rust-analyzer.cargo.target": "x86_64-unknown-redox"
```

If you are browsing a codebase that contains native dependencies (e.g. the kernel repository), you might get analyzer errors because of lacking GCC toolchain. To fix it, install [Redoxer](https://gitlab.redox-os.org/redox-os/redoxer) and its toolchain `redoxer toolchain`, then add the GCC toolchain to your `PATH` configuration (e.g. in `~/.bashrc`):

```sh
export PATH="$PATH:$HOME/.redoxer/toolchain/bin"
```

The Redoxer toolchain is added as the last item of the `PATH` environment variable list to make sure it's not replacing the Rust toolchain that you're using.

## VS Code Tips and Tricks

Although not for every Rust developer, **VS Code** is helpful for those who are working with unfamiliar code. We don't get the benefit of all its features, but the Rust support in VS Code is very good.

If you have not used VS Code with Rust, here's an [overview](https://code.visualstudio.com/docs/languages/rust). VS Code installation instructions are [here](https://code.visualstudio.com/docs/setup/linux).

After installing the `rust-analyzer` extension as described in the overview, you get access to several useful features:

- Inferred types and parameter names as inline hints
- Peeking at definitions and references
- Refactoring support
- Autoformat and Clippy on Save (optional)
- Visual Debugger (if your code can run on Linux)
- Compare/Revert against the repository with the Git extension

Using VS Code on recipes works pretty well, although it sometimes take a couple of minutes to kick in. Here are some things to know:

### Start in the "source" folder

In your "Coding" shell, start VS Code specifying the `source` directory:

```sh
code ~/tryredox/redox/recipes/games/source
```

Or if you are in the `source` directory, just write `code .` with the period meaning the `source` directory.

### Add it to your "Favorites" bar

VS Code remembers the last project you used it on, so typing `code` with no directory or starting it from your Applications window or Favorites bar will go back to that project.

After starting VS Code, right click on the icon and select "Add to Favorites"

### Wait a Couple of Minutes

You can start working right away, but after a minute or two, you will notice extra text appear in your Rust code with inferred types and parameter names filled in. This additional text is just *hints*, and is not permanently added to your code.

### Save Often

If you have made significant changes `rust-analyzer` can get confused, but this can usually be fixed by clicking on "Save All"

### Don't Use For The Whole Redox Build System

VS Code cannot grok the gestalt of Redox, so it doesn't work very well if you start it in your `redox` base directory. It can be handy for editing recipes, configuration and GNU Make files. And if you want to see what you have changed in the Redox project, click on the "Source Control" icon on the left side, then select the file you want to compare against the repository.

### Don't Build the System in a VS Code Terminal

In general, it's not recommended to do a system build from within VS Code. Use your "Build" window. This gives you the flexibility to exit Code without terminating the build.

## Development Tips

- Make sure your build system is up-to-date, read the [Update The Build System](./build-system-reference.md#update-the-build-system) section if in doubt.
- If some program can't build or work, something can be missing/hiding on [relibc](https://gitlab.redox-os.org/redox-os/relibc), like a POSIX/Linux function or bug.
- If you have some error on QEMU remember to test different settings or verify your operating system (Pop_OS!, Ubuntu, Debian and Fedora are the recommend Linux distributions to do testing/development for Redox).
- Remember to log all errors, you can use this command as example:

```sh
your-command 2>&1 | tee file-name.log
```

- If you have a problem that seems to not have a solution, think on simple/stupid things. Sometimes you are very confident on your method and forget obvious things (very common).
- If you want a quick review of your Merge Request, make it small.
- If your big Merge Request is taking too long to be reviewed and merged try to split it in small MRs. But make sure it don't break anything, if this method break your changes, don't shrink.

## Working with Git

Before starting the development, read the [Creating Proper Pull Requests](./creating-proper-pull-requests.md) page, which describes how Redox developers uses Git.

In this example, we will discuss how to create a **fork** of the `games` recipe, pretending you are going to create a `Merge Request` for your changes. **Don't actually do this**. Only create a fork when you have changes that you want to send to Redox upstream.

### Anonymous commits

If you are new to Git it request your username and email before the first commit on some offline repository, if you don't want to insert your personal information, run:

- One repository

The following commands will make you anonymous only on this repository.

```sh
cd your-repository-folder
```

```sh
git config user.name 'Anonymous'
```

```sh
git config user.email '<>'
```

- Global

The following commands will make you anonymous in any repository.

```sh
git config --global user.name 'Anonymous'
```

```sh
git config --global user.email '<>'
```

## Using Multiple Windows

For clarity and easy usage, we will be using two terminal tabs on the example below, each running a different GNU Bash shell instance.

1. The "Build" shell, normally at `~/tryredox/redox` or where your base `redox` directory is.
2. The "Coding" shell, at `recipes/games/redox-games/source`

## Setup Your Configuration

To get started, follow the steps in the [Including Programs in Redox](./including-programs.md) page to include the `games` package on your `my-config` configuration file. In your terminal window, go to your `redox` base directory and run:

```sh
make qemu
```

On Redox, run `minesweeper` as described in the link above. Type the letter `f` and you will see `F` appear on your screen. Use `Ctrl-Alt-G` to regain control of your cursor, and click the upper right corner to exit QEMU.

Keep the terminal window open. That will be your "Build" shell.

## The Recipe

Let's walk through contributing to the recipe `redox-games`, which is a collection of terminal games. We are going to modify `minesweeper` to display **P** instead of **F** on flagged spots.

The `redox-games` recipe is built at: `recipes/games/redox-games`. When you download the `redox` repository it includes a file `recipes/games/redox-games/recipe.toml`. The recipe tells the build system how to get the source and build it.

When you build the system and include the `redox-games` recipe, the toolchain does a `git clone` into the directory: `recipes/games/redox-games/source`. Then it builds the recipe in the directory: `recipes/games/redox-games/target`

Edit the recipe so it does not try to automatically download the sources.

- Create a `Terminal` window running `bash` on your system, which we will call your "Coding" shell
- Change to the `redox-games` directory
- Open the `recipe.toml` file in a text editor:

```sh
cd ~/tryredox/redox/recipes/games/redox-games
```

```sh
nano recipe.toml
```

- Comment out the `[source]` section at the top of the file:

```
# [source]
# git = "https://gitlab.redox-os.org/redox-os/games.git"
```

- Save your changes

## Git Clone

To setup this recipe for contributing, do the following in your "Coding" shell.

- Delete the `source` and `target` directories in `recipes/games/redox-games`
- Clone the package into the `source` directory, either specifying it in the `git clone` or by moving it after `clone`

```sh
rm -rf source target
```

```sh
git clone https://gitlab.redox-os.org/redox-os/games.git --origin upstream
```

```sh
mv games source
```

- If you are making a change that you want to contribute (if not **don't actually do this**), at this point you should follow the instructions in [Creating Proper Pull Requests](./creating-proper-pull-requests.md), replacing `redox.git` with `games.git`. Make sure you fork the correct repository, in this case [redox-os/games](https:/gitlab.redox-os.org/redox-os/games). Remember to create a new branch before you make any changes.

- If you want to Git Clone a remote repository (main repository/your fork), you can add these sections on your `recipe.toml`:

```toml
[source]
git = "your-git-link"
branch = "your-branch" # optional
```

## Edit Your Code

- Using your favorite code editor, make your changes. We used GNU Nano in this example from your "Coding" shell. You can also use [VS Code](#vs-code-tips-and-tricks).

```sh
cd source
```

```sh
nano src/minesweeper/main.rs
```

- Search for the line containing the definition of the `FLAGGED` constant (around line 36), and change it to `P`

```
const FLAGGED: &'static str = "P";
```

## Verify Your Code on Linux

Most Redox programs are source-compatible with Linux without being modified. You can (and should) build and test your program on Linux.

- From within the "Coding" shell go to the `source` directory and use the Linux version of `cargo` to check for errors:

```sh
cargo check
```

(Since much of the code in `redox-games` is older (pre-2018 Rust), you will get several warnings. They can be ignored)

  You could also use `cargo clippy`, but `minesweeper` is not clean enough to pass.
- The `redox-games` recipe creates more than one executable, so to test `minesweeper` on Linux, you need to specify it to `cargo`. In the `source` directory, run:

```sh
cargo run --bin minesweeper
```

## Update The Redox Image

After making changes to your recipe you can use the `make rp.redox-games` command, which will check for any changes in the recipe, rebuilt it and update the existing Redox image. The `make all` and `make qemu` commands do not check for recipes that need to be rebuilt, so if you use them, your changes may not be included in the system.

- Within your "Build" shell, in your `redox` directory, run:

```sh
make rebuild 2>&1 | tee build.log
```

- You can now scan through `build.log` to check for errors. The file is large and contains many ANSI Escape Sequences, so it can be hard to read. However, if you encountered a fatal build error, it will be at the end of the log, so skip to the bottom and scan upwards.

## Test Your Changes

In the Redox instance started by the `make qemu` command, test your changes to `minesweeper`

- Log in with user: `user` and no password
- Open a `Terminal` window
- Type `minesweeper`
- Use your arrow keys or `WSAD` to move to a square and type `f` to set a flag. The character `P` will appear


Congratulations! You have modified a program and built the system! Next, create a bootable image with your change.

- If you are still running QEMU, type `Ctrl-Alt-G` and click the upper right corner of the Redox window to exit.
- In your "Build" shell, in the `redox` directory, run:

```sh
make live
```

In the directory `build/x86_64/my-config`, you will find the file `livedisk.iso`. Follow the instructions on the [Testing on Real Hardware](#testing-on-real-hardware) section and test out your change.

### Test Your Changes (out of the Redox build system)

[Redoxer](https://gitlab.redox-os.org/redox-os/redoxer) is the tool used to quickly build and run Rust, C and C++ programs for Redox, it downloads the Redox toolchain, build the program and ru inside of a Redox VM.

#### Commands

- Install the tool

```sh
cargo install redoxer
```

- Install the Redox toolchain

```sh
redoxer toolchain
```

- Build the Rust, C or C++ program or library

```sh
redoxer build
```

- Run the Rust, C or C++ program on Redox

```sh
redoxer run
```

- Test the Rust, C or C++ program or library

```sh
redoxer test
```

- Run an arbitrary executable (`echo hello`)

```sh
redoxer exec echo hello
```

### Testing On Real Hardware

You can use the `make live` command to create bootable images, it will be used instead of `make image`

This command will create the file `build/your-cpu-arch/your-config/livedisk.iso`, you will write this image on your USB, SSD or HDD drives and CD or DVD disks (if you have an USB device, [Popsicle](https://github.com/pop-os/popsicle) is the recommended method to flash your device).

#### Full bootable image creation

- Update your system/programs and create a bootable image:

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
make r.recipe1,recipe2 live
```

#### Flash the bootable image on your USB device

If you can't use Popsicle, you can use the `dd` tool, follow the steps below:

- Go to the files of your Cookbook configuration:

```sh
cd build/your-cpu-arch/your-config
```

- Flash your device with `dd`

First you need to find your USB, SSD or HDD drive device ID, use this command to show the IDs of all connected disks on your computer:

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

Check if the items "Can write" has `1` (Yes) or `0` (No), it also show the optical disk devices on the computer: `/dev/srX`

- Burn the disk with [xorriso](https://www.gnu.org/software/xorriso/)

```sh
xorriso -as cdrecord -v -sao dev=/dev/srX livedisk.iso
```

In the `/dev/srX` part, where `x` is your optical device number.

## Update crates

Read [this](./porting-applications.md#update-crates) page to learn how to update crates.

## Search Text On Files

To find which file contains a particular command, crate or function call, you can use the `grep` command.

This will speed up your development workflow.

- Command examples

```sh
grep -rnw "redox-syscall" --include "Cargo.toml"
```

This command will show any "Cargo.toml" file that contains the text "redox-syscall". Helpful for finding which recipe contains a command or uses a crate.

```sh
grep -rni "physmap" --include "*.rs"
```

This command will find any ".rs" file that contains the text "physmap". Helpful for finding where a function is used or defined.

Options context:

- `-n` : display the line number of the specified text on each file.
- `-r` : Search directories recursively.
- `-w` : Match only whole words.
- `-i` : Ignore case distinctions in patterns and data.

- [GeeksforGeeks - grep command](https://www.geeksforgeeks.org/grep-command-in-unixlinux/) : Great article explaining how to use the `grep` tool

## Redox Image

This section explain how to update recipes, create and change the Redox image.

### Build Your Recipe For Redox

You can rebuild just the `redox-games` recipe, rather than having `make rebuild` verifying each enabled recipe for changes. This can help shorten the build time if you are trying to resolve issues such as compilation errors or linking to libraries.

- In your "Build" shell, in the `redox` directory, run:

```sh
make r.redox-games
```

The build system Makefiles have a rule for the `r.recipe` recipe target, where `recipe` is the name of a recipe. It will make that recipe ready to load into the Redox filesystem.

Once your Redox recipe has been successfully built, you can run the `make p.redox-games` command to install the recipe in the existing Redox image.

If you had a problem, use this command to log any possible errors on your terminal output:

```sh
make cr.recipe-name 2>&1 | tee recipe-name.log
```

### Make A New Redox Image

If the `make p.redox-games` command didn't work you need to create a new Redox image.

- In your "Build" shell, in the `redox` directory, run:

```sh
make image
```

The `make image` command skips building any recipes (if the last full recipe rebuild was successful), but it ensures a new image is created, which should include the recipe changes that you built in the previous step.

### Most Quick Way To Test Your Changes

Run:

```sh
make rp.recipe-name qemu
```

Or (if your change don't allow incremental compilation)

```sh
make crp.recipe-name qemu
```

This command will [build just your modified recipe](#build-your-recipe-for-redox), then [update your Redox image with your modified recipe](#make-a-new-redox-image) and run QEMU with Orbital.

### Insert Text Files On QEMU (quickest method)

If you need to move text files, such as command output, logs or scripts, from or to your Redox instance running on QEMU, use your Terminal window that you used to start QEMU. To capture the output of a Redox command, run `script` before starting QEMU.

```sh
tee qemu.log
```

```sh
make qemu gpu=no
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

The command output will now be in the file `qemu.log`. Note that if you did not exit the `script` shell the output may not be complete.

To transfer a text file (such as a log) onto Redox, use the Terminal window with clipboard copy/paste.

```
redox login: user
```

```sh
cat > mylog.log << EOF
# Copy the text to the clipboard and use the Terminal window clipboard paste
  EOF
```

If your file is large, or non-ASCII, or you have many files to copy, you can use the process described in the [Insert Files On QEMU Image](#insert-files-on-qemu-image) section. However, there's a risk of data corruption.

Files that you create while running QEMU remain in the Redox image, while you don't rebuild the image (the same applies to files that you add in the Redox image).

Make sure you are **not running QEMU** and run the `make mount` command. You can now use your file manager to navigate to `build/x86_64/my-config/filesystem`. Copy your files into or out of the Redox filesystem as required. Make sure to exit your file browser window, and run `make unmount` before running `make qemu`

Note that in some circumstances, `make qemu` may trigger a rebuild (e.g. `make` detects files with timestamp changes). If that happen the files you copied into the Redox image will be lost.

### Insert files on the Redox image using a recipe

You can use a Redox recipe to put your files inside the Redox image, in this example we will use the recipe `myfiles` for this:

- Create the `source` folder inside the `myfiles` recipe directory and copy or move your files to it:

```sh
mkdir recipes/other/myfiles/source
```

- Build the recipe and add on the Redox image:

```sh
make rp.myfiles
```

- Add the `myfiles` recipe below the `[packages]` section of your filesystem configuration at: `config/your-cpu-arch/your-config.toml` (if you want your files to be automatically added to new images):

```
[packages]
...
myfiles = {}
...
```

- Open QEMU to verify your files:

```sh
make qemu
```

This recipe will make Cookbook package all files in the `source` folder to be installed in the `/home/user` directory on your Redox filesystem.

### Insert Files In The QEMU Image

If you feel the need to skip creating a new image, and you want to directly add a file to the existing Redox image, it is possible to do so. However, this is not recommended. You should use a recipe to make the process repeatable. You can see below how to access the Redox image as if it were a Linux filesystem.

**Redox can't be running on QEMU while you do this**

- In your "Build" shell, in the `redox` directory, run:

```sh
make mount
```

The Redox image is now mounted as a directory at: `build/x86_64/your-config/filesystem`

- Unmount the filesystem and test your image. **You must unmount before you start QEMU**

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

Most Redox libraries use versioning and are downloaded from [crates.io](https://crates.io/), if you are making a change to one of these crates your merged changes could take a while to appear on crates.io as we publish to there instead of using a local crate.

To test your changes quickly, follow the following tutorials on Cargo documentation:

- [Overriding Dependencies](https://doc.rust-lang.org/cargo/reference/overriding-dependencies.html)
- [Working with an unpublished minor version](https://doc.rust-lang.org/cargo/reference/overriding-dependencies.html#working-with-an-unpublished-minor-version)

## How to update initfs

The `base` and `base-initfs` recipes share the `source` folder, thus your changes on the `base` recipe source code will be added on the `base-initfs` recipe automatically.

(The `recipe.toml` of the `base-initfs` recipe use the `same_as` data type to symlink the source, you can read the second line of the [base-initfs recipe](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/recipes/core/base-initfs/recipe.toml#L2))

When you are about to test a change on the `base` recipe, double check if you're applying for daemons in `base-initfs` by checking its recipe file in the former link. If you do, you need to trigger build changes for `base-initfs` manually so it can save `initfs` daemons into `base-initfs`:

```sh
make rp.base,base-initfs
```

RedoxFS is also included in the `base-initfs` recipe, to update them with your changes run the following command:

```sh
make rp.redoxfs,base-initfs
```
