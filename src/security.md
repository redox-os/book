# Security

This page covers the current Redox security design.

- The namespaces and [capability-based](https://en.wikipedia.org/wiki/Capability-based_security) system are implemented by the kernel but some parts can be moved to user-space.
- A namespace is a list of schemes, if you run `ls :`, it will show the schemes on the current namespace.
- Each process has a namespace.
- [Capabilities](https://en.wikipedia.org/wiki/File_descriptor#File_descriptors_as_capabilities) are customized file descriptors that carry specific actions.
- All programs are statically-linked to their libraries, except for big libraries to save memory and storage space

## Sandbox

The sandbox system duplicates the system resources for each program, it allows them to be completely isolated from the main system. Flatpak and Snap use a sandbox security system on Linux, Redox will do the same on its packages.

Redox allows sandbox by limiting a program's capabilities:

- Only a certain number of schemes in the program's namespace is allowed, or no scheme at all. That way new file descriptors can't be opened.
- All functionality is forced to occur via file descriptors (WIP).

## Static Linking

Static linking increase the system security because each program use a different library code, even if the same version of a vulnerable library is used.

The attacker would need to inject code on each program's memory address space to steal sensitive data and not the shared library's memory address space, it increases the cost of the attack.

Rust programs use static linking by default.
