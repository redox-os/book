# Downloading packages with pkg

[pkg](https://gitlab.redox-os.org/redox-os/pkgutils) is the Redox package manager installing binary packages to a running system. If you want to build packages, or include binary packages during the build, please see the [Including Programs in Redox](./including-programs.md) page.

Due to limited device support, you may get better results in an virtual machine than on real hardware.

The most commonly used `pkg` commands are show below:

- Install a package:

  ```sh
  sudo pkg install <package-name>
  ```

- Upgrade all installed packages:

  ```sh
  sudo pkg upgrade
  ```

- List package contents:

  ```sh
  pkg list <package-name>
  ```

- Get a file signature:

  ```sh
  pkg sign <package-name>
  ```

- Download a package:

  ```sh
  pkg fetch <package-name>
  ```

- Clean an extracted package:

  ```sh
  pkg clean <package-name>
  ```

- Create a package:

  ```sh
  pkg create <package-name>
  ```

- Extract a package:

  ```sh
  pkg extract <package-name>
  ```

- Get detailed information about one of the above options:

  ```sh
  pkg help <pkg-command>
  ```

> 📝 **Note:** Some `pkg` commands must be run with `sudo` because they manipulate the contents of protected folders: `/usr/bin` and `/pkg`.

The available packages can be found on the [build server list](https://static.redox-os.org/pkg/).
