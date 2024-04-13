# Security

This page covers the current Redox security mechanisms.

- Namespaces and a [capability-based](https://en.wikipedia.org/wiki/Capability-based_security) system, both are implemented by the kernel but some parts can be moved to user-space.
- A namespace is a list of schemes, if you run `ls :`, it will show the schemes on the current namespace.
- Each process has a namespace.
- [Capabilities](https://en.wikipedia.org/wiki/File_descriptor#File_descriptors_as_capabilities) are customized file descriptors that carry specific actions.

## Sandbox

Redox allows limiting a program's capabilities and thus allows sandboxing, by:

1. - By only putting a certain number of schemes in the program's namespace, or no scheme at all, in which case new file descriptors can't be opened.
2. - By forcing all functionality to occur via file descriptors (it's not finished yet).
