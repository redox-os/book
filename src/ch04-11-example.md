# An example.

Enough theory! Time for an example.

We will implement a scheme which holds a vector. It will push elements when
it receives writes, and pops them when it is read. Let's call it `vec:`.

The complete source for this example can be found at
[redox-os/vec_scheme_example](https://gitlab.redox-os.org/redox-os/vec_scheme_example).

## Setup

In order to build and run this example in a redox environment, you'll need to
compile the OS from source. The process for getting a program included in a
redox build is laid out in [chapter 5](ch05-03-compiling-program.md). Follow
that example to get a hello world program running.

This page assumes that `vec` was used as the name of the
program instead of `helloworld`; the project's files are assumed to be at
`cookbook/recipes/vec/source`.

After following the hello world guide, modify the `Cargo.toml` so that it looks
something like this:
```toml
[package]
name = "vec_scheme"
version = "0.1.0"
edition = "2018"

[[bin]]
name = "vec_scheme"
path = "src/scheme.rs"

[[bin]]
name = "vec"
path = "src/client.rs"

[dependencies]
redox_syscall = "^0.2.6"
```

Notice there are two binaries here. We'll need another program to interact with
our scheme, since shell tools like `cat` use more operations than we strictly
need to implement for our scheme. The client uses only the standard library.

## The Scheme Daemon

Create `src/scheme.rs` in your cargo project. We'll need a couple of symbols as
we work through the code:

```rust
use std::cmp::min;
use std::fs::File;
use std::io::{Read, Write};

use syscall::Packet;
use syscall::scheme::SchemeMut;
use syscall::error::Result;
```

We start by defining our mutable scheme struct, which will implement the
`SchemeMut` trait and hold the state of the scheme.

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

Before implementing the scheme operations on our scheme struct, let's discuss
breifly the way that this struct will be used. Our binary (`vec_scheme`) will
create the `vec` scheme by opening the corresponding scheme handler in the root
scheme (`:vec`).  Let's implement a `main()` that does that:

```rust
fn main() {
    let mut scheme = VecScheme::new();
    let mut packet = Packet::default();

    let mut handler = File::create(":vec")
        .expect("Failed to create the vec scheme");
}
```

When other programs open/read/write/etc against our scheme, the
Redox kernel will make those requests available to our program via this
scheme handler. Our scheme will read that data, handle the requests, and send
responses back to the kernel by writing to the scheme handler. The kernel will
then pass the results of operations back to whoever made the requests.

```rust
fn main() {
    // ...

    loop {
        // Wait for the kernel to send us requests
        let read_bytes = handler.read(&mut packet)
            .expect("vec: failed to read event from vec scheme handler");

        if read_bytes == 0 {
            // Exit cleanly
            break;
        }

        // Scheme::handle passes off the info from the packet to the individual
        // scheme methods and writes back to it any information returned by
        // those methods.
        scheme.handle(&mut packet);

        handler.write(&packet)
            .expect("vec: failed to write response to vec scheme handler");
    }
}
```

Now let's deal with the specific operations on our scheme. The
`scheme.handle(...)` call dispatches requests to these methods, so that we
don't need to worry about the gory details of picking apart the `Packet` struct
itself.

In most Unix systems (Redox included!), a program needs to open a file before it
can do very much with it. Our scheme is just a "virtual filesystem", so opens
are the way any program starts a conversation with our scheme. Let's set that
up:

```rust
impl SchemeMut for VecScheme {
    fn open(&mut self, path: &str, _flags: usize, _uid: u32, _gid: u32) -> Result<usize> {
        self.vec.extend_from_slice(path.as_bytes());
        Ok(0)
    }
}
```

Say a program calls `open("vec:/hello")`. That call will work it's way through
the kernel and end up being dispatched to this function through our
`Scheme::handle` call. Just for fun, we push the path that we're passed to the
vec.

The usize that we return here will be passed back to us as the `id` parameter of
the other scheme operations. This way we can keep track of different open files.
In this case, we won't make a distinction between two different programs talking
to us and simply return zero.

Now let's do our read and write operations. These are the real meat of our
scheme.

```rust
impl SchemeMut for VecScheme {
    // ...

    // Fill up buf with the contents of self.vec, starting from self.buf[0].
    // Note that this reverses the contents of the Vec.
    fn read(&mut self, _id: usize, buf: &mut [u8]) -> Result<usize> {
        let num_written = min(buf.len(), self.vec.len());

        for b in buf {
            if let Some(x) = self.vec.pop() {
                *b = x;
            } else {
                break;
            }
        }

        Ok(num_written)
    }

    // Simply push any bytes we are given to self.vec
    fn write(&mut self, _id: usize, buf: &[u8]) -> Result<usize> {
        for i in buf {
            self.vec.push(*i);
        }

        Ok(buf.len())
    }
}
```

Note that all the methods of the `SchemeMut` trait provide default
implementations. These all return errors since they should be treated as
unimplemented. There's one more method we need to implement in order to prevent
errors for anybody using our scheme:

```rust
impl SchemeMut for VecScheme {
    // ...

    fn close(&mut self, _id: usize) -> Result<usize> {
        Ok(0)
    }
}
```

Most languages' standard libraries call close automatically when a file object
is destroyed, and Rust is no exception.

To see all the possitble operations on schemes, check out the
[API docs](https://docs.rs/redox_syscall/).

## A Simple Client

As mentioned earlier, we need to create a very simple client in order to use our
scheme, since some command line tools (like `cat`) use operations other than
open, read, write, and close. Put this code into `src/client.rs`:

```rust
use std::fs::File;
use std::io::{Read, Write};

fn main() {
    let mut vec_file = File::open("vec:/hi")
        .expect("Failed to open vec file");

    vec_file.write(b" Hello")
        .expect("Failed to write to vec:");

    let mut read_into = String::new();
    vec_file.read_to_string(&mut read_into)
        .expect("Failed to read from vec:");

    println!("{}", read_into); // olleH ih/
}
```

We simply open some file in our scheme, write some bytes to it, read some bytes
from it, and then spit those bytes out on stdout. Remember, it doesn't matter
what path we use, since all our scheme does is add it to the global vec.

## Running the Scheme

Since you've already set up the program to build and run in the redox VM,
simply:
- `touch filesystem.toml`
- `make qemu`

You'll need multiple terminal windows in the qemu windows for this one. You'll
notice that both binaries we defined in our `Cargo.toml` can now be found in
`file:/bin` (`vec_scheme` and `vec`). In one terminal window, run `vec_scheme`.
It should just hang out there. In another terminal, run `vec` and observe the
output. It's that simple!

## Exercises for the reader

- Make the vec scheme print out something whenever it gets events. For example,
  print out the user and group ids of the user who tries to open a file in the
  scheme.
- Create a unique vec for each opened file in your scheme. You might find a
  hashmap useful for this.
- Write a scheme that can run code for your favorite esoteric programming
  language.

