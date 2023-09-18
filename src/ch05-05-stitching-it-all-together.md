# Stiching it All Together

The "URL, scheme, resource" model is simply a unified interface for efficient inter-process communication. URLs are simply resource descriptors. Schemes are simply resource types, provided by scheme managers.

A quick, ugly diagram would look like this:

```
             /
             |                                                          +=========+
             |                                                          | Program |
             |                                                          +=========+
             |               +--------------------------------------+      ^   | write
             |               |                                      |      |   |
  User space <  +----- URL -----+                                   | read |   v
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
Kernel space <                 | Resolve |
             |                 +=========+
             \

```

> TODO improve diagram
