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
