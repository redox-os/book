# Scheme-rooted Paths

Scheme-rooted paths are the way that resources are identified on Redox.

## What is a Resource

A [resource](./ch05-02-resources.md) is anything that a program might wish to access, usually referenced by some name.

## What is a Scheme

A [scheme](./ch05-03-schemes.md) identifies the starting point for finding a resource.

## What is a Scheme-rooted Path

A scheme-rooted path takes the following form, with text in **bold** being literal.

  **/scheme/**_scheme-name_**/**_resource-name_

_scheme-name_ is the name of the kind of resource,
and it also identifies the name used by the manager **daemon** for that kind.

_resource-name_ is the specific resource of that kind.
Typically in Redox, the _resource-name_ is a path with elements separated by slashes,
but the resource manager is free to interpret the _resource-name_ how it chooses,
allowing other formats to be used if required.

## Differences from Unix

Unix systems have some special file types, such as "block special file" or "character special file".
These special files use [major/minor](https://en.wikipedia.org/wiki/Device_file#Unix_and_Unix-like_systems) numbers
to identify the driver and the specific resource within the driver.
There are also pseudo-filesystems, for example [procfs](https://en.wikipedia.org/wiki/Procfs) that provide access to resources using paths.

Redox's scheme-rooted paths provide a consistent approach to resource naming, compared with Unix.

## Regular Files

For Redox, a path that does not begin with `/scheme/` is a reference to the the root filesystem, which is managed by the `file` scheme.
Thus `/home/user/.bashrc` is interpreted as `/scheme/file/home/user/.bashrc`.

In this case, the scheme is `file` and the resource is
`home/user/.bashrc` within that scheme.

This makes paths for regular files feel as natural as Unix file paths.