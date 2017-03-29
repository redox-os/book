# Compiling your program

Consider this "hello world" program:


```rust
fn main() {
    println!("Hello World!");
}
```

To compile this program, you are going to need to edit some of your redox source files in such a way that your local redox repository will not be fit for updates via git or pull requests. It is reccomended that you do __not__ add the changes to the git history.

Step one: Go to redox/programs, and run `cargo new helloworld --bin`. It should create a directory redox/programs/helloworld with a redox/programs/helloworld/Cargo.toml like this:

```toml
[package]
name = "helloworld"
version = "0.1.0"
authors = ["Your Name <youremail@example.com>"]

[dependencies]
```
You want to compile a binary, so edit it so that it looks like this:

```toml
[package]
name = "helloworld"
version = "0.1.0"
authors = ["Your Name <youremail@example.com>"]

[[bin]]
name = "helloworld"
path = "src/main.rs"

[dependencies]
```

Step two: Note that binaries compiled from redox/programs have entries in the redox/Cargo.toml like this:

```toml
    "programs/userutils",
```

Add a line below it that points to the helloworld program:
```toml
    "programs/helloworld",
```

Step three: Open redox/mk/userspace. Notice how the target directories for the  binaries are listed after `userspace: \`, and that every line in that block has a `\` after it exept for the last one. Add a `\` to the last line of the block, and add

```toml
	filesystem/bin/helloworld
```

in a line inserted below.

Step four: Run `make` then `make qemu.` Do not run `make all`: it seems that the binary is not compiled to the correct location if `make all` is run.

Step five: Log in to redox, open the terminal, and run `helloworld`. It should print: "Hello World!"
