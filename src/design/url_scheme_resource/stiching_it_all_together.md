Stiching it all together
========================

The "URL, scheme, resource" model is simply a unified interface for efficient inter-process communication. URLs are simply resource descriptors. Schemes are simply resource "entries", which can be opened. You can think of a scheme as a closed book. It cannot itself be read or written, but you can open it to an open book: a resource. Resources are simply primitives for communications. They can behave either socket-like (as a stream of bytes, e.g. TCP and Orbital) or file-like (as an on-demand byte buffer, e.g. file systems and stdin).

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
