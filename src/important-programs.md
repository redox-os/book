# Important Programs

This page covers important programs and libraries supported by Redox as of October 2025. <!-- don't forget to update this date -->

Redox is designed to be source-compatible with POSIX and Linux applications, only requiring compilation or small patches.

This page contain programs that are known to work well on Redox or how well it was tested. All programs are compiled through our package cross-compilation system called Cookbook, which includes the configuration of all kinds of patches and forks that are required to make them run on Redox.

Everything on the following lists are tested on the x86_64 (Intel/AMD) CPU architecture, other CPU architectures may not have been tested yet.

## Compilers

The following compilers have been tested to build on Redox, but the runtime status varies:

| Name | Can cross-compile from Linux? | Can compile programs on Redox? | Compiled programs can run on Redox? |
|---|---|---|---|
| GCC 13 | Yes | Yes | Working Well |
| Rust 1.90 | Yes | Always Crashing | Working Well |
| Go 1.25 | Yes | Always Crashing | Always Crashing |
| Zig 0.15 | Not Known | Not Known | Not Known |

## Interpreters

The following interpreters have been tested to build on Redox, but the runtime status varies:

| Name | Can be compiled? | Works on Redox? |
| RustPython | Yes | Working Well |
| CPython 3.12 | Yes | Working Well |
| Lua 5.4 | Yes | Not Known |
| LuaJit 2.1 | Yes | Often Crashing |
| Node.js 24 | Yes | Always Crashing |
| PHP 8.4 | Yes | Mostly Well |

## GUI Libraries

Most GUI applications are running through Orbital (Redox display server and window manager), it supports the following GUI libraries:

- Mesa3D (OpenGL and EGL, via liborbital)
- SDL1 and SDL2 (via Mesa3D)
- winit (via orbclient)
- X11 (via TWM, which is via liborbital)

## Applications

The following programs are well known to be working:

| Name | GUI Backend | Working? |
|---|--|---|
| COSMIC Editor | winit | Working Well |
| COSMIC Files | winit | Working Well |
| COSMIC Reader | winit | Working Well |
| COSMIC Store | winit | Not Tested |
| COSMIC Terminal | winit | Working Well |
| Netsurf | SDL1 | Working Well |
| FFplay | SDL2 | Working Well |
| Servo | Mesa3D | Often Crashes |
| xterm | X11 | Working Well |
| xeyes | X11 | Working Well |

### Emulators

| Name | GUI Backend | Working? |
|---|---|---|
| DOSBox | SDL1 | Working Well |
| Mednafen | SDL2 | Working Well |
| MGBA | SDL1 | Working Well |
| RVVM | SDL1 | Working Well |

### Games

| Name  | GUI Backend | Working? |
|---|---|---|
| Freeciv | SDL2 | Working Well |
| Gigalomania | SDL1 | Working Well |
| Neverball | SDL2 | Working Well |
| OpenTTD | SDL1 | Working Well |
| OpenTyrian | SDL2 | Working Well |
| Prboom | SDL2 | Working Well |
| Quakespam | SDL2 | Working Well |
| SpaceCadet Pinball | SDL2 | Working Well |

## Servers

| Name | Working? |
|---|---|
| OpenSSH Daemon | Working Well |
| Nginx | Working Well |
| Simple HTTP Server | Working Well |
| Python Static Server | Not Tested |
| PHP-FPM | Not Tested |

## CLI Tools

The following CLI tools are known to be working. Programs listed below may not include [core utilites](./side-projects.md):

### Terminal Shells

| Name | Working? |
|---|---|
| GNU Bash | Working Well |
| Ion | Working Well |
| Nushell | Not Tested |
| Fish | Hangs |
| Zsh | Hangs |

### Text Editors

| Name | Working? |
|---|---|
| Kibi | Working Well |
| GNU Nano | Working Well |
| Vim | Working Well |
| Sodium | Working Well |
| Neovim | Crashes |

### System Monitors

| Name | Working? |
|---|---|
| Bottom | Working Well |
| Htop | Working Well |

### Development Tools

| Name | Working? |
|---|---|
| Git | Working Well |
| GNU Autotools | Not Tested |
| GNU Binutils | Working Well |
| GNU Grep | Working Well |
| GNU Make | Working Well |
| GNU Sed | Working Well |

### Media Tools

| Name | Working? |
|---|---|
| FFMPEG | Working Well |

### Archive Tools

| Name | Working? |
|---|---|
| Bzip2 | Working Well |
| Xz | Working Well |
| Xxhash | Working Well |
| Zstd | Working Well |

### Storage Tools

| Name | Working? |
|---|---|
| Ncdu | Not Tested |


### Network Tools

| Name | Working Status |
|---|---|
| OpenSSH Client | Not Tested |
| Curl | Working Well |
| GoAccess | Working Well |
| Rsync | Working Well |
| SQLite | Not Tested |
| Wget | Working Well |

## Other Programs

You can see all Redox components and ported programs on the [build server list](https://static.redox-os.org/pkg/x86_64-unknown-redox/).
