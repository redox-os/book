URLs, Schemes, and Resources
============================

This is one of the most important design choices Redox makes. These three essential concepts are very entangled.

What does "Everything is a URL" mean?
--------------------------------------

"Everything is a URL" is a generalization of "Everything is a file", allowing broader use of this unified interface for schemes.

These can be used for effectively modulating the system in a "non-patchworky" manner.

The term is rather misleading, since a URL is just the identifier of a scheme and a resource descriptor. So in that sense "Everything is a scheme, identified by a URL" is more accurate, but not very catchy.

So, how does it differ from files?
----------------------------------

You can think of URLs as segregated virtual file systems, which can be arbitrarily structured (they do not have to be tree-like) and arbitrarily defined by a program. Furthermore, "files" don't have to behave file-like! More on this later.

It opens up a lot of possibilities.
> [... TODO]

The idea of virtual file systems is not a new one. If you are on a Linux computer, you should try to `cd` to `/proc`, and see what's going on there.

Redox extends this concept to a much more powerful one.

> TODO

Documentation about this design
-------------------------------

[Drew DeVault - In praise of Plan 9]: https://drewdevault.com/2022/11/12/In-praise-of-Plan-9.html
[Plan 9 documentation]: https://plan9.io/sys/doc/
[Plan 9 wiki]: https://plan9.io/wiki/plan9/plan_9_wiki/
[9P documentation]: http://9p.cat-v.org/documentation/
