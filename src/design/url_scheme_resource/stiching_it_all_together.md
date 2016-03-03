Stiching it all together
========================

The "URL, scheme, resource" model is simply an unified interface for efficient inter-process communication. URLs are simply resource descriptors. Schemes are simply resource "entries", which can be opened. You can think of schemes as closed book. They cannot itself be read or written, but you can opened them to an open book: A resource. Resources are simply primitives for communications. They can behave either socket-like (as a stream of bytes, e.g. TCP, Orbital) or file-like (as an on-demand byte buffer, e.g. file systems, stdin).

A quick, ugly diagram would look like this:

```
             /
             |                                                          +=========+
             |                                                          | Program |
             |                                                          +=========+
             |               +--------------------------------------+      ^   | write
             |               |                                      |      |   |
  Userspace  <  +----- URL -----+                                   | read |   v
             |  | +-----------+ |       open    +---------+  open   |   +----------+
             |  | |  Scheme   |-|---+  +------->| Scheme  |------------>| Resource |
             |  | +-----------+ |   |  |        +---------+             +----------+
             |  | +-----------+ |   |  |
             |  | | Reference | |   |  |
             |  | +-----------+ |   |  |
             \  +---------------+   |  |
                            resolve |  |
             /                      v  |
             |                 +=========+
 Kernelspace <                 | Resolve |
             |                 +=========+
             \

```

> TODO
