# Schemes

Within Redox, a scheme may be thought of in a few ways. It is all of these things.

- It is the **type** of a resource, such as "file", "M.2 drive", "tcp connection", etc. (Note that these are not valid scheme names, they are just given by way of example.)
- It is the starting point for locating the resource, i.e. it is the root of the path to the resource, which the system can then use in establishing a connection to the resource.
- It is a **uniquely named service** that is provided by some driver or daemon program, with the full URL identifying a specific resource accessed via that service.

## Kernel vs. Userspace Schemes

Schemes are implemented by **scheme providers**. A [userspace scheme](#userspace-schemes) is implemented by a program running in user space, currently requiring `root` permission. A [kernel scheme](#kernel-schemes) is implemented by the kernel directly. When possible, schemes should be implemented in userspace. Only critical schemes are implemented in kernel space.

## Accessing Resources

In order to provide "virtual file" behavior, schemes generally implement file-like operations. However, it is up to the scheme provider to determine what each file-like operation means. For example, `seek` to an SSD driver scheme might simply add to a file offset, but to a floppy disk controller scheme, it might cause the physical movement of disk read-write heads.

Typical scheme operations include:

- `open` - Create a **handle** (file descriptor) to a resource provided by the scheme. e.g. `File::create("tcp:127.0.0.1:3000")` in a regular program would be converted by the kernel into `open("127.0.0.1:3000")` and sent to the "tcp:" scheme provider. The "tcp:" scheme provider would parse the name, establish a connection to Internet address "127.0.0.1", port "3000", and return a handle that represents that connection.
- `read` - get some data from the thing represented by the handle, normally consuming that data so the next `read` will return new data.
- `write` - send some data to the thing represented by the handle to be saved, sent or written.
- `seek` - change the logical location that the next `read` or `write` will occur. This may or may not cause some action by the scheme provider.

Schemes may choose to provide other standard operations, such as `mkdir`, but the meaning of the operation is up to the scheme. `mkdir` might create a directory entry, or it might create some type of substructure or container relevant to that particular scheme.

Some schemes implement `fmap`, which creates a memory-mapped area that is shared between the scheme resource and the scheme user. It allows direct memory operations on the resource, rather than reading and writing to a file descriptor. The most common use case for `fmap` is for a device driver to access the physical addresses of a memory-mapped device, using the `memory:` kernel scheme. It is also used for frame buffers in the graphics subsystem.

> TODO add F-operations.

> TODO Explain file-like vs. socket-like schemes.

## Userspace Schemes

Redox creates userspace schemes during initialization, starting various daemon-style programs, each of which can provide one or more schemes.

| **Name** | **Daemon** | **Description** |
|----------|------------|-----------------|
| `disk:` | `ahcid`, `nvmed` | Raw access to disks |
| `display:` | `vesad` | Screen multiplexing of the display, provides text and graphical screens, used by `orbital:` |
| `ethernet:` | `ethernetd` | Raw ethernet frame send/receive, used by `ip:` |
| `file:` | `redoxfs` | Root filesystem |
| `ip:` | `ipd` | Raw IP packet send/receive |
| `network:` | `e1000d`, `rtl8168d` | Link level network send/receive, used by `ethernet:` |
| `null:` | `nulld` | Scheme that will discard all writes, and read no bytes |
| `orbital:` | `orbital` | Windowing system |
| `pty:` | `ptyd` | Pseudoterminals, used by terminal emulators |
| `rand:` | `randd` | Pseudo-random number generator |
| `tcp:` | `tcpd` | TCP sockets |
| `udp:` | `udpd` | UDP sockets |
| `zero:` | `zerod` | Scheme that will discard all writes, and always fill read buffers with zeroes |

## Kernel Schemes

The kernel provides a small number of schemes in order to support userspace.

| **Name** | **Documentation** | **Description** |
|----------|-------------------|-----------------|
| `:` | [root.rs](https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/root.rs) | Root scheme - allows the creation of userspace schemes |
| `debug:` | [debug.rs](https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/debug.rs) | Provides access to serial console
| `event:` | [event.rs](https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/event.rs) | Allows reading of `` `Event` ``s which are registered using `fevent` |
| `irq:` | [irq.rs](https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/irq.rs) | Allows userspace handling of IRQs |
| `pipe:` | [pipe.rs](https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/pipe.rs) | Used internally by the kernel to implement `pipe` |
| `sys:` | [mod.rs](https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/sys/mod.rs) | System information, such as the context list and scheme list |
| `memory:` | [memory.rs](https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/memory.rs) | Access to memory, typically physical memory addresses |
