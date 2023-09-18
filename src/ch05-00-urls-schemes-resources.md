# URLs, Schemes, and Resources

An essential design choice made for Redox is to refer to resources using URL-style naming. This gives Redox the ability to
- treat resources (files, devices, etc.) in a consistent manner
- provide resource-specific behaviors with a common interface
- allow management of names and namespaces to provide sandboxing and other security features
- enable device drivers and other system resource management to communicate with each other using the same mechanisms available to user programs

## What is a Resource

A resource is anything that a program might wish to access, usually referenced by some name. It may be a file in a filesystem, or frame buffer on a graphics device, or a dataset provided by some other computer.

## What is a URL

A [Uniform Resource Locator](https://en.wikipedia.org/wiki/URL) (URL) is a string that identifies some thing (resource) that a program wants to refer to. It follows a format that can be divided easily into component parts. In order to fully understand the meaning and interpretation of a URL, it is important to also understand [URI](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) and [URN](https://en.wikipedia.org/wiki/Uniform_Resource_Name).

## What is a Scheme

For the purposes of Redox, a URL includes a **scheme** that identifies the starting point for finding a resource, and a **path** that gives the details of which specific resource is desired. The **scheme** is the first part of the URL, up to (and for our purposes including) the first `:`. In a normal web URL, e.g. `https://en.wikipedia.org/wiki/Uniform_Resource_Name`, `https:` represents the communication protocol to be used. For Redox, we extend this concept to include not only protocols, but other resource types, such as `file:`, `display:`, etc., which we call schemes.
