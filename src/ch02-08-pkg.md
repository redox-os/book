# Downloading packages with pkg

`pkg` is the Redox [package manager](https://gitlab.redox-os.org/redox-os/pkgutils) which allows you to add binary packages to a running system. If you want to compile packages, or include binary packages during the build, please see [Including Programs in Redox](./ch09-01-including-programs.md).

You may get better results in an emulator like QEMU than in real hardware (due to limited network devices support).

This tool can be used instead of `make rebuild` if you add a new recipe on your TOML config (`desktop.toml` for example).

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

- Download a package

```sh
pkgfetch package-name
```

- Install a package

```sh
pkg install package-name
```

- List package contents

```sh
pkg list package-name
```

- Get a file signature

```sh
pkg sign package-name
```

- Upgrade all installed packages

```sh
pkg upgrade
```

- Replace `command` by one of the above options to have detailed information about them

```sh
pkg help command
```

All commands needs to be run with `sudo` because `/bin` and `/pkg` belongs to root.

The available packages can be found [here](https://static.redox-os.org/pkg/).
