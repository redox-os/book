Compiling The Entire Redox Project
===========================================

Now we have:
 - fetched the sources
 - tweaked the settings to our liking
 - possibly added our very own source/binary package to the filesystem

We are ready to build the entire Redox Operating System Image.

### Build Redox images

#### Building an image for emulation
```sh
$ cd ~/tryredox/redox
$ make all
```
will make the target `build/hardrive.img`, which you can run with an emulator. See [Trying Redox in a virtual machine](./ch02-02-try-vm.html).



#### Building Redox Live CD/USB Image for **x86_64**
```sh
$ cd ~/tryredox/redox
$ time make live
```
will make the target `build/livedisk.iso`, which can be copied to a USB drive or CD for booting or installation. See [Running Redox on real hardware](./ch02-03-real-hardware.html).


#### Building Redox for **aarch64/arm64**
```sh
$ cd ~/tryredox/redox/
$ time ./aarch64.sh
```

Give it a while. Redox is big.
- The two main targets `build/harddrive.img` and `build/livedisk.iso` fetch some sources for the core tools from the Redox-os source servers, then builds them.  As it progressively cooks each package, it fetches the respective package's sources and builds it.
- creates a few empty files holding different parts of the final image filesystem.
- using the newly built core tools, it builds the non-core packages into one of those filesystem parts
- fills the remaining filesystem parts appropriately with stuff built by the core tools to help boot Redox.
- merges the the different filesystem parts into a final Redox Operating System respective image ready-to-run in Qemu.

#### Cleaning Previous Build Cycles

##### Cleaning Intended For Rebuilding Core Packages And Entire System

When you need to rebuild core-packages like relibc, gcc and related tools, clean the entire previous build cycle with:
```
cd ~/tryredox/redox/
rm -rf prefix/x86_64-unknown-redox/relibc-install/ cookbook/recipes/gcc/{build,sysroot,stage*} build/filesystem.bin
```

or try touching:
```
cd ~/tryredox/redox/
touch initfs.toml
touch filesystem.toml
```

##### Cleaning Intended For Only Rebuilding Non-Core Package(s)
If you're only rebuilding a non-core package,
you partially clean the previous build cycle just enough to force rebuilding the Non-Core Package:
```
cd ~/tryredox/redox/
rm build/filesystem.bin
```

or try touching:
```
cd ~/tryredox/redox/
touch filesystem.toml
```

Running Redox
-------------

#### Running The Redox Desktop

To run Redox, do:
```sh
$ make qemu
```
This should open up a Qemu window, booting to Redox.

If it does not work, try:

```sh
$ make qemu kvm=no # we disable KVM
```

or:

```sh
$ make qemu iommu=no
```

If this doesn't work either, you should go open an issue.

#### Running The Redox Console Only

We disable to GUI desktop by passing "vga=no".  The following disables the graphics support and welcomes you with the Redox console:
```sh
$ make qemu vga=no 
```

It is advantageous to run the console in order to capture the output from the non-gui applications.
I helps to debug applications and share the console captured logs with other developers in the redox community.

#### Running The Redox Console With A Qemu Tap For Network Testing

Expose Redox to other computers within a LAN. Configure Qemu with a "TAP" which will allow other computers to test Redox client/server/networking capabilities.

Here are the steps to configure Qemu Tap:
**WIP**

Note
----

If you encounter any bugs, errors, obstructions, or other annoying things, please report the issue to the [Redox repository]. Thanks!

[Redox repository]: https://gitlab.redox-os.org/redox-os/redox
