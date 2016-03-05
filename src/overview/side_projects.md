Side projects
=============

Redox is a complete Rust operating system.
In addition to the kernel, we are developing several side projects, including:

- An implementation of ZFS.
- Ion: The Redox shell.
- Orbital: The display server of Redox.
- OrbTK: A widget toolkit.
- Oxide: Redox's package manager.
- Sodium: A Vi-like editor.

We also have three utility distributions, which are collections of small, useful command-line programs:
- Coreutils: A minimal set of utilities essential for a usable system.
- Extrautils: Extra utilities such as reminders, calendars, spellcheck, and so on.
- Binutils: Utilities for working with binary files.

We chose to implement these programs ourselves because we feel that there is room for innovation in many core operating system tools.
By creating our own implementations we can ensure that they work on Redox as both the kernel and the tools evolve.
Furthermore, since all of these programs are written in Rust we get all of the benefits discussed in [Why Rust].

[Why Rust]: introduction/why_rust.html
