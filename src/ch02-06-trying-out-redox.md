Trying Out Redox
===============

Use F2 key to get to a login shell. User `user` can login without password. For `root`, the password is `password` for now. `help` lists builtin commands for your shell (ion). `ls /bin` will show a list of applications you can execute.

Use F3 key to switch to a graphical user interface (orbital). Log in with the same username/password combinations as above.

Use the F1 key to get back to kernel output.

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

Click the OrbTK demo app in the menu bar. This will open a graphical user interface that demonstrates the different widgets OrbTK currently supports.

[HenryTheCat]: https://github.com/HenryTheCat

Exploring netsurf-fb
--------------------
You may click on the world icon to start the netsurf-fb.  Please start the netsurf-fb app at the shell.
You can launch netsurf from the terminal and pipe its output to a file.
```
/usr/bin/netsurf-fb > netsurfDebug.txt
```

Now shutdown redox:  ctrl+alt+G and mouse-click the qemu app's close icon.

Once you're back at a terminal, mount the redox file system image:
```
make mount
```
The above gives you a new mountpoint:
```
/home/davidm/rustos/redox/build/filesystem
```

If you want to see all the mountpoint details you can run the "mount" command:
```
mount
/dev/fuse on /home/davidm/rustos/redox/build/filesystem type fuse (rw,nosuid,nodev,relatime,user_id=1000,group_id=1000)
```

Using your favorite text editor, have a look at /home/davidm/rustos/redox/build/filesystem/root/netsurfDebug.txt

When you are done looking at that netsurfDebug.txt file you can unmount the redox file system image.
```
make unmount
```
