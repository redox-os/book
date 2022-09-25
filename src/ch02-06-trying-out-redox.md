Trying Out Redox
===============

After a successful build, you can run Redox on an emulator with
```sh
$ make qemu
or
$ make virtualbox
```

To install Redox on real hardware, after `make live`, copy `~/tryredox/redox/build/livedisk.iso` to a USB thumbdrive with your preferred USB writer, using the "clone" method, and boot your computer from the USB drive.

During boot, Redox will ask you to select from a list of supported screen resolutions. Once you have selected your resolution, the boot process will complete and the Redox login screen will appear.

User `user` can login without a password. For `root`, the password is `password`. Once logged in, you can use Redox's **Orbital** UI much like a typical desktop UI. Click on the Terminal icon to start a shell window, using Redox's **Ion** shell. `help` lists builtin commands for your shell. `ls /bin` will show a list of applications you can execute.

On real hardware, to switch between **Orbital** and the console, use the following keys:
- F1: Display the console log messages
- F2: Open a text-only terminal
- F3: Return to the **Orbital** UI

Sodium
------

Sodium is Redox's Vi-like editor. To try it out,
1. Open the terminal by clicking the icon in the button bar
2. Type `sudo pkg install sodium` to install Sodium. You will need network for this.
3. Type `sodium`. This should now open up a separate editor window.

A short list of the Sodium defaults:

- `hjkl`: Navigation keys.
- `ia`: Go to insert/append mode.
- `;`: Go to command-line mode.
- shift-space: Go to normal mode.

For a more extensive list, write `;help`.

Setting a reminder/countdown
----------------------------

To demonstrate the ANSI support, we will play around with fancy reminders.

Open up the terminal emulator. Now, write `rem -s 10 -b`. This will set a 10 sec. countdown with progress bar.

Playing around with Rusthello
-----------------------------

Rusthello is an advanced Reversi AI, made by [HenryTheCat]. It is highly concurrent, so this proves Redox's multithreading capabilities. It supports various AIs, such as brute forcing, minimax, local optimizations, and hybrid AIs.

Oh, let's try it out!

```sh
# install rusthello by typing command
$ sudo pkg install games
# start it with command
$ rusthello
```

Then you will get prompted for various things, such as difficulty, AI setup, and so on. When this is done, Rusthello interactively starts the battle between you and an AI or an AI and an AI.

Exploring OrbTK
---------------

If available, click the OrbTK demo app in the menu bar. This will open a graphical user interface that demonstrates the different widgets OrbTK currently supports.

[HenryTheCat]: https://github.com/HenryTheCat
