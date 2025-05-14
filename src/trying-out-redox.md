# Trying Out Redox

There are several programs, games, demos and other things to try on Redox. Most of these are not included in the regular Redox build, so you will need to run the `demo` variant from the list of available Redox images. Currently, Redox does not have Wi-Fi support, so if you need Wi-Fi for some of the things you want to do, you are best to use an Ethernet cable or [run Redox in a virtual machine](./running-vm.md). Most of the suggestions below do not require Internet access.

On the `demo` variant, click on the Redox symbol in the bottom left corner of the screen. This brings up a menu, which, for the `demo` variant, includes some games. Feel free to give them a try!

Many of the available commands are in the folders `/usr/bin` and `/ui/bin`, which are included in your command path. Open a Terminal window and type `ls /usr/bin` (or `ls /scheme/file/usr/bin`) to see some of the available commands.

> 💡 **Note:** some of the games listed below are installed in the `/usr/games` directory, which is not detected in the terminal shell by default. To run these games from the terminal, you may have to specify the path of their executables.

## Programs

### FFMPEG

The most advanced multimedia library of the world.

- Run the following command to play an audio file:

```sh
ffplay music-name.mp3
```

(Change the audio format according to your file)

- Run the following command to play a video file:

```sh
ffplay video-name.mp4
```

(Change the video format according to your file)

### COSMIC Files

An advanced file manager written in Rust, similar to GNOME Nautilus or Files.

### COSMIC Editor

An advanced text editor written in Rust, similar to KDE KWrite.

### Git

Git is a tool used for source code management.

- Run the following command to download a Git repository:

```sh
git clone repository-link
```

(Replace the "repository-link" part with your repository URL)

### RustPython

RustPython is a Python 3.11+ interpreter written in Rust.

- Run the following command to run your Python script:

```sh
rustpython script-name.py
```

(The [PyPI](https://pypi.org/) dependency manager is supported)

### Periodic Table

The Periodic Table `/ui/bin/periodictable` is a demonstration of the **OrbTk** user interface toolkit.

### Sodium

Sodium is Redox's Vi-like editor. To try it out, run the `sodium` command from a terminal.

A short list of the Sodium defaults:

| Keys | Function |
|:---- |:-------- |
| `h`, `j`, `k`, `l` | Navigation keys |
| `i`, `a` | Enter "Insert" mode |
| `;` | Enter "Prompt" mode |
| `shift-space` | Enter "Normal" mode |

For a more extensive list, run `:help` from within Sodium.

### Rusthello

Rusthello is an advanced Reversi AI, made by [HenryTheCat](https://github.com/HenryTheCat). It is highly concurrent, so this acts as a demonstration of Redox's multithreading capabilities. It supports various AIs, such as brute force, minimax, local optimizations, and hybrid AIs.

In a Terminal window, type `rusthello`.

Then you will get prompted for various things, such as difficulty, AI setup, and so on. When this is done, Rusthello interactively starts the battle between you and an AI or an AI and an AI.

## Games

### Freedoom

Freedoom is a first-person shooter in the form of content for a Doom engine. For Redox, we have included the PrBoom engine to run Freedoom. You can read more about Freedoom on the [Freedoom website](https://freedoom.github.io/). PrBoom can be found on the [PrBoom website](https://prboom.sourceforge.net/).

Freedoom can be run by selecting its entry from the "Games" section of the Orbital system menu, or by running either `/usr/games/freedoom1` or `/usr/games/freedoom2` from a terminal.

Hit `Esc` and use the arrow keys to select Options->Setup->Key Bindings for keyboard help.

### Neverball and Nevergolf

Neverball and Nevergolf are 3D pinball and golf games, respectively. Both can be run from the Orbital system menu, under "Games".

### Sopwith

Sopwith is a game which allows players to pilot a small, virtual plane. The original game was written in 1984 and used PC graphics, but it is now presented to users using the SDL library. To play it, run the `sopwith` command from a terminal.

| Control Key | Description |
|:----------- |:----------- |
| Comma (`,`) | Pull back |
| Slash (`/`) | Push forward |
| Dot (`.`) | Flip aircraft |
| Space | Fire gun |
| `b` | Drop bomb |

### Syobon Action

Syobon Action is 2D side-scrolling platformer that you *won't* enjoy. To play it, run `syobonaction` from a terminal window. It's recommended that you read the [GitHub page](https://github.com/angelXwind/OpenSyobonAction) so you don't blame us.

### Terminal Games Written in Rust

Also check out some games that have been written in Rust, and use the Terminal Window for simple graphics. In a Terminal window, enter one of the following commands:

- `baduk` - Baduk/Go
- `dem` - Democracy
- `flappy` - Flappy Bird clone
- `ice` - Ice Sliding Puzzle
- `minesweeper` - Minesweeper but it wraps
- `reblox` - Tetris-like falling blocks
- `redoku` - Sudoku
- `snake` - Snake
