# Package Management

The Redox package management is similar to the major Linux distributions, but static linking is used instead of dynamic linking.

- Better Security

Static linking increase the system security because each program use a different library code, even if the same version of a vulnerable library is used.

The attacker would need to inject code on each program's memory address space to steal sensitive data and not the shared library's memory address space, it increases the cost of the attack.

Rust programs use static linking by default.

- Better Performance

When a program is compiled with static linking the library references are resolved before execution, thus there's no need for processing on the dynamic linker.

By doing this the programs open faster.

- Simple dependency management

When programs need different library versions the dynamic linking will add a conflict because the different versions use the same object name, thus programs will need different `/lib` folders.

While in static linking there's no need for runtime dependency management, only source packages for different library versions.

Rust programs aren't affected by this problem because of Cargo.

## Format

### What is "pkgar" ?

`pkgar`, short for "package archive", is a file format, library, and command-line
executable for creating and extracting cryptographically secure collections of
files, primarly for use in package management on Redox OS. The technical details
are still in development, so we think it is good to instead review the goals of
`pkgar` and some examples that demonstrate its design principles.

`pkgar` has the following goals:

- Atomic - Updates are done atomically if possible
- Economical - Transfer of data must only occur when hashes change, allowing for
  network and data usage to be minimized
- Fast - Encryption and hashing algorithms are chosen for performance, and
  packages can potentially be extracted in parallel
- Minimal - Unlike other formats such as `tar`, the metadata included in a
  `pkgar` file is only what is required to extract the package
- Relocatable - Packages can be installed to any directory, by any user,
  provided the user can verify the package signature and has access to that
  directory.
- Secure - Packages are always cryptographically secure, and verification of all
  contents must occur before installation of a package completes.

To demonstrate how the format's design achieves these goals, let's look at some
examples.

### Example 1: Newly installed package

In this example, a package is installed that has never been installed on the
system, from a remote repository. We assume that the repository's public key is
already installed on disk, and that the URL to the package's `pkgar` is known.

First, a small, fixed-size header portion of the `pkgar` is downloaded. This is
currently 136 bytes in size. It contains a NaCL signature, NaCL public key,
BLAKE3 hash of the entry metadata, and 64-bit count of entry metadata structs.

Before this header can be used, it is verified. The public key must match the
one installed on disk. The signature of the struct must verify against the
public key. If this is true, the hash and entry count are considered valid.

The entry metadata can now be downloaded to a temporary file. During the
download, the BLAKE3 hash is calculated. If this hash matches the hash in the
header, the metadata is considered valid and is moved atomically to the correct
location for future use. Both the header and metadata are stored in this file.

Each entry metadata struct contains a BLAKE3 hash of the entry data, a 64-bit
offset of the file data in the data portion of the `pkgar`, a 64-bit size of the
file data, a 32-bit mode identifying Unix permissions, and up to a 256-byte
relative path for the file.

For each entry, before downloading the file data, the path can be validated for
install permissions. The file data is downloaded to a temporary file, with no
read, write, or execute permissions. While the download is happening, the BLAKE3
hash is calculated. If this hash matches, the file data is considered valid.

After downloading all entries, the temporary files have their permissions set
as indicated by the mode in the metadata. They are then moved atomically to the
correct location. At this point, the package is successfully installed.

### Example 2: Updated package

In this example, a package is updated, and only one file changes. This is to
demonstrate the capabilities of `pkgar` to minimize disk writes and network
traffic.

First, the header is downloaded. The header is verified as before. Since a file
has changed, the metadata hash will have changed. The metadata will be
downloaded and verified. Both header and metadata will be atomically updated on
disk.

The entry metadata will be compared to the previous entry metadata. The hash for
one specific file will have changed. Only the contents for that file will be
downloaded to a temporary file, and verified. Once that is complete, it will be
atomically updated on disk. The package update is successfully completed, and
only the header, entry metadata, and the files that have changed were
downloaded and written.

### Example 3: Package verification

In this example, a package is verified against the metadata saved on disk. It is
possible to reconstruct a package from an installed system, for example, in
order to install that package from a live disk.

First, the header is verified as before. The entry metadata is then verified.
If there is a mismatch, an error is thrown and the package could be reinstalled.

The entry metadata will be compared to the files on disk. The mode of each file
will be compared to the metadata mode. Then the hash of the file data will be
compared to the hash in the metadata. If there is a mismatch, again, an error
is thrown and the package could be reinstalled.

It would be possible to perform this process while copying the package to a new
target. This allows the installation of a package from a live disk to a new
install without having to store the entire package contents.

### Conclusion

As the examples show, the design of `pkgar` is meant to provide the best
possible package management experience on Redox OS. At no point should invalid
data be installed on disk in accessible files, and installation should be
incredibly fast and efficient.

Work still continues on determining the repository format.

The source for `pkgar` is fairly lightweight, we highly recommend reading it and contributing to the [pkgar](https://gitlab.redox-os.org/redox-os/pkgar) repository.

If you have questions feel free to ask us on the [Chat](./chat.md) page.
