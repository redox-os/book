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

## External Links

This list have all hyperlink names with external links inside the book (in case we need to change them easily)

- "CONTRIBUTING.md" - Introduction
- "Rust" - Introduction
- "POSIX" - Introduction
- "Plan 9" - Introduction
- "Minix" - Introduction
- "Linux" - Introduction
- "BSD" - Introduction
- "Rust" - Why a New OS?
- "memory errors" - Why a New OS?
- "Microkernel Architecture" - Why a New OS?
- "Monolithic Kernels" - Why a New OS?
- "RedoxFS" - Why a New OS?
- "ZFS" - Why a New OS?
- "POSIX" - Why a New OS?
- "relibc" - Why a New OS?
- "virtualization" - Redox Use Cases
- "Iced" - Redox Use Cases
- "Slint" - Redox Use Cases
- "relevant section of the Rust book" - Why Rust?
- "RedoxFS" - Side projects
- "Ion" - Side projects
- "Orbital" - Side projects
- "orbclient" - Side projects
- "OrbTK" - Side projects
- "pkgutils" - Side projects
- "Sodium" - Side projects
- "ralloc" - Side projects
- "libextra" - Side projects
- "games-for-redox" - Side projects
- "here" - Side projects
- "Coreutils" - Side projects
- "Extrautils" - Side projects
- "Binutils" - Side projects
- "uutils/coreutils" - Side projects
- "smoltcp" - Side projects
- "here" - Running Redox in a virtual machine
- "demo_harddrive" - Running Redox in a virtual machine
- "SHA sum" - Running Redox in a virtual machine
- "here" - Running Redox in a virtual machine/Running on Windows
- "redox_demo" - Running Redox in a virtual machine/Running on Windows
- "latest release" - Running Redox on real hardware
- "demo ISO" - Running Redox on real hardware
- "SHA sum" - Running Redox on real hardware
- "here" - Trying Out Redox
- "https://freedoom.github.io/" - Trying Out Redox
- "https://prboom.sourceforge.net/" - Trying Out Redox
- "Github page" - Trying Out Redox
- "HenryTheCat" - Trying Out Redox
- "FUSE" - Building Redox
- "Redox repository" - Building Redox
- "here" - Podman Build
- "FUSE" - Podman Build
- "our Discourse Redox-os Forum" - Questions and feedback
- "GitLab Redox Project Issues" - Questions and feedback
- "New Issue" - Questions and feedback
- "MINIX" - The kernel
- "from Wikimedia" - Microkernels
- "OSDev technical wiki" - Microkernels
- "Minix documentation" - Microkernels
- "Minix features" - Microkernels
- "Minix reliability" - Microkernels
- "Minix paper" - Microkernels
- "GNU Hurd documentation" - Microkernels
- "HelenOS FAQ" - Microkernels
- "Microkernels performance paper" - Microkernels
- "seL4 whitepaper" - Microkernels
- "Fuchsia documentation" - Microkernels
- "There is very good documentation in MINIX about how this can be addressed by a microkernel" - Advantages of microkernels
- "context switch" - Disadvantages of microkernels
- "MMU" - Disadvantages of microkernels
- "TLB" - Disadvantages of microkernels
- "Context switch documentation" - Disadvantages of microkernels
- "Microkernels performance paper" - Disadvantages of microkernels
- "Boot process documentation" - Boot Process
- "Drivers repository" - Drivers
- "Memory management documentation" - Memory management
- "Round Robin Scheduling" - Scheduling
- "interrupt handler" - Scheduling
- "Scheduling documentation" - Scheduling
- "Drew DeVault - In praise of Plan 9" - URLs, schemes and Resources
- "Plan 9 documentation" - URLs, schemes and Resources
- "Plan 9 wiki" - URLs, schemes and Resources
- "9P documentation" - URLs, schemes and Resources
- "Docs" - Schemes
- "RFC 1630" - "Everything is a URL"
- "RFC 1738" - "Everything is a URL"
- "redox-os/vec_scheme_example" - An example
- "API docs" - An example
- "ELF" - Programs and Libraries
- "C standard library" - Programs and Libraries
- "relibc" - Programs and Libraries
- "POSIX compatibility" - Programs and Libraries
- "libstd" - Programs and Libraries
- "Cookbook" - Programs and Libraries
- "OS internals documentation" - Programs and Libraries
- "ELF documentation" - Programs and Libraries
- "here" - Shell
- "terminals" - Shell
- "IBM mainframes" - Shell
- "CONTRIBUTING.md" - Developing Overview
- "cross-compilation" - Advanced Build
- "OSDev article on cross-compiling" - Advanced Build
- "FUSE" - Advanced Podman Build
- "Podman rootless wiki" - Advanced Podman Build
- "Shortcomings of Rootless Podman" - Advanced Podman Build
- "step" - Advanced Podman Build
- "Redox Support" - Advanced Podman Build
- "Redox Dev" - Advanced Podman Build
- "Buildah" - Advanced Podman Build
- "podman_bootstrap.sh" - Troubleshooting the Build
- "FUSE" - Troubleshooting the Build
- "TOML" - Including Programs in Redox
- "redox-os/games" - Coding and Building
- "script" - Coding and Building
- "trick" - Coding and Building
- "here" - Literate programming
- "Rust's book about Error Handling" - Rusting Properly
- "Redox GitLab" - Using Redox Gitlab
- "Redox GitLab" - Signing in to GitLab
- "here" - Signing in to GitLab
- "ED25519" - Signing in to GitLab
- "F-Droid" - Signing in to GitLab
- "Play Store" - Signing in to GitLab
- "Google Authenticator" - Signing in to GitLab
- "Tofu Authenticator (open-source)" - Signing in to GitLab
- "iOS built-in authenticator" - Signing in to GitLab
- "Redox GitLab" - Repository Structure
- "redox" - Repository Structure
- "Repository" - Creating Proper Pull Requests
- "rustfmt" - Creating Proper Pull Requests
- "Redox Merge Request room" - Creating Proper Pull Requests
- "Redox Space" - Chat
- "Redox Support room" - Chat
- "Redox OS/Dev" - Chat
- "Redox OS/General" - Chat
- "Mattermost" - Chat
