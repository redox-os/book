An example.
===========

Enough theory! Time for an example.

We will implement a scheme which holds a vector, and push elements when you write, and pop them when you read. Let's call it `vec:`.

Let's get going:

The code
--------

So first of all we need to import the things, we need:

```rust
use system::scheme::Scheme;
use system::error::{Error, Result, ENOENT, EBADF, EINVAL};
use std::cmp::min;
```

We start by defining our scheme struct, which will implement the `Scheme` trait and hold the state of the scheme.

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

Note that we do ignore `flags` and `mode`.

```rust
impl Scheme for VecScheme {
    fn open(&mut self, path: &str, _flags: usize, _mode: usize) -> Result<usize> {
        self.vec = path.as_bytes().to_owned();
        Result::Ok(path.len())
    }
```

So, now we implement read

```rust
    fn read(&mut self, _: usize, buf: &mut [u8]) -> Result<usize> {
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
    fn write(&mut self, _: usize, buf: &[u8]) -> Result<usize> {
        for &i in buf {
            self.vec.push(i);
        }

        Result::Ok(buf.len())
    }
}
```

Note that leaving out the missing methods results in errors, when calling them.

Last, we need the `main` function:

```rust
fn main() {
   use system::scheme::Packet;

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

Now, go ahead and test it!

Exercise for the reader
------------------------

Write a scheme that can run `Brainfuck` code.
