URLs
====

The URL _it self_ is a relatively uninteresting, yet very a important notion for the design of Redox. What is the interesting part is what it represents.

The URL
-------

In short, an URL is an identifier of a scheme. They contain two parts:

1. The scheme part. This part represents, the "receiver", i.e. what scheme will handle the (F)OPEN call. This can be any arbitrary UTF-8 string, and will often simply be the name of your protocol.

2. The reference part. This part represents the "payload" of the URL, namely what the URL refer to. Consider `file`, as an example. `file:`s reference is simply a path to a file. The reference can be any arbitrary byte string. The parsing, interpretation, and storage of the reference is left to the scheme. For this reason, it is not required to be a tree-like structure.

So, the string representation of an URL looks like:

```
[scheme]:[reference]
```

Note that `//` is not required, for convenience.

Opening an URL
--------------

URLs can be opened, yielding _schemes_, which can be read, written and (for some schemes) seeked (the are some more operations, these are described later on).I

For compatibility reasons, we use a file API similar to the Rust standard libraries for opening URLs:

```
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
