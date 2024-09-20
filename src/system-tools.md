# System Tools

### coreutils

Coreutils is a collection of basic command line utilities included with Redox (or with Linux, BSD, etc.). This includes programs like `ls`, `cp`, `cat` and various other tools necessary for basic command line interaction.

Redox use the Rust implementation of the GNU Coreutils, [uutils](https://github.com/uutils/coreutils).

Available programs:

- `ls` - Show the files and folders of the current directory.
- `cp` - Copy and paste some file or folder.
- `cat` - Show the output of some text file.
- `chmod` - Change the permissions of some file or directory.
- `clear` - Clean the terminal output.
- `dd` - Copies and converts a file.
- `df` - Show the disk partitions information.
- `du` - Shows disk usage on file systems.
- `env` - Displays and modifies environment variables.
- `free` - Show the RAM usage.
- `kill` - Kill a process.
- `ln` - Creates a link to a file.
- `mkdir` - Create a directory.
- `ps` - Show all running processes.
- `reset` - Restart the terminal to allow the command-line input.
- `shutdown` - Shutdown the system.
- `sort` - Sort, merge, or sequence check text files.
- `stat` - Returns data about an inode.
- `tail` - Copy the last part of a file.
- `tee` - Duplicate the standard output.
- `test` - Evaluate expression.
- `time` - Count the time that some command takes to finish it's operation.
- `touch` - Update the timestamp of some file or folder.
- `uname` - Show the system information, like kernel version and architecture type.
- `uptime` - Show how much time your system is running.
- `which` - Show the path where some program is located.

### userutils

Userutils contains the utilities for dealing with users and groups in Redox OS.

They are heavily influenced by Unix and are, when needed, tailored to specific Redox use cases.

These implementations strive to be as simple as possible drawing particular
inspiration by BSD systems. They are indeed small, by choice.

Available programs:

- `getty` - Used by `init(8)` to open and initialize the TTY line, read a login name and invoke `login(1)`.
- `id` - Displays user identity.
- `login` - Allows users to login into the system
- `passwd` - Allows users to modify their passwords.
- `su` - Allows users to substitute identity.
- `sudo` - Enables users to execute a command as another user.
- `useradd` - Add a user
- `usermod` - Modify user information
- `userdel` - Delete a user
- `groupadd` - Add a user group
- `groupmod` - Modify group information
- `groupdel` - Remove a user group

### extrautils

Some additional command line tools are included in extrautils, such as `less`, `grep`, and `dmesg`.

Available programs:

- `calc` - Do math operations.
- `cur` - Move terminal cursor keys using `vi` keybindings.
- `dmesg` - Show the kernel message buffer.
- `grep` - Search all text matches in some text file.
- `gunzip` - Decompress `tar.gz` archives.
- `gzip` - Compress files into `tar.gz` archives.
- `info` - Read Markdown files with help pages.
- `keymap` - Change the keyboard map.
- `less` - Show the text file content one page at a time.
- `man` - Show the program manual.
- `mdless` - Pager with Markdown support.
- `mtxt` - Various text conversions, like lowercase to uppercase.
- `rem` - Countdown tool.
- `resize` - Print the size of the terminal in the form of shell commands to export the `COLUMNS` and `LINES` environment variables.
- `screenfetch` - Show system information.
- `tar` - Manipulate `tar` archives.
- `unzip` - Manipulate `zip` archives.
- `watch` - Repeat a command every 2 seconds.

### binutils

Binutils contains utilities for manipulating binary files.

Available programs:

- `hex` - Filter and show files in hexadecimal format.
- `hexdump` - Filter and show files in hexadecimal format (better output formatting).
- `strings` - Find printable strings in files.

### contain

This program provides containers (namespaces) on Redox.

- [Repository](https://gitlab.redox-os.org/redox-os/contain)

### acid

The general-purpose test suite of Redox to detect crashes, regressions and race conditions.

- [Repository](https://gitlab.redox-os.org/redox-os/acid)

### resist

The POSIX test suite of Redox to see how much % the system is compliant to the [POSIX](https://en.wikipedia.org/wiki/POSIX) specification (more means better compatibility).

- [Repository](https://gitlab.redox-os.org/redox-os/resist)
