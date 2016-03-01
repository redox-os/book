Resources
=========

Resources are opened schemes. You can think of them like an established connection between the scheme provider and the client.

Resources are closely connect to schemes, and are sometimes intertwined with schemes. But the different is subtle, yet crucial.

Resource operations
-------------------

A resource can be defined as a data type with following methods defined on it:

1. `read` - read N bytes to a buffer provided as argument. Defaults to `EBADF`
2. `write` - write a buffer to the resource. Defaults to `EBADF`.
3. `seek` - seek the resource, that is move the "cursor" without writing. Many resources do not support this operation. Defaults to `EBADF`.
4. `close` - close the resource, potentially releasing a lock. Defaults to `EBADF`.

TODO add F-operations

The resource type
-----------------

There are two types of resources:

1. File-like resources. These behaves a lot like files. They act in a blocking manner, reads and writes are "buffer-like".
2. Socket-like resources. These behaves like sockets. They act in a non-blocking manner, reads and writes are more "stream-like".

I will expand on this later.
