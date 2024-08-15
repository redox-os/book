# Scheme-rooted Paths

Scheme-rooted paths are the way that resources are identified on Redox.

## What is a Resource

A resource is anything that a program might wish to access, usually referenced by some name.
It may be a file in a filesystem, or frame buffer on a graphics device, or a dataset provided by some other computer.

## What is a Scheme

For the purposes of Redox, a **scheme** identifies the starting point for finding a resource,
and a **path** that gives the details of which specific resource is desired.
The **scheme**, which takes its name from [URI schemes](https://en.wikipedia.org/wiki/List_of_URI_schemes) identifies the type of resource,
and identifies the manager daemon responsible for that resource.

## What is a Scheme-rooted Path

A scheme-rooted path takes the following form, with text in **bold** being literal.

  **/scheme/**_scheme-name_/_resource-name_

_scheme-name_ is the name of the kind of resource, and it also identifies the name of the manager daemon for that kind.

_resource-name_ is the specific resource of that kind.
Typically in Redox, the _resource-name_ is a path with elements separated by slashes,
but the resource manager is free to interpret the _resource-name_ how it chooses,
allowing other formats to be used if required in the future.
Some schemes, such as `/scheme/pty/` simply allocate sequentially numbered resources and do not need the complexity of
a slash-separated path.

## Differences from Unix

Unix systems have some special file types, such as "block special file" or "character special file".
These special files use [major/minor](https://en.wikipedia.org/wiki/Device_file#Unix_and_Unix-like_systems) numbers
to identify the driver and the specific resource within the driver.
There are also pseudo-filesystems, for example [procfs](https://en.wikipedia.org/wiki/Procfs) that provide access to resources using paths.

Redox's scheme-rooted paths provide a consistent approach to resource naming, compared with Unix.

## Regular Files

For Redox, a path that does not begin with `/scheme/` is a reference to the RedoxFS scheme, which is responsible for the root filesystem.
Thus `/home/user/.bashrc` is interpreted as `/scheme/redoxfs/home/user/.bashrc`.
This makes paths for regular files feel as natural as Unix file paths.
When other scheme-rooted paths should use a more Unix-like format, such as for `/dev/tty`,
a symbolic link can be used.