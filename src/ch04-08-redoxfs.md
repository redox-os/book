# RedoxFS

RedoxFS is inspired by ZFS and adapted to a microkernel architecture, Redox had a read-only ZFS driver but it was abandoned because the monolithic nature of ZFS had problems with Redox microkernel design.

Current features:

- Copy-on-write
- Data/metadata checksums
- Transparent encryption
- Standard Unix file attributes
- File/directory size limit up to 193TiB (212TB)
- File/directory quantity limit up to 4 billion per 193TiB (2^32 - 1 = 4294967295)
- MIT licensed

Disk encryption fully supported by the Redox bootloader, letting it load the kernel off an encrypted partition.

Being MIT licensed, RedoxFS can be added on GPL kernels (Linux, for example).
