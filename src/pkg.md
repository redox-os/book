# Downloading packages with pkg

[pkg](https://gitlab.redox-os.org/redox-os/pkgutils) is the Redox package manager which allows you to install binary packages to a running system. If you want to build packages, or include binary packages during the build, please see the [Including Programs in Redox](./including-programs.md) page.

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

The available packages can be found on the [build server list](https://static.redox-os.org/pkg/).
