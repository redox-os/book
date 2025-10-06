# Libraries and APIs

This page covers the context of the libraries and APIs on Redox.

- [Versions](#versions)
    - [Redox](#redox)
    - [Providing a Stable ABI](#providing-a-stable-abi)
- [Interfaces](#interfaces)
    - [relibc](#relibc)
    - [libredox](#libredox)
    - [redox_syscall](#redox_syscall)
- [Crates](#crates)
- [Code Porting](#code-porting)
    - [Rust std crate](#rust-std-crate)
- [Compiling for Redox](#compiling-for-redox)
    - [Porting Method](#porting-method)

## Terms

| **Interface**                                                     | **Explanation**                                                                                           |
|-------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| [API](https://en.wikipedia.org/wiki/API)                          | The interface of the library **source code** (the programs use the API to obtain the library functions)   |
| [ABI](https://en.wikipedia.org/wiki/Application_binary_interface) | The interface of the program **binary** and system services (normally the system call interface)          |

## Versions

The Redox crates follow the SemVer model from Cargo for version numbers (except `redox_syscall`), you can read more about it below:

- [SemVer](https://semver.org/)
- [Cargo SemVer](https://doc.rust-lang.org/cargo/reference/resolver.html)
- [Cargo SemVer compatibility](https://doc.rust-lang.org/cargo/reference/semver.html)

### Redox

This section covers the versioning system of Redox and important components.

- Redox OS: `x.y.z`

`x` is ABI version, `y` is API updates with backward compatibility and `z` is fixes with backward compatiblity.

- libredox: Currently it don't follow the SemVer model but will in the future

- redox_syscall: `x.y.z`

`x` is the ABI version (it will remain 0 for a while), `y` is the API updates and `z` is fixes (no backward compatibility).

### Providing a Stable ABI

The implementation of a stable ABI is important to avoid frequent recompilation when an operating system is under heavy development, thus improving the development speed.

A stable ABI typically **reduces** development speed for the ABI **provider** (because it needs to uphold backward compatibility), whereas it **improves** development speed for the ABI **user**. Because relibc will be smaller than the rest of Redox, this is a good tradeoff, and improves development speed in general

It also offer backward compatibility for binaries compiled with old API versions.

Currently only libredox will have a stable ABI, relibc will be unstable only as long as it's under heavy development and redox_syscall will remain unstable even after the 1.0 version of Redox.

Our final goal is to keep the Redox ABI stable in all `1.x` versions, if an ABI break happens, the next versions will be `2.x`

A program compiled with an old API **version** will continue to work with a new API version, in most cases statically linked library updates or program updates will require recompilation, while in others a new ABI version will add performance and security improvements that would recommend a recompilation of the program.

If the dynamic linker can't resolve the references of the program binary, a recompilation is required.

## Interfaces

Redox uses different mechanisms, compared to Linux, to implement system capabilities.

### relibc

[relibc](https://gitlab.redox-os.org/redox-os/relibc) is an implementation of the [C Standard Library](https://en.wikipedia.org/wiki/C_standard_library) (libc) and POSIX in Rust.

relibc knows if it's compiled for Linux or Redox ahead-of-time (if the target is Redox relibc calls functions in libredox), the goal is to organize platform-specific functionality into clean modules.

Since Redox and Linux executables look so similar and can accidentally be executed on the other platform, it checks that it's running on the same platform it was compiled for, at runtime.

### libredox

[libredox](https://gitlab.redox-os.org/redox-os/libredox) is a system library for Redox components and Rust programs/libraries, it will allow Rust programs to limit their need to use C-style APIs (the relibc API and ABI).

It's both a crate (calling the ABI functions) and an ABI, the ABI is provided from relibc while the crate (library) is a wrapper above the libredox ABI.

(Redox components, Rust programs and libraries use this library)

You can see Rust crates using it on the [Reverse Dependencies](https://crates.io/crates/libredox/reverse_dependencies) category.

### redox_syscall

[redox_syscall](https://gitlab.redox-os.org/redox-os/syscall) contain the system call numbers and Rust API wrappers for the inline Assembly code of system calls to be used with low-level components and libraries.

(redox_syscall should not be used directly by programs, use libredox instead)

## Crates

Some Redox projects have crates on `crates.io` thus they use a version-based SemVer development, if some change is sent to their repository they need to release a new version on `crates.io`

- [libredox](https://crates.io/crates/libredox)
- [redox_syscall](https://crates.io/crates/redox_syscall)
- [redox-path](https://crates.io/crates/redox-path)
- [redox-scheme](https://crates.io/crates/redox-scheme)
- [redoxfs](https://crates.io/crates/redoxfs)
- [redoxer](https://crates.io/crates/redoxer)
- [redox_installer](https://crates.io/crates/redox_installer)
- [redox-kprofiling](https://crates.io/crates/redox-kprofiling)
- [redox-users](https://crates.io/crates/redox_users)
- [redox-buffer-pool](https://crates.io/crates/redox-buffer-pool)
- [redox_log](https://crates.io/crates/redox-log)
- [redox_termios](https://crates.io/crates/redox_termios)
- [redox-daemon](https://crates.io/crates/redox-daemon)
- [redox_event](https://crates.io/crates/redox_event)
- [redox_event_update](https://crates.io/crates/redox_event_update)
- [redox_pkgutils](https://crates.io/crates/redox_pkgutils)
- [redox_uefi](https://crates.io/crates/redox_uefi)
- [redox_uefi_alloc](https://crates.io/crates/redox_uefi_alloc)
- [redox_dmi](https://crates.io/crates/redox_dmi)
- [redox_hwio](https://crates.io/crates/redox_hwio)
- [redox_intelflash](https://crates.io/crates/redox_intelflash)
- [redox_liner](https://crates.io/crates/redox_liner)
- [redox_uefi_std](https://crates.io/crates/redox_uefi_std)
- [ralloc](https://crates.io/crates/ralloc)
- [orbclient](https://crates.io/crates/orbclient)
- [orbclient_window_shortcuts](https://crates.io/crates/orbclient_window_shortcuts)
- [orbfont](https://crates.io/crates/orbfont)
- [orbimage](https://crates.io/crates/orbimage)
- [orbterm](https://crates.io/crates/orbterm)
- [orbutils](https://crates.io/crates/orbutils)
- [slint_orbclient](https://crates.io/crates/slint_orbclient)
- [ralloc_shim](https://crates.io/crates/ralloc_shim)
- [ransid](https://crates.io/crates/ransid)
- [gitrepoman](https://crates.io/crates/gitrepoman)
- [pkgar](https://crates.io/crates/pkgar)
- [pkgar-core](https://crates.io/crates/pkgar-core)
- [pkgar-repo](https://crates.io/crates/pkgar-repo)
- [termion](https://crates.io/crates/termion)
- [reagent](https://crates.io/crates/reagent)
- [gdb-protocol](https://crates.io/crates/gdb-protocol)
- [orbtk](https://crates.io/crates/orbtk)
- [orbtk_orbclient](https://crates.io/crates/orbtk_orbclient)
- [orbtk-render](https://crates.io/crates/orbtk-render)
- [orbtk-shell](https://crates.io/crates/orbtk-shell)
- [orbtk-tinyskia](https://crates.io/crates/orbtk-tinyskia)

### Manual Patching

If you don't want to wait a new release on `crates.io`, you can patch the crate temporarily by fetching the version you need from GitLab and changing the crate version in `Cargo.toml` to `crate-name = { path = "path/to/crate" }`

## Code Porting

### Rust std crate

Most **Rust** programs include the [std](https://doc.rust-lang.org/std/) (libstd) crate, In addition to implementing standard Rust abstractions, this crate provides a safe Rust interface to system functionality in libc, which it invokes via a [FFI](https://doc.rust-lang.org/rust-by-example/std_misc/ffi.html) to libc.

`std` has mechanisms to enable operating system variants of certain parts of the library, the file [sys/mod.rs](https://github.com/rust-lang/rust/blob/master/library/std/src/sys/mod.rs) selects the appropriate variant to include, programs use the `std::` prefix to call this crate.

To ensure portability of programs, Redox supports the Rust `std` crate, for Redox, `std::sys` refers to `std::sys::unix`

Redox-specific code can be found on the [std source tree](https://github.com/rust-lang/rust/tree/master/library/std/src/os/redox).

For most functionality, Redox uses `#[cfg(unix)]` and [sys/unix](https://github.com/rust-lang/rust/tree/master/library/std/src/sys/pal/unix).

Some Redox-specific functionality is enabled by `#[cfg(target_os = "redox")]`

## Compiling for Redox

The Redox toolchain automatically links programs with relibc in place of the libc you would find on Linux.

### Porting Method

You can use `#[cfg(unix)]` and `#[cfg(target_os = "redox")]` to guard platform specific code.