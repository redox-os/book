# Resources

A resource is any "thing" that can be referred to using a path.
It can be a physical device, a logical pseudodevice, a file on a file system, a service that has a name, or an element of a dataset.

The client program accesses a resource by opening it, using the resource name in scheme-rooted path format. 
The first part of the path is the name of the scheme, and the rest of the path is interpreted by the scheme provider,
assigning whatever meaning is appropriate for the resources included under that scheme.

## Resource Examples

Some examples of resources are:

- Files within a filesystem - `/path/to/file` is interpreted as `/scheme/redoxfs/path/to/file`.
Other filesystems can be referenced as `/scheme/otherfs/path/to/file`.
- Pseudo-terminals - `/scheme/pty/n` where `n` is a number, refers to a particular [pseudo-terminal](https://en.wikipedia.org/wiki/Pseudoterminal).
- Display - `/scheme/display.vesa/n` where `n` is a number, refers to the VESA virtual display - Virtual display 1  is the system log, display 2 is the text UI, and display 3 is the graphical display used by Orbital.
- Networking - `/scheme/udp/a.b.c.d/p` is the UPD socket with IPv4 address `a.b.c.d`, port number `p`.
