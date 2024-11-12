# Trying Out Redox

There are several games, demos and other things to try on Redox. Most of these are not included in the regular Redox build, so you will need to run the **demo** system. Available for download on the [build server x86-64 images](https://static.redox-os.org/releases/0.8.0/x86_64). Currently, Redox does not have Wi-Fi support, so if you need Wi-Fi for some of the things you want to do, you are best to [run Redox in a virtual machine](./running-vm.md). Most of the suggestions below do not require network access, except where multiplayer mode is available.

On the demo system, click on the Redox symbol in the bottom left corner of the screen. This brings up a menu, which, for the demo system, has some games listed. Feel free to give them a try!

Many of the available commands are in the folders `/usr/bin` and `/ui/bin`, which will be in your command path. Open a Terminal window and type `ls file:/usr/bin` (or just `ls /usr/bin`) to see some of the available commands. Some of the games listed below are in `/usr/games`, which is not in your command path by default, so you may have to specify the full path for the command.

## Programs

### FFMPEG

The most advanced multimedia library of the world.

- Run the following command to play a music:

```sh
ffplay music-name.mp3
```

(Change the video format according to your file)

- Run the following command to play a video:

```sh
ffplay video-name.mp4
```

(Change the music format according to your file)

### COSMIC Files

An advanced file manager written in Rust, similar to GNOME Nautilus.

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

Sodium is Redox's Vi-like editor. To try it out, open a terminal window and type `sodium`.

A short list of the Sodium defaults:

- `hjkl` - Navigation keys
- `ia` - Go to insert/append mode
- `;` - Go to command-line mode
- `shift-space` - Go to normal mode

For a more extensive list, write `;help`.

### Rusthello

Rusthello is an advanced Reversi AI, made by [HenryTheCat](https://github.com/HenryTheCat). It is highly concurrent, so this acts as a demonstration of Redox's multithreading capabilities. It supports various AIs, such as brute force, minimax, local optimizations, and hybrid AIs.

In a Terminal window, type `rusthello`.

Then you will get prompted for various things, such as difficulty, AI setup, and so on. When this is done, Rusthello interactively starts the battle between you and an AI or an AI and an AI.

## Games

### Freedoom

Freedoom is a first-person shooter in the form of content for a Doom engine. For Redox, we have included the PrBoom engine to run Freedoom. You can read more about Freedoom on the [Freedoom website](https://freedoom.github.io/). PrBoom can be found on the [PrBoom website](https://prboom.sourceforge.net/). Click on the **Redox** logo on the bottom left, and choose `Games`, then choose `Freedoom`. Or open a Terminal window and try `/games/freedoom1` or `/games/freedoom2`.

Hit `Esc` and use the arrow keys to select Options->Setup->Key Bindings for keyboard help.

### Neverball and Nevergolf

Neverball and Nevergolf are 3D pinball and golf respectively. Click on the **Redox** logo on the bottom left, and choose `Games`, then choose from the menu.

### Sopwith

Sopwith is a game allows you to control a small plane. Originally written in 1984, it used PC graphics, but is now available using the SDL library. In a Terminal window type `sopwith`.

- `Comma ( , )` - Pull back
- `Slash ( / )` - Push forward
- `Period ( . )` - Flip aircraft
- `Space` - Fire gun
- `B` - Drop Bomb

### Syobonaction

Syobon Action is 2D side-scrolling platformer that you won't enjoy. In a Terminal window, type `syobonaction`. It's recommended that you read the [GitHub page](https://github.com/angelXwind/OpenSyobonAction) so you don't blame us.

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
