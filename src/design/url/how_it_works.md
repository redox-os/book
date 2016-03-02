How do URLs work under the hood?
==============================

The representation
------------------

Since it is impossible to go from userspace to ring 0 in a typed manner, we have to use some weakly typed representation (that is, we can't use an enum, unless we want to do transmutions and friends). Therefore, we use a string-like representation when moving to kernel space. This is basically just a raw pointer to a C-like, null-terminating string. To avoid further overhead, we use more efficient representations:

# `Url<'a>`

The first of the three representations is the simplest one. It consists of an `struct` containing two fat pointers, representing the scheme and the reference respectively.

# `OwnedUrl`

This is a `struct` containing two `String`s (that is, growable, heap-allocated UTF-8 string), being the scheme and the reference respectively.

# `CowUrl<'a>`

This is a Copy-on-Write (CoW) URL, which, when mutated, gets cloned to heap. This way, you get efficient conditional allocation of the URL.

Not much fanciness here.

Opening an URL
--------------

> TODO
