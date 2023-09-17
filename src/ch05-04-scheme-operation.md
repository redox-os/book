# Scheme Operation

A [kernel scheme](./ch05-03-schemes.md#kernel-vs-userspace-schemes) is implemented directly in the kernel. A [userspace scheme](./ch05-03-schemes.md#kernel-vs-userspace-schemes) is typically implemented by a daemon.

A scheme is created in the [root scheme](#root-scheme) and listens for requests using the [event scheme](#event-scheme).

## Root Scheme

The `root` scheme is a special scheme provided by the kernel. It acts as the container for all other scheme names. The root scheme is referenced as ":", so when creating a new scheme, the scheme provider calls `File::create(":myscheme")`. The file descriptor that is returned by this operation is a message passing channel between the scheme provider and the kernel. File operations performed by a regular program are translated by the kernel into messages that the scheme provider reads and responds to, using this file descriptor.

## Event Scheme

The `event:` scheme is a special scheme provided by the kernel that allows a scheme provider or other program to listen for events occuring on a file descriptor. It is conceptually similar to Linux's [epoll](https://manpages.ubuntu.com/manpages/focal/en/man7/epoll.7.html) mechanism. When a regular program (or a system program) performs a file operation, it triggers an event. Redox also uses the `event:` scheme for other types of events, such as timeout events and device interrupts.

## Daemons and Userspace Scheme Providers

A daemon is a program, normally started during system initialization. It typically runs with root permissions. It is intended to run continuously, handling requests and other relevant events. On some operating systems, daemons are automatically restarted if they exit unexpectedly. Redox does not currently do this but is likely to do so in the future.

On Redox, a userspace scheme provider is a typically a daemon, although it doesn't have to be. The scheme provider informs the kernel that it will provide the scheme by creating it, e.g. `File::create(":myscheme")` will create the scheme "myscheme:". Notice that the name used to create the scheme starts with ":", indicating that it is a new entry in the root scheme. Since it is in the root scheme, the kernel knows that it is a scheme, as named schemes are the only thing that can exist in the root scheme.

## Namespaces

At the time a regular program is started, it becomes a **process**, and it exists in a **namespace**. The namespace is a container for all the schemes, files and directories that a process can access. When a process starts another program, the `namesapace` is inherited, so a new process can only access the schemes, files and directories that its parent process had available. If a parent process wants to limit (**sandbox**) a child process, it would do so as part of creating the child process.

Currently, Redox starts all processes in the "root" namespace. This will be corrected in the future, sandboxing all user programs so most schemes and system resources are hidden.

Redox also provides a `null` namespace. A process that exists in the `null` namespace cannot open files or schemes by name, and can only use existing open file descriptors. This is a security mechanism, mostly used to by deamons running with `root` permission from being hijacked into opening things they should not be accessing. A daemon will typically open its scheme and any resources it needs as it is starting, then it will ask the kernel to place it in the `null` namespace so no further resources can be opened.

## Providing a Scheme

To provide a scheme, a program performs the following steps.

- Create the scheme, obtaining a file descriptor - `File::create(":myscheme")`
- Open a file descriptor for each resource that is required to provide the scheme's services, e.g. `File::open("irq:{irq-name}")`
- Open a file descriptor for a timer if needed - `File::open("time:{timer_type}")`.
- Open a file descriptor for the event scheme - `File::open("event:")`
- Move to the null namespace to prevent any additional resources from being accessed - `setrens(0,0)`
- Write to the `event:` file descriptor to register each of the file descriptors the provider will listen to, including the scheme file descriptor - `event_fd.write(&Event{fd, ...})`

Then, in a loop:

- Block, waiting for an event to read.
- Read the event to determine (based on the file descriptor included in the event) if it is a timer, a resource, or a scheme request.
- If it's a resource event, such as a device event, perform the necessary actions such as reading from the device and queuing the data for the scheme.
- If it's a scheme event, read a request packet from the scheme file descriptor and call the "handler".
  - The request packet will indicate if it's an `open`, `read`, `write`, etc. on the scheme.
  - An `open` will include the name of the item to be opened. This can be parsed by the scheme provider to determine the exact resource the requestor wants to access. The scheme will allocate a handle for the resource, with a numbered descriptor.
  - A `read` or `write`, etc., will be handled by the scheme, using the descriptor number to look up the information associated with the resource. The operation will be performed, or queued to be performed. If the request can be handled immediately, a response is sent back on the scheme file descriptor, matched to the original request.
- After all requests have been handled, the provider loops through all schemes to determine if any queued requests are now complete. A response is sent back on the scheme file descriptor for each completed request, matched to that request.
- Set a timer if appropriate, to enable handling of device timeouts, etc. This is performed as a `write` operation on the timer file descriptor.

## Kernel Actions

The kernel performs the following actions in support of the scheme.

- Any special resources required by a scheme provider are accessed as file operations on a scheme. The kernel handles access to resources as it would any other scheme.
- Regular file operations from user programs are converted by the kernel to request messages to the schemes. The kernel maps the user program's file descriptor to a scheme and a handle id provided by the scheme during the open operation, and places them in a packet.
- If the user program is performing a blocking read or write, the user program is suspended.
- The kernel sends event packets on the scheme provider's `event:` file descriptor, waking the blocked scheme provider. Each event packet indicates whether it is the scheme or some other resource, using the file descriptor obtained by the scheme provider during its initialization.
- When the scheme provider reads from its scheme file descriptor, it receives the packets the kernel created describing the user request and handles them as described above.
- When the scheme provider sends a response packet, the kernel maps the response to a return value from the user program's file operation.
- When a blocking read or write is completed, the user program is marked ready to run, and the kernel will place it in the run queue.
