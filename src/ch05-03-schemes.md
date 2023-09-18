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


## Kernel Schemes

The kernel provides a small number of schemes in order to support userspace.

<table>
    <tr>
        <th>Name</th>
        <th>Description</th>
        <th>Links</th>
    </tr>
    <tr>
        <td><code>:</code></td>
        <td>Root scheme - allows the creation of userspace schemes</td>
        <td><a href="https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/root.rs">Docs</a></td>
    </tr>
    <tr>
        <td><code>debug:</code></td>
        <td>Provides access to serial console</td>
        <td><a href="https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/debug.rs">Docs</a></td>
    </tr>
        <td><code>event:</code></td>
        <td>Allows reading of `Event`s which are registered using <code>fevent</code></td>
        <td><a href="https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/event.rs">Docs</a></td>
    </tr>
    <tr>
        <td><code>irq:</code></td>
        <td>Allows userspace handling of IRQs</td>
        <td><a href="https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/irq.rs">Docs</a></td>
    </tr>
    <tr>
        <td><code>pipe:</code></td>
        <td>Used internally by the kernel to implement <code>pipe</code></td>
        <td><a href="https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/pipe.rs">Docs</a></td>
    </tr>
    <tr>
        <td><code>sys:</code></td>
        <td>System information, such as the context list and scheme list</td>
        <td><a href="https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/sys/mod.rs">Docs</a></td>
    </tr>
    <tr>
        <td><code>memory:</code></td>
        <td>Access to memory, typically physical memory addresses</td>
        <td><a href="https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/memory.rs">Docs</a></td>
    </tr>
</table>

## Userspace Schemes

Redox creates userspace schemes during initialization, starting various daemon-style programs, each of which can provide one or more schemes.

<table>
    <tr>
        <th>Name</th>
        <th>Daemon</th>
        <th>Description</th>
    </tr>
    <tr>
        <td><code>disk:</code></td>
        <td><code>ahcid</code></td>
        <td>Raw access to disks</td>
    </tr>
    <tr>
        <td><code>display:</code></td>
        <td><code>vesad</code></td>
        <td>Screen multiplexing of the display, provides text and graphical screens, used by <code>orbital:</code></td>
    </tr>
    <tr>
        <td><code>ethernet:</code></td>
        <td><code>ethernetd</code></td>
        <td>Raw ethernet frame send/receive, used by <code>ip:</code></td>
    </tr>
    <tr>
        <td><code>file:</code></td>
        <td><code>redoxfs</code></td>
        <td>Root filesystem</td>
    </tr>
    <tr>
        <td><code>ip:</code></td>
        <td><code>ipd</code></td>
        <td>Raw IP packet send/receive</td>
    </tr>
    <tr>
        <td><code>network:</code></td>
        <td><code>e1000d</code><br/><code>rtl8168d</code></td>
        <td>Link level network send/receive, used by <code>ethernet:</code></td>
    </tr>
    <tr>
        <td><code>null:</code></td>
        <td><code>nulld</code></td>
        <td>Scheme that will discard all writes, and read no bytes</td>
    </tr>
    <tr>
        <td><code>orbital:</code></td>
        <td><code>orbital</code></td>
        <td>Windowing system</td>
    </tr>
    <tr>
        <td><code>pty:</code></td>
        <td><code>ptyd</code></td>
        <td>Psuedoterminals, used by terminal emulators</td>
    </tr>
    <tr>
        <td><code>rand:</code></td>
        <td><code>randd</code></td>
        <td>Psuedo-random number generator</td>
    </tr>
    <tr>
        <td><code>tcp:</code></td>
        <td><code>tcpd</code></td>
        <td>TCP sockets</td>
    </tr>
    <tr>
        <td><code>udp:</code></td>
        <td><code>udpd</code></td>
        <td>UDP sockets</td>
    </tr>
    <tr>
        <td><code>zero:</code></td>
        <td><code>zerod</code></td>
        <td>Scheme that will discard all writes, and always fill read buffers with zeroes</td>
    </tr>
</table>

