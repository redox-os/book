# RedoxFS

This is the default filesystem of Redox OS, inspired by ZFS and adapted to a microkernel architecture.

Redox had a read-only ZFS driver but it was abandoned because of the monolithic nature of ZFS that created problems with the Redox microkernel design.

(It's a replacement for [TFS](https://gitlab.redox-os.org/redox-os/tfs))

Current features:

- Compatible with Redox and Linux (FUSE)
- Copy-on-write
- Data/metadata checksums
- Transparent encryption
- Standard Unix file attributes
- File/directory size limit up to 193TiB (212TB)
- File/directory quantity limit up to 4 billion per 193TiB (2^32 - 1 = 4294967295)
- Disk encryption fully supported by the Redox bootloader, letting it load the kernel off an encrypted partition.
- MIT licensed

Being MIT licensed, RedoxFS can be bundled on GPL-licensed operating systems (Linux, for example).

## RedoxFS Tooling

RedoxFS tooling can be used to create, mount and edit contents of an `.img` file containing RedoxFS. It can be installed with:

```sh
cargo install redoxfs
```

If you found errors while installing it, make sure to install `fuse3`.

### Create a disk

You can create an empty, non bootable RedoxFS by allocating an empty file with `fallocate` then run `redoxfs-mkfs` to initialize the whole image as `RedoxFS`.

```sh
fallocate -l 1G redox.img
```

```sh
redoxfs-mkfs redox.img
```

### Mount a disk

To mount the disk, run `redoxfs [image] [directory]`:

```sh
mkdir ./redox-img
```

```sh
redoxfs redox.img ./redox-img
```

It will mount the disk using FUSE underneath.

### Unmount

Unmount the disk using FUSE unmount binary:

```sh
fusermount3 ./redox-img
```
