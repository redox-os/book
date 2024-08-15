# Schemes and Resources

An essential design choice made for Redox is to refer to resources using scheme-rooted paths.
This gives Redox the ability to:

- Treat resources (files, devices, etc.) in a consistent manner
- Provide resource-specific behaviors with a common interface
- Allow management of names and namespaces to provide sandboxing and other security features
- Enable device drivers and other system resource management to communicate with each other using the same mechanisms available to user programs

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
but the resource manager is free to interpret the _resource-name_ how it chooses.
