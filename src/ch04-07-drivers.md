# Drivers

### Kernel Functions

These are the most used kernel functions by Redox drivers.

- `iopl` - syscall that sets the I/O privilege level. x86 has four privilege rings (0/1/2/3), of which the kernel runs in ring 0 and userspace in ring 3. IOPL can only be changed by the kernel, for obvious security reasons, and therefore the Redox kernel needs root to set it. It is unique for each process. Processes with IOPL=3 can access I/O ports, and the kernel can access them as well.
- `physalloc` - allocates physical memory frames.
- `physfree` - frees memory frames.
- `physmap` - maps physical memory frames to driver-accessible virtual memory pages.
- `irq:` - allows getting events from interrupts. It is used primarily by listening for its file descriptors using the `event:` scheme.

If you want to write a driver, you can see this [example](https://gitlab.redox-os.org/redox-os/exampled) driver or read the code of the existent ones or the most close driver type for your device.

### - [Drivers repository](https://gitlab.redox-os.org/redox-os/drivers)
