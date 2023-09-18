# URLs

The URL is a string name in specific format, normally used to identify resources across the web. For typical web usage, a URL would have the following format.

```
protocol://hostname/resource_path/resource_path/resource_name?query#fragment
```

- The `protocol` tells your web browser *how* to communicate with the remote host.
- The `hostname` is used by the protocol to find the host computer that has the desired resource.
- The `resource_path` is used by the host computer's web server to find the desired resource. In a web server that includes e.g. static HTML as well as dynamically generated content, the web server uses a `router` to interpret the `resource_path` to find the desired resource, perhaps returning a static HTML file, or invoking a PHP interpreter on a PHP page. A path can consist of one or more parts separated by `/`.
- The `resource_name` is the logical "page" to be displayed.
- The `query` can provide additional details, such as a string to be used as a search parameter. Some websites include query details as an element of the `resource_name`, e.g. `profile/John_Smith` while other websites use the `?` format following the resource name, e.g. `profile?name=John+Smith` or `customer/John_Smith?display=profile`.
- The `fragment` can provide extra detail to your browser about what to display. For example, it can identify a subheading within a page, that your browser should scroll to. Fragments are not normally sent to the host computer, they are processed locally by your browser.

## Redox URLs

For the purposes of Redox, a URL contains two parts:

1. The scheme part. This represents the "receiver", i.e. what scheme provider will handle the (F)OPEN call. This can be any arbitrary UTF-8 string, and will often simply be the name of your protocol or the name of a program that manages your resource.

2. The reference part. This represents the "payload" of the URL, namely what the URL refers to. Consider `file:/home/user/.profile`, as an example. A URL starting with `file:` simply has a reference which is a path to a file. The reference can be any arbitrary byte string. The parsing, interpretation, and storage of the reference is left to the scheme. For this reason, it is not required to be a tree-like structure.

So, the string representation of a URL looks like:

```
[scheme]:[reference]
```

For example:

```
file:/path/to/myfile
```

For Redox, the format of the **reference** is determined by the scheme provider. Normally, the reference is a path, with path elements separated by the `/` character. But other formats for references may be more appropriate, so each scheme must document what format the reference should take. Redox does not yet have a formal way of documenting its use of URL formats, but will provide one in future.

Any URL that starts with a scheme is assumed to use an absolute path, so `//` or `/` is not technically required for the first element. By convention, `/` is included before the first element when a multi-part path is supported by the scheme, but it is not included if the scheme doesn't use path-style references.

A URL that does not start with a scheme name is considered to be "relative to the current working directory". When a program starts, or when the program "changes directory", it has a "current working directory" that is prepended to the relative path. It's possible to "change directory" to a scheme, even if that scheme doesn't support the concept of directories or folders. Then all relative paths are prepended with the "current directory" (in this case a scheme name).

Some examples of URLs that Redox might use are:
- `file:/home/user/.profile` - The file `.profile` that can be found at the location `/home/user` within the scheme `file:`
- `tcp:127.0.0.1:3000` - Internet address `127.0.0.1`, port `3000`, using the scheme `tcp:`
- `display:3` - Virtual display `3` provided by the display manager.


## Opening a URL

A URL can be opened, yielding a file descriptor that is associated with a specific resource, which can be read, written and (for some resources) seek'd (there are more operations which are described later on).

We use a file API similar to the Rust standard library's for opening URLs:

```rust
use std::fs::OpenOptions;
use std::io::prelude::*;


fn main() {
    // Let's read from a TCP stream
    let tcp = OpenOptions::new()
                .read(true) // readable
                .write(true) // writable
                .open("tcp:127.0.0.1:3000");
}
```

