How do URLs work under the hood?
================================

Representation
--------------

Since it is impossible to go from user space to ring 0 in a typed manner we have to use some weakly typed representation (that is, we can't use an enum, unless we want to do transmutations and friends). Therefore we use a string-like representation when moving to kernel space. This is basically just a raw pointer to a C-like, null-terminating string. To avoid further overhead, we use more efficient representations:

# `Url<'a>`

The first of the three representations is the simplest one. It consists of a `struct` containing two fat pointers, representing the scheme and the reference respectively.

# `OwnedUrl`

This is a `struct` containing two `String`s (that is, growable, heap-allocated UTF-8 string), being the scheme and the reference respectively.

# `CowUrl<'a>`

This is a Copy-on-Write (CoW) URL, which, when mutated, gets cloned to heap. This way, you get efficient conditional allocation of the URL.

Not much fanciness here.

Opening a URL
-------------

Opening URLs happens through the `OPEN` system call. `OPEN` takes a C-like, null-terminating string, and two pointer-sized integers, keeping the open flags and the file mode, respectively.

The path argument of `OPEN` does not have to be an URL. For compatibility reasons, it will default to the `file:` scheme. If otherwise specified, the scheme will be resolved by the registrar (see [The root scheme]), and then opened.

> TODO

[The root scheme]: design/scheme/the_root_scheme.html
