Exploring Redox
===============

Use F2 or F3 keys to get to a login shell. User `user` can login without password. For `root`, the password is `password` for now. `help` lists builtin commands for your shell (ion). `ls /bin` will show a list of applications you can execute.

Use F4 key to switch to a graphical user interface (orbital). Log in with the same username/password combinations as above.

Use the F1 key to get back to kernel output.

Sodium
------

Sodium is Redox's Vi-like editor. In the menu-bar, pick the icon with `Na` on it. This should now open up an editor window.

A short list of the Sodium defaults:

- `hjkl`: Navigation.
- `ia`: Go to insert mode.
- `;`: Go to command-line mode.
- shift-space: Go to normal mode.

For a more extensive list, write `;help`.

Setting a reminder/countdown
----------------------------

To demonstrate the ANSI support, we will play around with fancy reminders.

Open up the terminal emulator. Now, write `rem -s 10 -b`. This will set a 10 sec. countdown with progress bar.

Playing around with Rusthello
-----------------------------

Rusthello is an advanced Reversi AI, made by [Enrico]. It is highly concurrent, so this proves Redox's multithreading capabilities. It supports various AIs, such as brute forcing, minimax, local optimizations, and hybrid AIs.

Oh, let's try it out!

```sh
# first we `cd` to the Rusthello directory
$ cd apps/rusthello
# now, run the binary file
$ ./main.bin
```

Then you will get prompted for various things, such as difficulty, AI setup, and so on. When this is done, Rusthello interactively starts the battle between you and an AI or an AI and an AI.

Exploring OrbTK
---------------

Click the OrbTK demo app in the menu bar. Now, this will open up a graphical user interface, demonstrating the different widgets, OrbTK currently supports.

[Enrico]: https://github.com/EGhiorzi
