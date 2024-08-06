# Downloading packages with pkg

[pkg](https://gitlab.redox-os.org/redox-os/pkgutils) is the Redox package manager which allows you to install binary packages to a running system. If you want to build packages, or include binary packages during the build, please see [Including Programs in Redox](./ch09-01-including-programs.md).

You may get better results in an virtual machine than in real hardware (due to the small device support).

- Install a package

```sh
pkg install package-name
```

- Upgrade all installed packages

```sh
pkg upgrade
```

- List package contents

```sh
pkg list package-name
```

- Get a file signature

```sh
pkg sign package-name
```

- Download a package

```sh
pkg fetch package-name
```

- Clean an extracted package

```sh
pkg clean package-name
```

- Create a package

```sh
pkg create package-name
```

- Extract a package

```sh
pkg extract package-name
```

- Replace `command` by one of the above options to get detailed information about them

```sh
pkg help command
```

Some commands needs to be run with `sudo` because the `/usr/bin` and `/pkg` folders are protected by the system.

The available packages can be found [here](https://static.redox-os.org/pkg/).

## Package format

Redox package manager uses the `pkgar` format instead of `tar`, if you see the packages list on CI server, there's `pkgar` and `tar.gz` files, the `pkgar` is the current package format and the `tar.gz` is the old package format.

[pkgar](https://www.redox-os.org/news/pkgar-introduction/), short for package archive, is a file format, library, and command line executable for creating and extracting cryptographically secure collections of files, primarly for use in package management on Redox OS. The technical details are still in development, so I think it is good to instead review the goals of pkgar and some examples that demonstrate its design principles.

The goals of pkgar are as follows:

- Atomic - updates are done atomically if possible
- Economical - transfer of data must only occur when hashes change, allowing for network and data usage to be minimized
- Fast - encryption and hashing algorithms are chosen for performance, and packages can potentially be extracted in parallel
- Minimal - unlike other formats such as tar, the metadata included in a pkgar file is only what is required to extract the package
- Relocatable - packages can be installed to any directory, by any user, provided the user can verify the package signature and has access to that directory.
- Secure - packages are always cryptographically secure, and verification of all contents must occur before installation of a package completes.
