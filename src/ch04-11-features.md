# Features

- [Desktop](#desktop)
- [Mobile](#mobile)
- [External References](#external-references)

This page contains an operating system comparison table for common/important features.

## Desktop

| **Feature** | **Redox** | **Linux** (also known as GNU/Linux) | **FreeBSD** | **Plan 9** |
|-------------|-----------|-------------------------------------|-------------|------------|
| [SMP](https://en.wikipedia.org/wiki/Symmetric_multiprocessing) | Yes | Yes | Yes | Yes |
| [NUMA](https://en.wikipedia.org/wiki/Non-uniform_memory_access) | No (planned) | Yes | Yes | No |
| Full Disk Encryption | Yes | Yes | Yes | No |
| Exploit Mitigations | No (planned) | Yes | Yes | No |
| [OpenGL](https://en.wikipedia.org/wiki/OpenGL)/[Vulkan](https://en.wikipedia.org/wiki/Vulkan) | Yes (only OpenGL with CPU emulation) | Yes | Yes | No |
| [UEFI](https://en.wikipedia.org/wiki/UEFI) Boot Loader | Yes | Yes | Yes | No |
| [IDE](https://en.wikipedia.org/wiki/Parallel_ATA) | Yes | Yes | Yes | Yes |
| [SATA](https://en.wikipedia.org/wiki/SATA) | Yes | Yes | Yes | Yes |
| [NVMe](https://en.wikipedia.org/wiki/NVM_Express) | Yes | Yes | Yes | No |
| [PCI](https://en.wikipedia.org/wiki/Peripheral_Component_Interconnect) | Yes | Yes | Yes | No |
| [PCIe](https://en.wikipedia.org/wiki/PCI_Express) | Yes | Yes | Yes | No |
| [USB](https://en.wikipedia.org/wiki/USB) | Yes (incomplete) | Yes | Yes | Yes |
| [Ethernet](https://en.wikipedia.org/wiki/Ethernet) | Yes | Yes | Yes | Yes |
| [Wi-Fi](https://en.wikipedia.org/wiki/Wi-Fi) | No (planned) | Yes | Yes | No |
| [Bluetooth](https://en.wikipedia.org/wiki/Bluetooth) | No (planned) | Yes | Yes | No |

## Mobile

| **Feature** | **Redox** | **Android** | **iOS** |
|-------------|-----------|-------------|---------|
| Full Disk Encryption | Yes | Yes | Yes |
| [Sandboxing](https://en.wikipedia.org/wiki/Sandbox_(computer_security)) | Yes | Yes | Yes |
| [USB Tethering](https://en.wikipedia.org/wiki/Tethering) | No (planned) | Yes | Yes |
| [NFC](https://en.wikipedia.org/wiki/Near-field_communication) | No (planned) | Yes | Yes |
| [GPS](https://en.wikipedia.org/wiki/Global_Positioning_System) | No (planned) | Yes | Yes |
| Sensors | No (planned) | Yes | Yes |
| Factory Reset | No (planned) | Yes | Yes |

## External References

- [Rust OS Comparison](https://github.com/flosse/rust-os-comparison) - A table comparing some Rust-written operating systems.