# Side Projects

Redox is a complete Rust operating system. In addition to the Redox kernel, our team is developing several side projects, including:

- [RedoxFS](https://gitlab.redox-os.org/redox-os/redoxfs) - Redox file system inspired by ZFS.
- [Ion](https://gitlab.redox-os.org/redox-os/ion) - The Redox shell.
- [Orbital](https://gitlab.redox-os.org/redox-os/orbital) - The desktop environment/display server of Redox.
- [pkgutils](https://gitlab.redox-os.org/redox-os/pkgutils) - Redox package manager, with a command-line frontend and library.
- [relibc](https://gitlab.redox-os.org/redox-os/relibc) - Redox C library.
- [audiod](https://gitlab.redox-os.org/redox-os/audiod) - Redox audio server.
- [bootloader](https://gitlab.redox-os.org/redox-os/bootloader) - Redox boot loader.
- [init](https://gitlab.redox-os.org/redox-os/init) - Redox init system.
- [installer](https://gitlab.redox-os.org/redox-os/installer) - Redox buildsystem builder.
- [netstack](https://gitlab.redox-os.org/redox-os/netstack) - Redox network stack.
- [redoxer](https://gitlab.redox-os.org/redox-os/redoxer) - A tool to run/test Rust programs inside of a Redox VM.
- [sodium](https://gitlab.redox-os.org/redox-os/sodium) - A Vi-like editor.
- [games](https://gitlab.redox-os.org/redox-os/games) - A collection of mini-games for Redox (alike BSD-games).
- [OrbTK](https://gitlab.redox-os.org/redox-os/orbtk) - Cross-platform Rust-written GUI toolkit (in maintenance mode).
- and a few other exciting projects you can explore on the [redox-os group](https://gitlab.redox-os.org/redox-os).

We also have some in-house tools, which are collections of small, useful command-line programs:

- [extrautils](https://gitlab.redox-os.org/redox-os/extrautils) -  Extra utilities such as reminders, calendars, spellcheck, and so on.
- [binutils](https://gitlab.redox-os.org/redox-os/binutils) - Utilities for working with binary files.

We also actively contribute to third-party projects that are heavily used in Redox.

 - [uutils/coreutils](https://github.com/uutils/coreutils) - Cross-platform Rust rewrite of the GNU Coreutils.
 - [smoltcp](https://github.com/m-labs/smoltcp) - The TCP/IP stack used by Redox.

## What tools are fitting for the Redox distribution?

The necessary tools for a usable system, we offer variants with fewer programs.

The listed tools fall into three categories:

1. **Critical**, which are needed for a full functioning and usable system.
2. **Ecosystem-friendly**, which are there for establishing consistency within the ecosystem.
3. **Fun**, which are "nice" to have and are inherently simple.

The first category should be obvious: an OS without certain core tools is a useless OS.
The second category is there for convenience: namely for making sure that the Redox infrastructure is consistent and integrated. 
The third category contains the tools which are likely to be non-default in the future, but nonetheless are in the official distribution right now, for the charm. 
