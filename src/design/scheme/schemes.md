Schemes
=======

Schemes are the natural counter-part to URLs. URLs are opened to schemes, which can then be opened to yield a resource.

Schemes are named such that the kernel is able to uniquely identify them. This name is used in the `scheme` part of the URL.

Schemes are a generalization of file systems. It should be noted that schemes do not necessarily represent normal files; they are often a "virtual file" (i.e., an abstract unit with certain operations defined on it).

Throughout the whole ecosystem of Redox, schemes are used as the main communication primitive because they are a powerful abstraction. With schemes Redox can have one unified I/O interface.

Schemes can be defined both in user space and in kernel space but when possible user space is preferred.

Kernel Schemes
--------------

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
        <td><a href="https://doc.redox-os.org/kernel/kernel/scheme/root/index.html">Docs</a></td>
    </tr>
    <tr>
        <td><code>debug:</code></td>
        <td>Provides access to serial console</td>
        <td><a href="https://doc.redox-os.org/kernel/kernel/scheme/debug/index.html">Docs</a></td>
    </tr>
        <td><code>event:</code></td>
        <td>Allows reading of `Event`s which are registered using <code>fevent</code></td>
        <td><a href="https://doc.redox-os.org/kernel/kernel/scheme/event/index.html">Docs</a></td>
    </tr>
    <tr>
        <td><code>env:</code></td>
        <td>Access and modify environmental variables</td>
        <td><a href="https://doc.redox-os.org/kernel/kernel/scheme/env/index.html">Docs</a></td>
    </tr>
    <tr>
        <td><code>initfs:</code></td>
        <td>Readonly filesystem used for initializing the system</td>
        <td><a href="https://doc.redox-os.org/kernel/kernel/scheme/initfs/index.html">Docs</a></td>
    </tr>
    <tr>
        <td><code>irq:</code></td>
        <td>Allows userspace handling of IRQs</td>
        <td><a href="https://doc.redox-os.org/kernel/kernel/scheme/irq/index.html">Docs</a></td>
    </tr>
    <tr>
        <td><code>pipe:</code></td>
        <td>Used internally by the kernel to implement <code>pipe</code></td>
        <td><a href="https://doc.redox-os.org/kernel/kernel/scheme/pipe/index.html">Docs</a></td>
    </tr>
    <tr>
        <td><code>sys:</code></td>
        <td>System information, such as the context list and scheme list</td>
        <td><a href="https://doc.redox-os.org/kernel/kernel/scheme/sys/index.html">Docs</a></td>
    </tr>
</table>

Userspace Schemes
-----------------

The Redox userspace, starting with initfs:bin/init, will create schemes during initialization. Once the user is able to log in, the following should be established:

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

Scheme operations
-----------------

What makes a scheme a scheme? Scheme operations!

A scheme is just a data structure with certain functions defined on it:

1. `open` - open the scheme. `open` is used for initially starting communication with a scheme; it is an optional method, and will default to returning `ENOENT`.

2. `mkdir` - make a new sub-structure. Note that the name is a little misleading (and it might even be renamed in the future), since in many schemes `mkdir` won't make a `directory`, but instead perform some form of substructure creation.

Optional methods include:

1. `unlink` - remove a link (that is a binding from one substructure to another).

2. `link` - add a link.
