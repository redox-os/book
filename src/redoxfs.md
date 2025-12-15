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

## Tooling

RedoxFS tooling can be used to create, mount and edit contents of an `.img` file containing RedoxFS. It can be installed with:

```sh
cargo install redoxfs
```

If you found errors while installing it, make sure to install `fuse3` development tools.

### Create a disk

You can create an empty, non bootable RedoxFS by allocating an empty file with `fallocate` then run `redoxfs-mkfs` to initialize the whole image as `RedoxFS`.

```sh
fallocate -l 1G redox.img
```

```sh
redoxfs-mkfs redox.img
```

To create an encrypted disk, pass `--encrypt`, it will ask the password though a masked prompt:

```sh
redoxfs-mkfs --encrypt redox.img
```

To create a disk with contents from an existing directory, use `redoxfs-ar`. At this moment `redoxfs-ar` overwrites existing content and have no  `--encrypt` flag.

```sh
redoxfs-ar redox.img ./sysroot
```

### Create a bootable disk

The second option of `redoxfs-mkfs` and third option of `redoxfs-ar` accepts a file that's contains a raw image to be put as a reserved disk space. This is meant to be a bootloader. Redox OS can be booted using [the official bootloader](https://gitlab.redox-os.org/redox-os/bootloader).

First, you need to clone the bootloader repository and build it. Commands below will make a BIOS bootloader:

```sh
git clone https://gitlab.redox-os.org/redox-os/bootloader
```

```sh
make -C bootloader TARGET=x86-unknown-none BUILD=build all
```

After the bootloader created in `bootloader/build/bootloader.bin`, you can create a new bootable disk either using `redoxfs-mkfs` or `redoxfs-ar`:

```sh
redoxfs-mkfs redox.img bootloader/build/bootloader.bin
```

```sh
redoxfs-ar redox.img ./sysroot bootloader/build/bootloader.bin
```

You can also convert a non bootable disk into bootable using `redoxfs-clone`:

```sh
redoxfs-clone redox.img redox-bootable.img bootloader/build/bootloader.bin
```

It's not possible to create a bootable UEFI using this option, as it involves in creating GPT-partitioned disk, which currently only implemented in [redox-installer](https://gitlab.redox-os.org/redox-os/installer/). A dual boot option in the same disk is also impossible if booting from BIOS.

Note that you need to have `boot/kernel` and `boot/initfs` in the image to make it actually bootable. You can build those from [kernel](https://gitlab.redox-os.org/redox-os/kernel) and [base](https://gitlab.redox-os.org/redox-os/base) repository, or a [Redox OS build repository](./podman-build.md). 

### Mount a disk

To mount the disk, run `redoxfs [image] [directory]`:

```sh
mkdir ./redox-img
```

```sh
redoxfs redox.img ./redox-img
```

It will mount the disk using FUSE underneath.

The difference with `redoxfs-ar` is the latter overwrites existing disk content. Mounting a disk through FUSE is the only way to update existing content in RedoxFS image.

### Unmount the disk

Unmount the disk using FUSE unmount binary:

```sh
fusermount3 ./redox-img
```

### Extend the disk

> ⚠️ **Warning:** Experimental, please backup beforehand

To extend an existing disk, you need to extend the file beforehand:

```sh
truncate -s 2GB redox.img
```

Then you can run `redoxfs-resize [disk] [size]`. The `[size]` option can be `max` (the default), `min`, or a fixed size defined by [parse-size](https://crates.io/crates/parse-size). 

```sh
redoxfs-resize ./redox.img
```

```
minimum size: 438.75 MB (418.42 MiB)
maximum size: 2.00 GB (1.86 GiB)
new size: 2.00 GB (1.86 GiB)
growing by 1559135232
redoxfs-resize: resized filesystem on redox.img
	uuid: febb081e-06ff-4786-a878-f1bb031cdf97
	size: 2.00 GB (1.86 GiB)
	used: 438.65 MB (418.33 MiB)
	free: 1.56 GB (1.45 GiB)
```

### Shrink the disk

> ⚠️ **Warning:** Experimental, please backup beforehand

To shrink an existing disk, you can use `redoxfs-resize`:

```sh
redoxfs-resize ./redox.img min
```

```
minimum size: 438.77 MB (418.44 MiB)
maximum size: 2.00 GB (1.86 GiB)
new size: 438.77 MB (418.44 MiB)
shrinking by 1559135232
redoxfs-resize: resized filesystem on redox.img
	uuid: febb081e-06ff-4786-a878-f1bb031cdf97
	size: 438.77 MB (418.44 MiB)
	used: 438.64 MB (418.32 MiB)
	free: 122.88 kB (120 KiB)
```

You can use the value from `shrinking by ...` to accurately tell how much bytes can be shrinked:

```sh
truncate -s -1559135232 redox.img
```
