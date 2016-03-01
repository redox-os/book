Schemes
=======

Schemes are the natural counter-part to URLs. As described before, URLs are opened to schemes, which can then be communicated with, through scheme operations.

Schemes are named so that the kernel is able to identify them. This name is used in the `scheme` part of the URL.

Schemes are a generalization of file systems. It should be noted that schemes are not necessarily representing normal files; often they are "virtual file", that is, an abstract unit with certain operations defined on it.

Throughout the whole ecosystem of Redox, schemes are used as the main communication primitive, because they are a really powerful abstraction. Namely, we have one unified interface.

Schemes can be defined both in userspace and in kernelspace, although, when possible, userspace is preferred.

Scheme operations
-----------------

What makes a scheme a scheme? Scheme operations!

A scheme is just a data structure with certain function defined on it:

1. `open` - open the scheme. `open` is used for initially opening the communication with a scheme, it is an optional method, and will default to returning `ENOENT`.

2. `mkdir` - make a new sub-structure. Note that the name is a little misleading (and it might even be renamed in the future), since in many schemes `mkdir` won't make a `directory`, but instead perform some form of substructure creation.

Less important optional methods are:

1. `unlink` - remove a link (that is a binding from one substructure to another).

2. `link` - add a link.
