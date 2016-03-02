Compiling Redox
===============

Now we have prepared the build, so naturally we're going to build Redox.

Cloning the repository
----------------------

```
$ git submodule update --init
```

Give it a while. Redox is big.

Yay! Building!
--------------

```
$ cd /path/to/redox
$ make -j 4 build
```

This is going to take a while. So sit down and relax.

When this is done, the exciting part is starting:

Running Redox
-------------

To run Redox, do:
```
$ make qemu
```

This should open up a Qemu window, booting to Redox.

If it does not work, try:

```
$ make qemu kvm=no # we disable KVM
```

If this doesn't work either, you should go open an issue.

Note
----

If you encounter any bugs, errors, obstructions, or other annoying things, please report the issue to the Redox repository. Thanks!
