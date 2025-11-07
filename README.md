# The Redox Book

This is the **Redox OS** book, which explain (almost) everything about Redox: design, philosophy, how it works, how you can contribute, how to deploy Redox, and much more.

## Development

We use [mdBook](https://github.com/rust-lang/mdBook), a Rust tool to create web books from Markdown.

You can start a development server on http://localhost:3000 with the following command

```sh
mdbook serve
```

Some graphics are in SVG and are associated with their corresponding `.xml` source file.

You can edit the art by using the XML file on [draw.io](https://www.draw.io/).

## Check for Unused Pages

If you have added or removed pages,
or reorganized the table of contents,
check for pages that are missing from the table of contents
before making your merge requests.
In the `book` directory, run

```sh
./unused_pages.sh
```

## Verify Broken Links

Use the [lychee](https://lychee.cli.rs/) tool to verify broken links, it's very advanced and fast.

Read [this](https://lychee.cli.rs/installation/) page to install the tool.

### Usage

Run the following command inside the repository folder:

```sh
lychee src
```

## TODOs

There are some parts of this book that need more explanation. Your help would be greatly appreciated.

### Redox Architecture Concepts

If you are familiar with microkernel-based architectures and Rust help us documenting some of the following topics for the book:

- Device driver concepts and implementation guidelines
- Memory management
- Application start-up
- System call operation
- Interprocess Communication
- The Graphics Subsystem

### Programs and Components

Redox has many subprojects that combine to provide a complete system. You can help by improving the documentation for those many subprojects, either in their own documentation, if they have it, or here in the book. For those subprojects with their own documentation, you can add links in this book to the documentation, as well as providing some contextual information about how Redox uses each component.
