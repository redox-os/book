"Everything is an URL"
======================

"Everything is an URL" is an important principle in the design of Redox. Roughly speaking it means that the API, design, and ecosystem is centered around URLs, schemes, and resources as the main communication primitive. Applications communicate with each other, the system, daemons, etc, using URLs. As such, programs do not have to create their own constructs for communication.

By unifying the API in this way, you are able to have a consistent, clean, and flexible interface.

We can't really claim credits of this concept (beyond our exact design and implementation). The idea is not a new one and is very similar to _9P_ from _Plan 9_ by Bell Labs; a similar approach has been taken in Unix and its successors.

How it differs from "Everything is a file"
------------------------------------------

With "Everything is a file" all sorts of devices, processes, and kernel parameters can be accessed as files in a regular filesystem. This leads to absurd situations like the hard disk containing the root filesystem `/` contains a folder named `dev` with device files including `sda` which contains the root filesystem. Situations like this are missing any logic. Furthermore many file properties don't make sense on these 'special files': What is the size of `/dev/null` or a configuration option in sysfs?

In contrast to "Everything is a file", Redox does not enforce a common tree node for all kinds of resources. Instead resources are distinguished by protocol. This way USB devices don't end up in a "filesystem", but a protocol-based scheme like `EHCI`. Real files are accessible through a scheme called `file`, which is widely used and specified in [RFC 1630] and [RFC 1738].

[RFC 1630]: https://tools.ietf.org/html/rfc1630
[RFC 1738]: https://tools.ietf.org/html/rfc1738
