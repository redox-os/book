# Graphics and Windowing

## Drivers

### vesad (VESA)

It's not really a driver, it writes to a framebuffer given by firmware (via UEFI or BIOS software interrupts).

Because we don't have GPU drivers yet, we rely on what firmware gives to us.

### GPU drivers

On Linux/BSDs, the GPU communication with the kernel is done by the DRM system (Direct Renderig Manager, `libdrm` library), that Mesa3D drivers use to work (Mesa3D implement OpenGL/Vulkan drivers, DRM expose the hardware interfaces).

Said this, on Redox the GPU driver needs to be an user-space daemon which use the system calls/schemes to talk with the hardware.

The last step is to adapt our Mesa3D [fork](https://gitlab.redox-os.org/redox-os/mesa)/[recipe](https://gitlab.redox-os.org/redox-os/cookbook/-/blob/master/recipes/mesa/recipe.toml) to use these user-space daemons.

### Accelerated Graphics

We don't have GPU drivers yet but [LLVMpipe](https://docs.mesa3d.org/drivers/llvmpipe.html) (OpenGL CPU emulation) and VirtIO (2D/3D accleration from/for a virtual machine) is working.

## Orbital

The Orbital desktop environment provides a display server, window manager and compositor.

- The display server is more simple than X11 and Wayland, making the porting task more quick and easy.

### Features

- Custom Resolutions
- App Launcher (bottom bar)
- File Manager
- Text Editor
- Calculator
- Terminal Emulator

If you hold the **Super** key (generally the key with a Windows logo) it will show all keyboard shortcuts in a pop-up.

### Libraries

The programs written with these libraries can run on Orbital.

- SDL1.2
- SDL2
- winit
- softbuffer
- Slint (use winit/softbuffer)
- Iced (use winit/softbuffer)
- egui (can use winit or SDL2)

### Porting

If you want to port a program to Orbital, see below:

- If the program is written in Rust probably it works on Orbital because the `winit` crate is used in most places, but there are programs that access X11 or Wayland directly. You need to port these programs to `winit` and merge on upstream.

- If the program is written in C or C++ and access X11 or Wayland directly, it must be ported to the [Orbital library](https://gitlab.redox-os.org/redox-os/liborbital).