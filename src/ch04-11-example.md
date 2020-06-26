An example.
===========

Enough theory! Time for an example.

We will implement a scheme which holds a vector, and push elements when you write, and pop them when you read. Let's call it `vec:`.

Let's get going:

The code
--------

So first of all we need to import the things, we need:

```rust
extern crate syscall; // add "redox_syscall: "*" to your cargo dependencies

use syscall::scheme::SchemeMut;
use syscall::error::{Error, Result, ENOENT, EBADF, EINVAL};

use std::cmp::min;
```

We start by defining our mutable scheme struct, which will implement the `SchemeMut` trait and hold the state of the scheme.

```rust
struct VecScheme {
    vec: Vec<u8>,
}

impl VecScheme {
    fn new() -> VecScheme {
        VecScheme {
            vec: Vec::new(),
        }
    }
}
```

First of all we implement, `open()`. Let it accept a reference, which will be the initial content of the vector.

Note that we do ignore `flags`, `uid` and `gid`.

```rust
impl SchemeMut for VecScheme {
    fn open(&mut self, path: &[u8], _flags: usize, _uid: u32, _gid: u32) -> Result<usize> {
        self.vec.extend_from_slice(path);
        Ok(path.len())
    }
```

So, now we implement read:

```rust
    fn read(&mut self, _id: usize, buf: &mut [u8]) -> Result<usize> {
        let res = min(buf.len(), self.vec.len());

        for b in buf {
            *b = if let Some(x) = self.vec.pop() {
                x
            } else {
                break;
            }
        }

        Result::Ok(res)
    }
```

Now, we will add `write`, which will simply push to the vector:

```rust
    fn write(&mut self, _id: usize, buf: &[u8]) -> Result<usize> {
        for &i in buf {
            self.vec.push(i);
        }

        Result::Ok(buf.len())
    }
}
```

In both our read and write implementation we ignored the `id` parameter for simplicity sake.

Note that leaving out the missing methods results in errors, when calling them, because of its default implementation.

Last, we need the `main` function:

```rust
fn main() {
    use syscall::data::Packet;
    use std::fs::File;
    use std::io::{Read, Write};
    use std::mem::size_of;

    let mut scheme = VecScheme::new();
    // Create the handler
    let mut socket = File::create(":vec").unwrap();
    loop {
        let mut packet = Packet::default();
        while socket.read(&mut packet).unwrap() == size_of::<Packet>() {
            scheme.handle(&mut packet);
            socket.write(&packet).unwrap();
        }
    }
}
```

How to compile and run this example
-----------------------------------

For the time being there is no easy way to compile and deploy binaries for/on the redox platform.

There is however a way and it goes as follows:

1. Add your folder (as a soft link) into your local Redox repository (e.g. schemes/);
2. Add your binary to the root Makefile (e.g. under the schemes target);
3. Compile Redox via `make`;

Note: Do **not** add your folder to the git history, this 3-step process is only meant for local testing purposes. Also make sure to name your folder and binary as specified in your binary's `cargo.toml`;

Now, go ahead and test it by running `make qemu` (or a variant)!

Exercises for the reader
------------------------

+ Compile and run the `VecScheme` example on the Redox platform;
+ There is also a Scheme trait, which is immutable. Come up with some use cases for this one;
+ Write a scheme that can run code for your favorite esoteric programming language;
