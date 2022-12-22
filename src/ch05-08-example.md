# An example.

Enough theory! Time for an example.

We will implement a scheme which holds a vector. The scheme will push elements
to the vector when it receives writes, and pop them when it is read. Let's call
it `vec:`.

The complete source for this example can be found at
[redox-os/vec_scheme_example](https://gitlab.redox-os.org/redox-os/vec_scheme_example).

## Setup

In order to build and run this example in a Redox environment, you'll need to
be set up to compile the OS from source. The process for getting a program
included in a local Redox build is laid out in
[Including Programs](./ch09-01-including-programs.html). Pause here and follow the `helloworld` example in that guide if
you want to get this example running.

This example assumes that `vec` was used as the name of the crate instead of
`helloworld`. The crate should therefore be located at
`cookbook/recipes/vec/source`.

Modify the `Cargo.toml` for the `vec` crate so that it looks something like
this:
```toml
[package]
name = "vec"
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

Notice that there are two binaries here. We'll need another program to interact with
our scheme, since CLI tools like `cat` use more operations than we strictly
need to implement for our scheme. The client uses only the standard library.

## The Scheme Daemon

Create `src/scheme.rs` in the crate. Start by `use`ing a couple of symbols.

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

Before implementing the scheme operations on our scheme struct, let's breifly
discuss the way that this struct will be used. Our program (`vec_scheme`) will
create the `vec` scheme by opening the corresponding scheme handler in the root
scheme (`:vec`).  Let's implement a `main()` that intializes our scheme struct
and registers the new scheme:

```rust
fn main() {
    let mut scheme = VecScheme::new();

    let mut handler = File::create(":vec")
        .expect("Failed to create the vec scheme");
}
```

When other programs open/read/write/etc against our scheme, the
Redox kernel will make those requests available to our program via this
scheme handler. Our scheme will read that data, handle the requests, and send
responses back to the kernel by writing to the scheme handler. The kernel will
then pass the results of operations back to the caller.

```rust
fn main() {
    // ...

    let mut packet = Packet::default();

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
don't need to worry about the gory details of the `Packet` struct.

In most Unix systems (Redox included!), a program needs to open a file before it
can do very much with it. Since our scheme is just a "virtual filesystem",
programs call `open` with the path to the "file" they want to interact with
when they want to start a conversation with our scheme.

For our vec scheme, let's push whatever path we're given to the vec:

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
`Scheme::handle` call.

The usize that we return here will be passed back to us as the `id` parameter of
the other scheme operations. This way we can keep track of different open files.
In this case, we won't make a distinction between two different programs talking
to us and simply return zero.

Similarly, when a process opens a file, the kernel returns a number (the file
descriptor) that the process can use to read and write to that file. Now let's
implement the read and write operations for `VecScheme`.

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

Note that each of the methods of the `SchemeMut` trait provide a default
implementation. These will all return errors since they are essentially
unimplemented. There's one more method we need to implement in order to prevent
errors for users of our scheme:

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

We simply open some "file" in our scheme, write some bytes to it, read some
bytes from it, and then spit those bytes out on stdout. Remember, it doesn't
matter what path we use, since all our scheme does is add that path to the vec.
In this sense, the vec scheme implements a global vector.

## Running the Scheme

Since we've already set up the program to build and run in the redox VM,
simply run:
- `touch filesystem.toml`
- `make qemu`

We'll need multiple terminal windows open in the QEMU window for this step.
Notice that both binaries we defined in our `Cargo.toml` can now be found in
`file:/bin` (`vec_scheme` and `vec`). In one terminal window, run
`sudo vec_scheme`. A program needs to run as root in order to register a new
scheme. In another terminal, run `vec` and observe the output.

## Exercises for the reader

- Make the vec scheme print out something whenever it gets events. For example,
  print out the user and group ids of the user who tries to open a file in the
  scheme.
- Create a unique vec for each opened file in your scheme. You might find a
  hashmap useful for this.
- Write a scheme that can run code for your favorite esoteric programming
  language.

