Compiling Redox
===============

Now we have prepared the build, so naturally we're going to build Redox.


```sh
$ make all
```

Give it a while. Redox is big.

Running Redox
-------------

To run Redox, do:
```sh
$ make qemu
```

This should open up a Qemu window, booting to Redox.

If it does not work, try:

```sh
$ make qemu kvm=no # we disable KVM
```

If this doesn't work either, you should go open an issue.

Note
----

If you encounter any bugs, errors, obstructions, or other annoying things, please report the issue to the Redox repository. Thanks!
