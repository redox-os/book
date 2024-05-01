# Event Scheme

The `event:` scheme is a special scheme that is central to the operation of device drivers, schemes and other programs that receive events from multiple sources. It's like a "clearing house" for activity on multiple file descriptors. The daemon or client program performs a `read` operation on the `event:` scheme, blocking until an event happens. It then examines the event to determine what file descriptor is active, and performs a non-blocking read of the active file descriptor. In this way, a program can have many sources to read from, and rather than blocking on one of those sources while another might be active, the program blocks only on the `event:` scheme, and is unblocked if any one of the other sources become active.

The `event:` scheme is conceptually similar to Linux's [epoll](https://manpages.ubuntu.com/manpages/focal/en/man7/epoll.7.html) mechanism.

## What is a Blocking Read

For a regular program doing a regular read of a regular file, the program calls `read`, providing an input buffer, and when the `read` call returns, the data has been placed into the input buffer. Behind the scenes, the system receives the `read` request and suspends the program, meaning that the program is put aside while it waits for something to happen. This is very convenient if the program has nothing to do while it waits for the `read` to complete. However, if the thing the program is reading from might take a long time, such as a slow device, a network connection or input from the user, and there are other things for the program to do, such as updating the screen, performing a blocking read can prevent handling these other activities in a timely manner.

## Non-blocking Read

To allow reading from multiple sources without getting stuck waiting for any particular one, a program can open a URL using the `O_NONBLOCK` flag. If data is ready to be read, the system immediately copies the data to the input buffer and returns normally. However, if data is not ready to be read, the `read` operation returns an error of type `EAGAIN`, which indicates that the program should try again later.

Now your program can scan many file descriptors, checking if any of them have data available to read. However, if none have any data, you want your program to block until there is something to do. This is where the `event:` scheme comes in.

## Using the Event Scheme

The purpose of the `event:` scheme is to allow the daemon or client program to receive a message on the `event_file`, to inform it that some other file descriptor is ready to be read. The daemon reads from the `event_file` to determine which other file descriptor is ready. If no other descriptor is ready, the `read` of the `event_file` will block, causing the daemon to be suspended until the event scheme indicates some other file descriptor is ready.

Before setting up the event scheme, you should `open` all the other resources you will be working with, but set them to be non-blocking. E.g. if you are a scheme provider, open your scheme in non-blocking mode,

```
let mut scheme_file = OpenOptions::new()
            .create(true)
            .read(true)
            .write(true)
            .custom_flags(syscall::O_NONBLOCK as i32)
            .open(":myscheme")
            .expect("mydaemon: failed to create myscheme: scheme");
```

The first step in using the event scheme is to open a connection to it. Each program will have a connection to the event scheme that is unique, so no path name is required, only the name of the scheme itself.

```
let event_file = File::open("event:");
// you actually need to open it read/write
```

Next, write messages to the event scheme, one message per file descriptor that the `event:` scheme should monitor. A message is in the form of a `syscall::data::Event` struct.

```
use syscall::data::Event;
let _ = event_file.write(&Event{ id: scheme_file.as_raw_fd(), ... });
// write one message per file descriptor
```

Note that timers in Redox are also handled via a scheme, so if you will be using a timer, you will need to open the `timer:` scheme, and include that file descriptor among the ones your `event_file` should listen to.

Once your setup of the `event:` scheme is complete, you begin your main loop.

- Perform a blocking read on the `event:` file descriptor. `event_file.read(&mut event_buf);`
- When an event, such as data becoming available on a file descriptor, occurs, the `read` operation on the `event_file` will complete.
- Look at the `event_buf` to see which file descriptor is active.
- Perform a non-blocking read on that file descriptor.
- Do the appropriate processing.
- If you are using a timer, write to the timer file descriptor to tell it when you want an event.
- Repeat.

## Non-blocking Write

Sometimes write operations can take time, such as sending a message synchronously or writing to a device with a limited buffer. The `event:` scheme allows you to listen for write file descriptors to become unblocked. If a single file descriptor is opened in read-write mode, your program will need to register with the `event:` scheme twice, once for reading and once for writing.

## Implementing Non-blocking Reads in a Scheme

If your scheme supports non-blocking reads by clients, you will need to include some machinery to work with the `event:` scheme on your client's behalf.

- Wait for an event that indicates activity on your scheme. `event_file.read(&mut event_buf);`
- Read a packet from your scheme file descriptor containing the request from the client program. `scheme_file.read(&mut packet)`
- The packet contains the details of which file descriptor is being read, and where the data should be copied.
- If the client is performing a `read` that would block, then queue the client request, and return the `EAGAIN` error, writing the error response to your scheme file descriptor.
- When data is available to read, send an event by writing a special packet to your scheme, indicating the handle id that is active.
  ```rust
  scheme_file.write(&Packet { a: syscall::number::SYS_FEVENT, b: handle_id, ... });
  ```
- When routing this response back to the client, the kernel will recognize it as an event message, and post the event on the client's `event_fd`, if one exists.
- The scheme provider does not know whether the client has actually set up an `event_fd`. The scheme provider must send the event "just in case".
- If an event has already been sent, but the client has not yet performed a `read`, the scheme should not send additional events. In correctly coded clients, extra events should not cause problems, but an effort should be made to not send unnecessary events. Be wary, however, as race conditions can occur where you think an extra event is not required but it actually is.