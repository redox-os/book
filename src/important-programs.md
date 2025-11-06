# Important Programs

This page covers important programs and libraries supported by Redox as of October 2025. <!-- don't forget to update this date -->

Redox is designed to be source-compatible with most Unix, Linux and POSIX-compliant applications, only requiring compilation.

This page lists programs that are known to work well on Redox or how well it was tested. All programs are compiled through our build system called cookbook, which includes all kinds of patches and forks that are required to make it run on Redox.

Everything on these lists are tested on the x86_64 architecture, other architecture test results may not have been tested yet.

## Compilers

These compilers have been tested to build on Redox, but the runtime result varies:

| Name | Can Cross-compile from Linux | Can compile programs on Redox | Compiled programs can run on Redox |
|---|---|---|---|
| GCC 13 | Yes | Yes | Working Well |
| RustPython | - | Yes | Working Well |
| Python 3.12 | - | Yes | Working Well |
| PHP 8.4 | - | Yes | Mostly Well |
| Rust 1.90 | Yes | Always Crashing | Working Well |
| LuaJit 2.1 | Yes | Not Known | Often Crashing |
| Go 1.25 | Yes | Always Crashing | Always Crashing |
| Node.js 24 | - | Always Crashing | Always Crashing |
| Lua 5.4 | Not Known | Not Known | Not Known |
| Zig 0.15 | Not Known | Not Known | Not Known |

## GUI Applications

Most GUI applications are running through Orbital, the official Redox GUI protocol. GUI Libraries that support orbital are:

- Mesa (OpenGL 1 and 2, EGL, via liborbital)
- SDL1 and SDL2 (via Mesa)
- Winit (Rust, via orbclient)
- X11 (via TWM, which is via liborbital)

These list are GUIs that are well known. There are also categories in tables below:

| Name | Rendering Library | Working Status |
|---|--|---|
| Cosmic Edit | Winit | Working Well |
| Cosmic Files | Winit | Working Well |
| Cosmic Reader | Winit | Working Well |
| Cosmic Store | Winit | Not Tested |
| Cosmic Term | Winit | Working Well |
| Netsurf | SDL1 | Working Well |
| FFplay | SDL2 | Working Well |
| Servo | Mesa | Often Crashes |
| Xterm | X11 | Working Well |
| Xeyes | X11 | Working Well |

### Emulators

| Name | Rendering Library | Working Status |
|---|---|---|
| Dosbox | SDL1 | Working Well |
| Mednafen | SDL2 | Working Well |
| MGBA | SDL1 | Working Well |
| RetroArch | SDL2 | Working Well |
| RVVM | SDL1 | Working Well |

### Games

| Name  | Rendering Library | Working Status |
|---|---|---|
| Freeciv | SDL2 | Working Well |
| Gigalomania | SDL1 | Working Well |
| Neverball | SDL2 | Working Well |
| OpenTTD | SDL1 | Working Well |
| OpenTyrian | SDL2 | Working Well |
| Prboom | SDL2 | Working Well |
| Quakespam | SDL2 | Working Well |
| SpaceCadet Pinball | SDL2 | Working Well |

## Server Tools and Daemon

| Name | Working Status |
|---|---|
| SSH Daemon | Working Well |
| Nginx | Working Well |
| Simple HTTP Server | Working Well |
| Python Static Server | Not Tested |
| PHP-FPM | Not Tested |

## CLI Tools

These CLI tools are known. Programs listed here may not include [core utilites](./side-projects.md):

### Terminals

| Name | Working Status |
|---|---|
| Bash | Working Well |
| Ion | Working Well |
| Nushell | Not Tested |
| Fish | Hangs |
| Zsh | Hangs |

### Editor

| Name | Working Status |
|---|---|
| Kibi | Working Well |
| Nano | Working Well |
| Vim | Working Well |
| Sodium | Working Well |
| Neovim | Crashes |

### System Monitors

| Name | Working Status |
|---|---|
| Bottom | Working Well |
| Htop | Working Well |

### Dev Tools

| Name | Working Status |
|---|---|
| Git | Working Well |
| GNU Autoconf | Not Tested |
| GNU Binutils | Working Well |
| GNU Grep | Working Well |
| GNU Make | Working Well |
| Sed | Working Well |

### File Tools

| Name | Working Status |
|---|---|
| FFMPEG | Working Well |
| Bzip2 | Working Well |
| Ncdu | Not Tested |
| Xz | Working Well |
| Xxhash | Working Well |
| Zstd | Working Well |

### Network Tools

| Name | Working Status |
|---|---|
| SSH Client | Not Tested |
| Curl | Working Well |
| GoAccess | Working Well |
| Rsync | Working Well |
| Sqlite | Not Tested |
| Wget | Working Well |

## Other Programs

You can see all Redox components and ported programs on the [build server list](https://static.redox-os.org/pkg/x86_64-unknown-redox/).
