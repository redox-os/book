# "Everything is a URL"

"Everything is a URL" is a generalization of "Everything is a file", allowing broader use of this unified interface for a variety of purposes. Every resource that can be referenced by a program can be given a name in URL format.

"Everything is a URL" is an important principle in the design of Redox. Roughly speaking it means that the API, design, and ecosystem is centered around URLs, schemes, and resources as the main communication primitive. Applications communicate with each other, the system, daemons, etc, using URLs. As such, specialized system programs do not have to create their own constructs for communication.

By unifying the API in this way, you are able to have a consistent, clean, and flexible interface.

We can't really claim credit for this concept (beyond our exact design and implementation). The idea is not a new one and is very similar to _9P_ from _Plan 9_ by Bell Labs.

## How it differs from "Everything is a file"

Unix has a concept of using file paths to represent "special files" that have some meaning beyond a regular file. For example, a [device file](https://en.wikipedia.org/wiki/Device_file) is a reference to a device resource that looks like a file path.

With the "Everything is a file" concept provided by Unix-like systems, all sorts of devices, processes, and kernel parameters can be accessed as files in a regular filesystem. If you are on a Linux computer, you should try to `cd` to `/proc`, and see what's going on there.

Redox extends this concept to a much more powerful one. Since each "scheme provider" is free to interpret the path in its own way, new schemes can be created as needed for each type of resource. This way USB devices don't end up in a "filesystem", but a protocol-based scheme like `EHCI:`. It is not necessary for the file system software to understand the meaning of a particular URL, or to give a special file some special properties that then become a fixed file system convention. 

Real files are accessible through a scheme called `file:`, which is widely used and specified in [RFC 1630](https://tools.ietf.org/html/rfc1630) and [RFC 1738](https://tools.ietf.org/html/rfc1738).

Redox schemes are flexible enough to be used in many circumstances, with each scheme provider having full flexibility to define its own path conventions and meanings, and only the programs that wish to take advantage of those meanings need to understand them.

## Documentation about this design

- [Drew DeVault - In praise of Plan 9](https://drewdevault.com/2022/11/12/In-praise-of-Plan-9.html)
- [Plan 9 documentation](https://plan9.io/sys/doc/)
- [Plan 9 wiki](https://plan9.io/wiki/plan9/plan_9_wiki/)
- [9P documentation](http://9p.cat-v.org/documentation/)
