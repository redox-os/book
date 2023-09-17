# Schemes

Schemes are the natural counter-part to URLs. URLs are opened to schemes, which can then be opened to yield a resource.

Schemes are named such that the kernel is able to uniquely identify them. This name is used in the `scheme` part of the URL.

Schemes are a generalization of file systems. It should be noted that schemes do not necessarily represent normal files; they are often a "virtual file" (i.e., an abstract unit with certain operations defined on it).

Throughout the whole ecosystem of Redox, schemes are used as the main communication primitive because they are a powerful abstraction. With schemes Redox can have one unified I/O interface.

## Kernel vs. Userspace Schemes

Schemes are implmented by **scheme providers**. A [userspace scheme](#userspace-schemes) is implemented by a program running in user space, usually with `root` permissions. A [kernel scheme](#kernel-schemes) is implemented by the kernel directly. When possible, schemes should be implemented in userspace. Only critical schemes are implemented in kernel space.

## Scheme Operations

In order to provide "virtual file" behavior, schemes generally implement file-like operations. However, it is up to the scheme provider to determine what each file-like operation means. For example, `seek` to an SSD driver scheme might simply add to a file offset, but to a floppy disk controller scheme, it might cause the physical movement of disk read-write heads.

Typical scheme operations include:

- `open` - Create a **handle** to a logical entity provided by the scheme. e.g. `File::create("tcp:127.0.0.1:6142")` in a regular program would be converted by the kernel into `open("127.0.0.1:6142")` and sent to the "tcp:" scheme provider. The "tcp:" scheme provider would parse the name and return a handle that represents a connection to Internet address "127.0.0.1", port "6142".
- `read` - get some data from the thing represented by the handle, normally consuming that data so the next `read` will return new data.
- `write` - send some data to the thing represented by the handle to be saved, sent or written.
- `seek` - change the logical location that the next `read` or `write` will occur. This may or may not cause some action by the scheme provider.

Schemes may choose to provide other standard operations, such as `mkdir`, but the meaning of the operation is up to the scheme. `mkdir` might create a directory entry, or it might create some type of substructure or container relevant to that particular scheme.

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
        <td><a href="https://gitlab.redox-os.org/redox-os/kernel/-/blob/master/src/scheme/sys/mod.r">Docs</a></td>
    </tr>
</table>

## Userspace Schemes

The Redox userspace, starting with `initfs:bin/init`, will create schemes during initialization. Once the user is able to log in, the following should be established:

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

