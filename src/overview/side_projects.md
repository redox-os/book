Side projects
=============

Redox is a complete Rust operating system.
In addition to the kernel, we are developing several side projects, including:

- An implementation of ZFS.
- Ion: The Redox shell.
- Orbital: The display server of Redox.
- OrbTK: A widget toolkit.
- Magnet: Redox's package manager.
- Sodium: A Vi-like editor.
- libmalloc: A memory allocator.
- libextra: Supplement for libstd, used throughout the Redox code base.
- games-for-redox: A collection of mini-games for Redox (alike BSD-games).

We also have three utility distributions, which are collections of small, useful command-line programs:
- Coreutils: A minimal set of utilities essential for a usable system.
- Extrautils: Extra utilities such as reminders, calendars, spellcheck, and so on.
- Binutils: Utilities for working with binary files.

What tools for fitting in the Redox distribution?
-------------------------------------------------

Some of these tools will in the future be moved out of the default distribution, into seperate optional magnet packages. Examples of these are Orbital, OrbTK, Sodium, and so on.

The listed tools fall into three categories:

1. Tools, which are needed for a full functioning and usable system.
2. Tools, which are "nice" to have and are inherently simple.
3. Tools, which are there for establishing consistency within the ecosystem.

The first category should be obvious: an OS without certain core tools is a useless OS. The second category contains the tools which are likely to be non-default in the future, but nonetheless are in the official distribution right now, for the charm. The third category is there for convenience: namely for making sure that the Redox infrastructure is consistent and integrated (e.g., Magnet, OrbTK, and libextra).

It is important to note we seek to avoid non-Rust tools, for safety and consistency (see [Why Rust]).

[Why Rust]: ./introduction/why_rust.html
