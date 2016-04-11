Schemes
=======

Schemes are the natural counter-part to URLs. URLs are opened to schemes, which can then be opened to yield a resource.

Schemes are named such that the kernel is able to uniquely identify them. This name is used in the `scheme` part of the URL.

Schemes are a generalization of file systems. It should be noted that schemes do not necessarily represent normal files; they are often a "virtual file" (i.e., an abstract unit with certain operations defined on it).

Throughout the whole ecosystem of Redox schemes are used as the main communication primitive because they are a powerful abstraction. With schemes Redox can have one unified I/O interface.

Schemes can be defined both in user space and in kernel space but when possible user space is preferred.

Scheme operations
-----------------

What makes a scheme a scheme? Scheme operations!

A scheme is just a data structure with certain functions defined on it:

1. `open` - open the scheme. `open` is used for initially starting communication with a scheme; it is an optional method, and will default to returning `ENOENT`.

2. `mkdir` - make a new sub-structure. Note that the name is a little misleading (and it might even be renamed in the future), since in many schemes `mkdir` won't make a `directory`, but instead perform some form of substructure creation.

Optional methods include:

1. `unlink` - remove a link (that is a binding from one substructure to another).

2. `link` - add a link.
