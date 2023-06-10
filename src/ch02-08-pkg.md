# Downloading packages with pkg

`pkg` is the Redox [package manager](https://gitlab.redox-os.org/redox-os/pkgutils) which allows you to add binary packages to a running system. If you want to compile packages, or include binary packages during the build, please see [Including Programs in Redox](./ch09-01-including-programs.md).

You may get better results in an emulator like QEMU than in real hardware (due to limited network devices support).

This tool can be used instead of `make rebuild` if you add a new recipe on your TOML config (`desktop.toml` for example).

- `pkg clean package-name` - Clean an extracted package
- `pkg create package-name` - Create a package
- `pkg extract package-name` - Extract a package
- `pkg fetch package-name` - Download a package
- `pkg install package-name` - Install a package
- `pkg list package-name` - List package contents
- `pkg sign package-name` - Get a file signature
- `pkg upgrade` - Upgrade all installed packages
- `pkg help command` - Replace `command` by one of the above options to have detailed information about them.

All commands needs to be run with `sudo` because `/bin` and `/pkg` belongs to root.

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
