# The Redox Book

## Development

We use [mdBook](https://github.com/azerupi/mdBook), a Rust tool to create online 
books from Markdown.

Start a development server on http://localhost:3000 with the following command

```
mdbook serve
```

Some graphics are in svg and are associated with their corresponding .xml source file.
You can edit the graphic by using the .xml on [draw.io](https://www.draw.io/).

## Book ToDos

There are lots of parts of this book that can use additional content. Your help would be greatly appreciated.

### Redox Architecture Concepts

If you are familiar with microkernel-based architectures and Rust, we could use help with documenting some of the following topics for the book:
- Device Driver concepts and implementation guidelines
- Memory management
- Application start-up
- System Call operation
- Interprocess Communication
- The Graphics Subsystem

### Redox Programs and Components

Redox has many subprojects that combine to provide a complete system. You can help by improving the documentation for those many subprojects, either in their own documentation, if they have it, or here in the book. For those subprojects with their own documentation, you can add links in this book to the documentation, as well as providing some contextual information about how Redox uses each component.

### Open ToDos on the book

- [Advanced Filesystem](https://doc.redox-os.org/book/ch01-03-why-a-new-os.html#advanced-filesystem)
- [Everything is a URL](https://doc.redox-os.org/book/ch01-05-how-redox-compares.html#everything-is-a-url)
- [Versus monolithic kernels](https://doc.redox-os.org/book/ch04-01-microkernels.html#versus-monolithic-kernels)
- [Drivers](https://doc.redox-os.org/book/ch04-05-drivers.html#drivers)
- [Memory Management](https://doc.redox-os.org/book/ch04-06-memory.html#memory-management)
- [URLs, Schemes and Resources](https://doc.redox-os.org/book/ch05-00-urls-schemes-resources.html#so-how-does-it-differ-from-files)
- [Opening a URL #1](https://doc.redox-os.org/book/ch05-01-urls.html#opening-a-url)
- [Opening a URL #2](https://doc.redox-os.org/book/ch05-02-how-it-works.html#opening-a-url)
- [Registering a Scheme](https://doc.redox-os.org/book/ch05-04-root-scheme.html#registering-a-scheme)
- [Resource Operations](https://doc.redox-os.org/book/ch05-05-resources.html#resource-operations)
- [The Resource Type](https://doc.redox-os.org/book/ch05-05-resources.html#the-resource-type)
- [Stitching It All Together](https://doc.redox-os.org/book/ch05-06-stitching-it-all-together.html#stiching-it-all-together)
- [Build Process](https://doc.redox-os.org/book/ch08-00-build-process.html) (empty)
- [Direct Contributions](https://doc.redox-os.org/book/ch10-01-direct-contributions.html) (empty)
- [Uing Git](https://doc.redox-os.org/book/ch12-00-using-git.html) (empty)
