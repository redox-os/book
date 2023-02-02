Side projects
=============

Redox is a complete Rust operating system.
In addition to the kernel, we are developing several side projects, including:

- [RedoxFS]: A file system inspired by ZFS.
- [Ion]: The Redox shell.
- [Orbital]: The display server of Redox.
- [pkgutils]: Redox's package management library and its command-line frontend.
- [Sodium]: A Vi-like editor.
- [ralloc]: A memory allocator.
- [libextra]: Supplement for libstd, used throughout the Redox code base.
- [games-for-redox]: A collection of mini-games for Redox (alike BSD-games).
- and a few other exciting projects you can explore [here].

We also have three utility distributions, which are collections of small, useful command-line programs:

- [Coreutils]: A minimal set of utilities essential for a usable system.
- [Extrautils]: Extra utilities such as reminders, calendars, spellcheck, and so on.
- [Binutils]: Utilities for working with binary files.

We also actively contribute to third party projects that are heavily used in Redox.

 - [uutils/coreutils]: Cross-platform Rust rewrite of the GNU coreutils.
 - [m-labs/smoltcp]: The network stack used by Redox.

What tools are fitting for the Redox distribution?
-------------------------------------------------

Some of these tools will in the future be moved out of the default distribution, into separate optional packages. Examples of these are Orbital, OrbTK, Sodium, and so on.

The listed tools fall into three categories:

1. **Critical**, which are needed for a full functioning and usable system.
2. **Ecosystem-friendly**, which are there for establishing consistency within the ecosystem.
3. **Fun**, which are "nice" to have and are inherently simple.

The first category should be obvious: an OS without certain core tools is a useless OS. The second category contains the tools which are likely to be non-default in the future, but nonetheless are in the official distribution right now, for the charm. The third category is there for convenience: namely for making sure that the Redox infrastructure is consistent and integrated (e.g., pkgutils, OrbTK, and libextra).

It is important to note we seek to avoid non-Rust tools, for safety and consistency (see [Why Rust]).

[RedoxFS]: https://gitlab.redox-os.org/redox-os/redoxfs
[Ion]: https://gitlab.redox-os.org/redox-os/ion
[Orbital]: https://gitlab.redox-os.org/redox-os/orbital
[OrbTK]: https://gitlab.redox-os.org/redox-os/orbtk
[pkgutils]: https://gitlab.redox-os.org/redox-os/pkgutils
[Sodium]: https://gitlab.redox-os.org/redox-os/sodium
[ralloc]: https://gitlab.redox-os.org/redox-os/ralloc
[libextra]: https://gitlab.redox-os.org/redox-os/libextra
[games-for-redox]: https://gitlab.redox-os.org/redox-os/games
[here]: https://gitlab.redox-os.org/redox-os

[Coreutils]: https://gitlab.redox-os.org/redox-os/coreutils
[Extrautils]: https://gitlab.redox-os.org/redox-os/extrautils
[Binutils]: https://gitlab.redox-os.org/redox-os/binutils

[uutils/coreutils]: https://github.com/uutils/coreutils
[m-labs/smoltcp]: https://github.com/m-labs/smoltcp

[Why Rust]: ./ch01-06-why-rust.md
