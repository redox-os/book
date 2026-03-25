# Continuous Integration

The [Continuous Integration](https://en.wikipedia.org/wiki/Continuous_integration) helps developers to automate the software testing as the code evolves, it detects build failures, bugs and regressions.

In Redox, we use the [Redoxer](https://gitlab.redox-os.org/redox-os/redoxer) program to set up our GitLab CI configuration file. It downloads our toolchain, builds the program or library for the Redox target using Cargo, and runs the program inside a Redox virtual machine. Redoxer helps developers to test software for Redox OS without having to bootstrap the full build system.

Refer to the repository [README](https://gitlab.redox-os.org/redox-os/redoxer#user-content-redoxer) for command line instructions. This page assumes you have read them.

## Installing Redoxer

We provide two options to install Redoxer: Docker container or Cargo. To install via `redoxer` crate in `crates.io` :

```sh
cargo install redoxer
```

Then download the toolchain, QEMU image and test if installation works with `true` from `uutils` :

```sh
redoxer exec true
```

To install and run Redoxer via [the official Docker container](https://hub.docker.com/r/redoxos/redoxer):

```sh
docker run -ti --rm docker.io/redoxos/redoxer redoxer exec true
```

Compared to Redoxer via Cargo,  the Docker variant is very recommended for use in CI since it's **guaranteed to boot**, because the Redox toolchain and QEMU image for testing is already inside it and tested before being published. The Docker variant is only available for `x86_64` Linux at this time.

All commands below will refer `redoxer` as the command to run Redoxer. For installations via Docker you need to prefix it using the `docker run` command or alias it in `.bashrc`:

```sh
alias redoxer='docker run -ti --rm -v ".:/mnt" -w /mnt -e REDOXER_SYSROOT --device /dev/kvm docker.io/redoxos/redoxer redoxer'
```

## Build and test a Rust project with Redoxer

Redoxer has a first-class integration with Cargo. Here's how to check and build a Rust project targeting Redox OS:

```sh
redoxer check
```

```sh
redoxer build
```

Here's how to test a Rust project in Redox OS, which will run an actual test inside QEMU:

```sh
redoxer test
```

All Cargo commands are shorthanded; the complete list can be seen in the README or just run `redoxer`.

## Build and test a C or C++ project with Redoxer

Redoxer has a shorthand for `ar`, `cc`, `cxx` for the AR/GCC/G++ compiler. Here's how to build a single `main.c` file targeting Redox OS:

```sh
redoxer cc main.c -o main
```

Here's how to test that single executable on Redox OS, which will run an actual test inside QEMU:

```sh
redoxer exec ./main
```

You can wrap Redoxer to the C and C++ compiler, which you can then use to compile larger C or C++ projects using GNU Make, CMake, Meson and so on:

```sh
export AR="redoxer ar"
export CC="redoxer cc"
export CXX="redoxer cxx"
```

## Building with native libraries

Sometimes a project needs native libraries such as OpenSSL or zlib. To have them included for compilation, run:

```sh
redoxer pkg openssl3 zlib
```

It will download and extract the compiled library to `target/$TARGET/sysroot` or configured from `REDOXER_SYSROOT`. After it does, all subsequent Redoxer calls will automatically be linked to them via `RUSTFLAGS`, `LDFLAGS`, etc.

To verify how the build works run the `redoxer env` command and examine how environment variables are produced. You can also debug it with a interactive GNU Bash using `redoxer env bash` :

```sh
[user@local ~]$ docker run -ti --rm docker.io/redoxos/redoxer redoxer env bash
root@20111589c5b4:/# $CC --version
x86_64-unknown-redox-gcc (GCC) 13.2.0
Copyright (C) 2023 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

## Testing with additional files

To add files inside Redoxer use the `--folder` option, which will copy the contents of the specified directory path into `/root`:

- Add the contents of the current directory

```sh
redoxer exec --folder . true
```

You can also install more packages with `redoxer pkg`, then add those in a different folder other than the root:

```sh
REDOXER_SYSROOT=sysroot redoxer pkg curl
```

```sh
# note that the ending "/" in ./sysroot/usr/ matters (rsync behavior)
redoxer exec --folder ./sysroot/usr/:/usr curl --version
```

You can copy files from the QEMU image to the specified directory path with the `--artifact` option when execution is successful. It also can be combined with `--folder` :

- Add and copy the current directory back

```sh
redoxer exec --folder . --artifact . touch file
```

## CI templates

- GitHub CI template:

```yml
jobs:
  redox:
    runs-on: ubuntu-latest
    container: redoxos/redoxer
    env:
      REDOXER_QEMU_ARGS: "-smp 1"
    steps:
      - run: ln -sf /root/.redoxer ~/.redoxer
      - uses: actions/checkout@v6
      - run: redoxer test
```

- GitLab CI template:

```yml
redox_test:
  image: redoxos/redoxer
  variables:
    REDOXER_QEMU_ARGS: "-smp 1"
  script:
    - redoxer test
```

This solve two issues:

-  `REDOXER_QEMU_ARGS: "-smp 1"` ensures there's no flaky test caused by high contention in kernel multi-threading, which is an open issue to this day.
-  `ln -sf /root/.redoxer ~/.redoxer` fixes a missing toolchain and image problem because GitHub does not run as `/root`, but as `/github/home`. GitLab does not have this problem.
