# "Everything is a file"

Unix has a concept of using file paths to represent "special files" that have some meaning beyond a regular file.
For example, a [device file](https://en.wikipedia.org/wiki/Device_file) is a reference to a device resource that looks like a file path.

With the "Everything is a file" concept provided by Unix-like systems,
all sorts of devices, processes, and kernel parameters can be accessed as files in a regular filesystem.
If you are on a Linux computer, you should try to `cd` to `/proc`, and see what's going on there.

Redox extends this concept to a much more powerful one. Since each "scheme provider" is free to interpret the path in its own way, new schemes can be created as needed for each type of resource. This way USB devices don't end up in a "filesystem", but a protocol-based scheme like `EHCI`.
It is not necessary for the file system software to understand the meaning of a particular path,
or to give a special file some special properties that then become a fixed file system convention. 

Redox schemes are flexible enough to be used in many circumstances,
with each scheme provider having full flexibility to define its own path conventions and meanings,
and only the programs that wish to take advantage of those meanings need to understand them.

Redox does not go as far as [Plan 9](http://doc.cat-v.org/plan_9/4th_edition/papers/net/),
in that there are not separate paths for data and control of resources.
In this case, Redox is more like Unix, where resources can potentially have a control interface.

## Documentation about this design

- [Drew DeVault - In praise of Plan 9](https://drewdevault.com/2022/11/12/In-praise-of-Plan-9.html)
- [Plan 9 documentation](https://plan9.io/sys/doc/)
- [Plan 9 wiki](https://plan9.io/wiki/plan9/plan_9_wiki/)
- [9P documentation](http://9p.cat-v.org/documentation/)
