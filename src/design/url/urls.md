URLs
====

The URL _itself_ is a relatively uninteresting (yet very important) notion for the design of Redox. The interesting part is what it represents.

The URL
-------

In short, a URL is an identifier of a resource. They contain two parts:

1. The scheme part. This represents the "receiver", i.e. what scheme will handle the (F)OPEN call. This can be any arbitrary UTF-8 string, and will often simply be the name of your protocol.

2. The reference part. This represents the "payload" of the URL, namely what the URL refers to. Consider `file`, as an example. A URL starting with `file:` simply has a reference which is a path to a file. The reference can be any arbitrary byte string. The parsing, interpretation, and storage of the reference is left to the scheme. For this reason, it is not required to be a tree-like structure.

So, the string representation of an URL looks like:

```
[scheme]:[reference]
```

For example:

```
file:/path/to/myfile
```

Note that `//` is not required, for convenience.

Opening a URL
-------------

URLs can be opened, yielding _schemes_, which can be opened to resources, which can be read, written and (for some resources) seeked (there are more operations which are described later on).

For compatibility reasons, we use a file API similar to the Rust standard library's for opening URLs:

```rust
use std::fs::OpenOptions;
use std::io::prelude::*;


fn main() {
    // Let's read from a TCP stream
    let tcp = OpenOptions::new()
                .read(true) // readable
                .write(true) // writable
                .open("tcp:0.0.0.0");
}
```

> TODO: Maybe do something with the tcp stream. Ping-pong?

> TODO: The terminology may be somewhat confusing for the reader.
