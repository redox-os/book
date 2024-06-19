# Drivers

On Redox the device drivers are user-space daemons, being a common Unix process they have their own namespace with restricted schemes.

In other words, a driver on Redox can't damage other system interfaces, while on Monolithic kernels a driver could wipe your data because the driver run on the same memory address space of the filesystem (thus same privilege level).

You can find the driver documentation on the repository README and drivers code.

- [Drivers repository](https://gitlab.redox-os.org/redox-os/drivers)
