# Stiching it All Together

The "path, scheme, resource" model is simply a unified interface for efficient inter-process communication.
Paths are simply resource descriptors. Schemes are simply resource types, provided by scheme managers.

A quick, ugly diagram would look like this:

```
             /
             |                                                          +=========+
             |                                                          | Program |
             |                                                          +=========+
             |               +--------------------------------------+      ^   | write
             |               |                                      |      |   |
  User space <  +---- Path -----+                                   | read |   v
             |  | +-----------+ |       open    +---------+  open   |   +----------+
             |  | |  Scheme   |-|---+  +------->| Scheme  |------------>| Resource |
             |  | +-----------+ |   |  |        +---------+             +----------+
             |  | +-----------+ |   |  |
             |  | | Reference | |   |  |
             |  | +-----------+ |   |  |
             \  +---------------+   |  |
                            resolve |  |
----------------------------------------------------------------------------------------
             /                      |  |
             |                      v  |
             |                 +=========+
Kernel space <                 | Resolve |
             |                 +=========+
             \

```

> TODO improve diagram
