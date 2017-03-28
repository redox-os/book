# Compiling your program

Consider this "hello world" program:


```rust
fn main() {
    println!("Hello Redox!");
}
```

To compile this program, you are going to need to edit some of your redox source files in such a way that your local redox repository will not be fit for updates via git or pull requests. It is reccomended that you do __not__ add the changes to the git history.

Step one: Go to a local copy of redox, and find a directory that userland binaries are compiled from. For the sake of a concrete example, go to redox/programs/extrautils/src/bin. Create a file helloworld.rs, and insert the code above into that file.

Step two: Find the Cargo.toml for the directory that you are compiling from, in this case, redox/programs/extrautils/Cargo.toml. Note how the files that are being compiled have lines like this:


```toml
[[bin]]
name = "grep"
path = "src/bin/grep.rs"
```
Copy one of these blocks, and paste it in some empty space before the `[dependencies]` section. Edit it so that it is appropriate for the "hello world" program, in this case:

```toml
[[bin]]
name = "helloworld"
path = "src/bin/helloworld.rs"
```

Step three: Open the makefile that configures which binaries are built from the directory you are compiling from, in this case, redox/mk/userspace/extrautils.mk. Notice how the programs being compiled have lines that look like this:

```
	filesystem/bin/mtxt \
	filesystem/bin/rem \
```

and that the last line of that block has no `\` after the name of the directory. These directory names, such as filesystem/bin/rem, point to where the binaries get compiled. Add a `\` to the last line of the block, and add an extra line to point to where you want your program compiled to, in this case:
```
	filesystem/bin/helloworld
```

Step four: Run `make` then `make qemu.` Do not run `make all`: it seems that the binary is not compiled to the correct location if `make all` is run.

Step five: Log in to redox, open the terminal, and run `helloworld`. It should print: "Hello Redox!"
