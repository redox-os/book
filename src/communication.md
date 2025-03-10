# Communication

This page explains how a program communicates with the system components.

## Context

- A scheme is a system service
- SQE means "Submission Queue Entry"
- CQE means "Completion Queue Entry"
- POSIX and Linux functions are implemented by relibc using Redox services provided by schemes, they work with the appropriate schemes to implement the function. It might involve opening a scheme, maybe writing to a scheme, or maybe calling `mmap` on the scheme after opening (this is pretty common).
- relibc and redox-rt talk to the scheme via a system call - open, read, write, mmap, etc.
- A system component (userspace daemon) uses the Scheme API (from the `redox-scheme` library) to implement the system service. The Scheme API also is doing system calls like `open`, `read` and `write`, but the message format for reading and writing is a special format. The latest version of the Scheme API reads SQE messages and writes CQE messages. SQE is basically the parameters to the system call that the caller originally did, packaged into a message. CQE is the response that the daemon sends back.
- The kernel is responsible for creating the SQE messages, and for unpacking the CQE messages.

## Example

- The program calls some POSIX or Linux function from relibc
- relibc/redox-rt convert it to system calls
- The kernel converts the system calls to SQE
- The userspace daemon calls read on a "scheme socket" and gets an SQE message
- The userspace daemon calls write on the scheme socket and sends a CQE message
- The kernel converts the CQE message to the result of the system call
- relibc/redox-rt gets the result from the system call and uses that to calculate the result of the POSIX or Linux function call
