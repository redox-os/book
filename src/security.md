# Security

This page covers the security design.

## Unsafe Rust

Some parts of the system code use unsafe Rust code which has less compiler verification than safe Rust, thus still safer than C or C++

Unsafe Rust code is replaced with safe Rust code where possible, where it's not possible the security focus relies on boundaries.

Some unsafe Rust code is using safe Rust code in some parts, we are looking more unsafe Rust code than can use safe Rust code.

## Applications and Libraries

The POSIX and Linux source code compatibility don't downgrade the system security, `relibc` translate POSIX APIs and try to improve the compatibility security where possible:

- The microkernel architecture greatly reduce the potential to use system bugs to get application or library sensitive data or inject malicious code
- POSIX and Linux functions are written in Rust, which prevent many bugs
- Input sanitization is done where possible, like strings

The POSIX/Linux applications or libraries is who decide if they use safer APIs, while Redox provide the compatibility.

## Capabilities and Sandbox

- The namespaces and [capability-based](https://en.wikipedia.org/wiki/Capability-based_security) system are implemented by the kernel but some parts can be moved to user-space.
- A namespace is a list of schemes, if you run `ls :`, it will show the schemes on the current namespace.
- Each process has a namespace.
- [Capabilities](https://en.wikipedia.org/wiki/File_descriptor#File_descriptors_as_capabilities) are customized file descriptors that carry specific actions.

The sandbox system duplicates the system resources for each program, it allows them to be completely isolated from the main system. Flatpak and Snap use a sandbox security system on Linux, Redox will do the same.

Redox allows sandbox by limiting a program's capabilities:

- Only a certain number of schemes in the program's namespace is allowed, or no scheme at all. That way new file descriptors can't be opened.
- All functionality is forced to occur via file descriptors (WIP).
