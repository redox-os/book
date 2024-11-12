# Porting Case Study

As a non-trivial example of porting a Rust app, let's look at what was done to port [gitoxide](https://github.com/Byron/gitoxide).
This port was already done, so it is now much simpler, but perhaps some of these steps will apply to you.

The goal when porting is to capture all the necessary configuration in recipes and scripts, and to avoid requiring a fork of the repo or upstreaming changes.
This is not always feasible, but forking/upstreaming should be avoided when it can be.

We are using full pathnames for clarity, you don't need to.

## Build on Linux

Before we start, we need to build the software for our Linux system and make sure it works.
This is not part of the porting, it's just to make sure our problems are not coming from the Linux version of the software.
We follow the normal build instructions for the software we are porting.
```sh
cd ~
```

```sh
git clone https://github.com/Byron/gitoxide.git
```

```sh
cd gitoxide
```

```sh
cargo run --bin ein
```

## Set up the working tree

We start with a fresh clone of the Redox repository. In a Terminal/Console/Command window:

```sh
mkdir -p ~/redox-gitoxide
```

```sh
cd ~/redox-gitoxide
```

```sh
git clone git@gitlab.redox-os.org:redox-os/redox.git --origin upstream --recursive
```

The new recipe will be part of the `cookbook` repository, so we need to fork then branch it. To fork the `cookbook` repository:
- In the browser, go to [Cookbook](https://gitlab.redox-os.org/redox-os/cookbook)
- Click the `Fork` button in the upper right part of the page
- Create a `public` fork under your gitlab user name (it's the only option that's enabled)

Then we need to set up our local `cookbook` repository and create the branch. `cookbook` was cloned when we cloned `redox`, so we will just tweak that. In the Terminal window:

```sh
cd ~/redox-gitoxide/redox/cookbook
```

```sh
git remote rename origin upstream
```

```sh
git rebase upstream master
```

```sh
git remote add origin git@gitlab.redox-os.org:MY_USERNAME/cookbook.git
```

```sh
git checkout -b gitoxide-port
```

## Create a Recipe

To create a recipe, we need to make a new directory in `cookbook/recipes` with the name the package will have, in this case `gitoxide`, and create a `recipe.toml` file with a first-draft recipe.

```sh
mkdir -p ~/redox-gitoxide/redox/cookbook/recipes/gitoxide
```

```sh
cd ~/redox-gitoxide/redox/cookbook/recipes/gitoxide
```

```sh
nano recipe.toml
```

Start with the following content in the `recipe.toml` file.

```toml
[source]
git = "https://github.com/Byron/gitoxide.git"
[build]
template = "cargo"
```

## First Attempt

Next we attempt to build the recipe. Note that the first attempt may require the Redox toolchain to be updated, so we run `make prefix`, which may take quite a while.

```sh
cd ~/redox-gitoxide/redox
```

```sh
make prefix
```

```sh
make r.gitoxide |& tee gitoxide.log
```

We get our first round of errors (among other messages):

```
error[E0425]: cannot find value `POLLRDNORM` in crate `libc`
error[E0425]: cannot find value `POLLWRBAND` in crate `libc`
```

## Make a Local Copy of libc

We suspect the problem is that these items have not been defined in the Redox edition of `libc`.
`libc` is not a Redox crate, it is a rust-lang crate, but it has parts that are Redox-specific.
We need to work with a local copy of `libc`, and then later ask someone with authority to upstream the required changes.

First, clone `libc` into our `gitoxide` directory.

```sh
cd ~/redox-gitoxide/redox/cookbook/recipes/gitoxide
```

```sh
git clone https://github.com/rust-lang/libc.git
```

Try to find the missing constants.

```sh
cd ~/redox-gitoxide/redox/cookbook/recipes/gitoxide/libc
```

```sh
grep -nrw "POLLRDNORM" --include "*.rs"
```

```sh
grep -nrw "POLLWRBAND" --include "*.rs"
```

Looks like the value is not defined for the Redox version of `libc`. Let's see if it's in `relibc`.

```sh
cd ~/redox-gitoxide/redox/relibc
```

```sh
grep -nrw "POLLRDNORM" --include "*.rs"
```

```sh
grep -nrw "POLLWRBAND" --include "*.rs"
```

Yes, both are already defined in `relibc`, and after a bit of poking around, it looks like they have an implementation.
They just need to get published in `libc`. Let's do that.

## Make Changes to libc

Let's add our constants to our local `libc`. We are not going to bother with `git` because these changes are just for debugging purposes.
Copy the constant declarations from `relibc`, and paste them in the appropriate sections of `libc/src/unix/redox/mod.rs`.
In addition to copying the constants, we have to change the type `c_short` to `::c_short` to conform to `libc` style.

```sh
cd ~/redox-gitoxide/redox/cookbook/recipes/gitoxide
```

```sh
nano libc/src/unix/redox/mod.rs
```

We add the following lines to `mod.rs`:

```rust
pub const POLLRDNORM: ::c_short = 0x040;
pub const POLLRDBAND: ::c_short = 0x080;
pub const POLLWRNORM: ::c_short = 0x100;
pub const POLLWRBAND: ::c_short = 0x200;
```

In order to test our changes, we will have to modify our `gitoxide` clone for now.
Once the changes to `libc` are upstreamed, we won't need a modified `gitoxide` clone.
To avoid overwriting our work, we want to turn off future fetches of the `gitoxide` source during build, so change `recipe.toml` to comment out the source section: `nano recipe.toml`.

```toml
#[source]
#git = "https://github.com/Byron/gitoxide.git"
[build]
template = "cargo"
```

We edit `gitoxide`'s `Cargo.toml` so we use our `libc`.

```
nano ~/redox-gitoxide/cookbook/recipes/gitoxide/source/Cargo.toml
```

After the `[dependencies]` section, but before the `[profile]` sections, add the following to `Cargo.toml`:

```toml
[patch.crates-io]
libc = { path = "../libc" }
```

Bump the version number on our `libc`, so it will take priority.

```
nano ~/redox-gitoxide/cookbook/recipes/gitoxide/libc/Cargo.toml
```

```toml
version = "0.2.143"
```

Update `gitoxide`'s `Cargo.lock`.

```sh
cd ~/redox-gitoxide/redox/cookbook/recipes/gitoxide/source
```

```sh
cargo update
```

Make sure we have saved all the files we just edited, and let's try building.

```sh
cd ~/redox-gitoxide/redox
```

```sh
make r.gitoxide
```

Our `libc` errors are solved! Remember, these changes will need to upstreamed by someone with the authority to make changes to `libc`.
Post a request on the chat's [Redox OS/MRs](https://matrix.to/#/#redox-mrs:matrix.org) room to add the constants to `libc`.

## Creating a Custom Recipe

In looking at what is included in `gitoxide`, we see that it uses [OpenSSL](https://docs.rs/openssl/latest/openssl/), which has some custom build instructions described in the docs.
There is already a Redox fork of `openssl` to add Redox as a target, so we will set up our environment to use that.

In order to do this, we are going to need a custom recipe. Let's start with a simple custom recipe, just to get us going.
Edit our previously created recipe, `cookbook/recipes/gitoxide/recipe.toml`, changing it to look like this.

```toml
#[source]
#git = "https://github.com/Byron/gitoxide.git"
[build]
template = "custom"
script = """
printenv
"""
```

In this version of our recipe, we are just going to print the environment variables during `cook`,
so we can see what we might make use of in our custom script.
We are not actually attempting to build `gitoxide`.
Now, when we run `make r.gitoxide` in `~/redox-gitoxide/redox`, we see some useful variables such as `TARGET` and `COOKBOOK_ROOT`.

Two key shell functions are provided by the custom script mechanism, `cookbook_cargo` and `cookbook_configure`.
If you need a custom script for building a Rust program, your script should set up the environment, then call `cookbook_cargo`, which calls Redox's version of `cargo`.
If you need a custom script for using a `Makefile`, your script should set up the environment, then call `cookbook_configure`.
If you have a custom build process, or you have a patch-and-build script, you can just include that in the `script` section and not use either of the above functions.
If you are interested in looking at the code that runs custom scripts, see the function `build()` in `cookbook`'s [cook.rs](https://gitlab.redox-os.org/redox-os/cookbook/-/blob/master/src/bin/cook.rs).

Adding a dependency on `openssl` ensures that the build of `openssl` will happen before attempting to build `gitoxide`, so we can trust that the library contents are in the target directory of the ssl package.
And we need to set the environment variables as described in the [OpenSSL bindings](https://docs.rs/openssl/latest/openssl/) crate docs.

Our recipe now looks like this:

```toml
#[source]
#git = "https://github.com/Byron/gitoxide.git"
[build]
dependencies = [
    "openssl",
]
template = "custom"
script = """
export OPENSSL_DIR="${COOKBOOK_SYSROOT}"
export OPENSSL_STATIC="true"
cookbook_cargo
"""
```

## Linker Errors

Now we get to the point where the linker is trying to statically link the program and libraries into the executable. This program, called `ld`, will report errors if there are any undefined functions or missing static variable definitions.

```
undefined reference to `tzset'
undefined reference to `cfmakeraw'
```

In our case we find we are missing `tzset`, which is a timezone function. We are also missing `cfmakeraw` from `termios`. Both of these functions are normally part of `libc`. In our case, they are defined in the `libc` crate, but they are not implemented by Redox's version of `libc`, which is called `relibc`. We need to add these functions.

## Add Missing Functions to relibc

Let's set up to modify `relibc`. As with `cookbook`, we need a fork of [relibc](https://gitlab.redox-os.org/redox-os/relibc). Click on the `Fork` button and add a public fork. Then update our local `relibc` repo and branch.

```sh
cd ~/redox-gitoxide/redox/relibc
```

```sh
git remote rename origin upstream
```

```sh
git rebase upstream master
```

```sh
git remote add origin git@gitlab.redox-os.org:MY_USERNAME/relibc.git
```

```sh
git checkout -b gitoxide-port
```

Now we need to make our changes to `relibc`...

After a fair bit of work, which we omit here, the functions `tzset` and `cfmakeraw` are implemented in `relibc`. An important note is that in order to publish the functions, they need to be preceded with:

```
#[no_mangle]
extern "C" fn tzset() ...
```

Now let's build the system. The command `touch relibc` changes the timestamp on the `relibc` directory, which will cause the library to be updated. We then clean and rebuild `gitoxide`.

```sh
cd ~/redox-gitoxide/redox
```

```sh
cd relibc
```

```sh
cargo update
```

```sh
cd ..
```

```sh
touch relibc
```

```sh
make prefix
```

```sh
make cr.gitoxide
```

## Testing in QEMU

Now we need to build a full Redox image and run it in QEMU. Let's make a configuration file.

```sh
cd ~/redox-gitoxide/redox/config/x86_64
```

```sh
cp desktop.toml my_desktop.toml
```

```sh
nano my_desktop.toml
```

Note that the prefix "my_" at the beginning of the config file name means that it is gitignore'd, so it is preferred that you prefix your config name with "my_".

In `my_desktop.toml`, at the end of the list of packages, after `uutils = {}`, add

```toml
gitoxide = {}
```

Now let's tell `make` about our new config definition, build the system, and test our new command.

```sh
cd ~/redox-gitoxide/redox
```

```sh
echo "CONFIG_NAME?=my_desktop" >> .config
```

```sh
make rebuild
```

```sh
make qemu
```

Log in to Redox as `user` with no password, and type:

```sh
gix clone https://gitlab.redox-os.org/redox-os/website.git
```

We get some errors, but we are making progress.

## Submitting the MRs

- Before committing our new recipe, we need to uncomment the `[source]` section. Edit `~/redox-gitoxide/redox/cookbook/recipes/gitoxide/recipe.toml` to remove the `#` from the start of the first two lines.
- We commit our changes to `cookbook` to include the new `gitoxide` recipe and submit an MR, following the instructions [Creating Proper Pull Requests](./creating-proper-pull-requests.md).
- We commit our changes to `relibc`. We need to rebuild the system and test it thoroughly in QEMU, checking anything that might be affected by our changes. Once we are confident in our changes, we can submit the MR.
- We post links to both MRs on the [Redox OS/MRs](https://matrix.to/#/#redox-mrs:matrix.org) room to ensure they get reviewed. 
- After making our changes to `libc` and testing them, we need to request to have those changes upstreamed by posting a message on the [Redox OS/MRs](https://matrix.to/#/#redox-mrs:matrix.org) room. If the changes are complex, please create an issue on the [build system repository](https://gitlab.redox-os.org/redox-os/redox) and include a link to it in your post.
