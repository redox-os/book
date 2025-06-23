# Hardware Support

There are billions of devices with hundreds of models and architectures in the world. We try to write drivers for the most used devices to support more people. Support depends on the specific hardware, since some drivers are device-specific and others are architecture-specific.

Have a look at the [HARDWARE.md](https://gitlab.redox-os.org/redox-os/redox/-/blob/master/HARDWARE.md) document to see all tested computers.

## I have a low-end computer, would Redox work on it?

A CPU is the most complex machine of the world: even the oldest processors are powerful for some tasks but not for others.

The main problem with old computers is the amount of RAM available (they were sold in a era where RAM chips were expensive) and the lack of SSE/AVX extensions (programs use them to speed up the algorithms). Because of this some modern programs may not work or require a lot of RAM to perform complex tasks.

Redox itself will work normally if the processor architecture is supported by the system, but the performance and stability may vary per program.

## Why CPUs older than i686 aren't supported?

- i686 (essentially Pentium II) introduced a wide range of features that are critical for the Redox kernel.
- It would be possible to go all the way back to i486, but that would make us lose nice functions like `fxsave`/`fxrstor` and we would need to build userspace without any SSE code.
- i386 has no atomics (at all) which makes it not likely as a target.

## Compatibility Table

| **Category**        | **Items**                                                                                                                                            |
|---------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| CPU                 | - Intel 64-bit (x86_64) <br>- Intel 32-bit (i686) from Pentium II and after with limitations <br>- AMD 32/64-bit <br>- ARM 64-bit (Aarch64) with limitations |
| Hardware Interfaces | - ACPI, PCI, USB                                                                                                                                       |
| Storage             | - IDE (PATA), SATA (AHCI), NVMe                                                                                                                        |
| Video               | - BIOS VESA, UEFI GOP                                                                                                                                  |
| Sound               | - Intel, Realtek chipsets                                                                                                                              |
| Input               | - PS/2 keyboards, mouse and touchpad <br> - USB keyboards, mouse and touchpad                                                                          |
| Ethernet            | - Intel Gigabit and 10 Gigabit ethernet <br>- Realtek ethernet                                                                                        |
