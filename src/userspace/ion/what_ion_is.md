# What Ion is?

## 1. Default shell in Redox

### What shell is?
A shell is a layer around operating system kernel and libraries, that allows users to interact with operating system. That means shell can be used on any operating system (Ion runs on both Linux and Redox) or implementation of standard library as long as the provided API is the same. Shells can either be graphical (GUI) or command-line (CLI).

### Text shells

Text shells are programs that provide interactive user interface with an operating system. Shell reads from users as they type and perform some operation according to the input. This is similar to read-eval-print loop (REPL) found in many programming languages (e.g. Python).

### Typical \*nix shells

Probably the most famous shell is **Bash** that can be found in vast majority of Linux distributions and also in macOS (formerly known as Mac OS X). On the other hand, FreeBSD uses **tcsh** by default.

There is much more shell implementations but these two form the base of two fundamentally different sets:
 * Bourne shell syntax (bash, sh, zsh)
 * C shell syntax (csh, tcsh)

Of course these two groups are not exhaustive; it is worth mentioning at least **fish** shell and **xonsh** that are trying to abandon some features of old-school shell to make the language more sane and also safe.

### Fancy features

Writing commands without any help from the shell would be very exhausting and impossible to use for everyday work. Therefor most shells (including Ion of course!) include features such as commands history, autocompletion based on history or man pages, shortcuts to speed-up typing etc.

## 2. Scripting language

Ion can also be used to write simple scripts for common tasks or configuration of system after startup. It is not meant as fully-featured programming language, but more like a glue to connect other programs together.

### Relation to terminals

Early [terminals](https://en.wikipedia.org/wiki/Computer_terminal) were devices used to communicate with large computer systems like [IBM mainframes](https://en.wikipedia.org/wiki/IBM_mainframe). Nowadays Unix operating systems usually implement so called virtual terminals (tty stands for teletypewriter ... whoa!) and terminal emulators (e.g. xterm, gnome-terminal).

Terminal is used to read input from keyboard and display textual output of shell and other programs running inside it. This means that terminal converts key strokes into control codes that are further used by shell. The shell provides user with command line prompt (for instance user name and working directory) , line edition capabilities (Ctrl + a,e,u,k...), history and runs other programs (ls, uname, vim etc. ) according to user's input.  

TODO: In Linux we have device files like `/dev/tty`, how is this concept handled in Redox?

<!---
Sources:
http://hyperpolyglot.org/unix-shells
http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html
https://en.wikipedia.org/wiki/Shell_(computing)
http://unix.stackexchange.com/questions/4126/what-is-the-exact-difference-between-a-terminal-a-shell-a-tty-and-a-con
http://xonsh.org/
-->
