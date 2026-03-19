# Graphics and Windowing

## Drivers

### VESA (vesad)

vesad is not really a driver, it writes to a framebuffer given by firmware (via UEFI or BIOS software interrupts).

Because we don't have GPU drivers yet, we rely on what firmware gives to us.

### GPUs

On Linux/BSDs, the GPU communication with the kernel is done by the DRM system (Direct Rendering Manager, `libdrm` library), that Mesa3D drivers use to work (Mesa3D implements OpenGL/Vulkan drivers, DRM exposes the hardware interfaces).

That said, in Redox a "DRM driver" needs to be a user-space driver daemon which uses the system calls/schemes to communicate with the hardware.

The last step is to implement the Redox backend in our Mesa3D [fork](https://gitlab.redox-os.org/redox-os/mesa)/[recipe](https://gitlab.redox-os.org/redox-os/cookbook/-/blob/master/recipes/mesa/recipe.toml) to use these user-space drivers.

## Software Rendering

We don't have GPU drivers yet but [LLVMpipe](https://docs.mesa3d.org/drivers/llvmpipe.html) (OpenGL CPU emulation) is working.

## Orbital

The Orbital desktop environment provides a display server, window manager and compositor.

### Comparison with X11/Wayland

This display server is more simple than X11 and Wayland making the porting task more quick and easy, it's not advanced like X11 and Wayland yet but enough to port most Linux/BSD programs.

Compared to Wayland, Orbital has one protocol server implementation (like X11 for a long time), while Wayland provides protocols for compositors (servers and window managers) and clients (applications if the compositor is not bundled).

### Features

- Custom Resolutions
- App Launcher (bottom bar)
- File Manager
- Text Editor
- Calculator
- Terminal Emulator

If you hold the **Super** key (generally the key with a Windows logo) it will show all keyboard shortcuts in a pop-up.

### Libraries

Programs using the following libraries can work on Orbital.

- winit
- softbuffer
- Slint (through winit and softbuffer)
- Iced (through winit and softbuffer)
- egui (winit or SDL2 can be used)
- SDL1.2
- SDL2
- Mesa3D's OSMesa

### Security

In Orbital a GUI program cannot read input events or the content (framebuffer) from windows of other GUI programs, like Wayland.

### Clients

Apps (or 'clients') create a window and draw to it by using the [orbclient](https://gitlab.redox-os.org/redox-os/orbclient)
client.

#### Client Examples

If you wish to see examples of client apps that use [orbclient](https://gitlab.redox-os.org/redox-os/orbclient)
to "talk" to Orbital and create windows and draw to them, then you can find some in [orbclient/examples](https://gitlab.redox-os.org/redox-os/orbclient/-/tree/master/examples)
folder.

### Porting

If you want to port a program to Orbital, see below:

- If the program is written in Rust it probably works on Orbital because the `winit` crate is used in most places, but there are programs that access X11 or Wayland directly. You need to port these programs to `winit` and merge to upstream.

- If the program is written in C or C++ and accesses X11 or Wayland directly, it must be ported to the [Orbital library](https://gitlab.redox-os.org/redox-os/liborbital).
