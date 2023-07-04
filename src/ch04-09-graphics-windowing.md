# Graphics and Windowing

### Drivers

- `vesad` (VESA)

It's not really a driver, it writes to a framebuffer given by firmware (via UEFI or BIOS software interrupts).

Because we don't yet have a dedicated GPU driver, instead relying on what firmware gives us.

- GPU drivers

In Linux/BSDs, the GPU communication with the kernel is done by the DRM system (Direct Renderig Manager), which Mesa3D drivers use to work (Mesa3D implement OpenGL/Vulkan drivers, DRM expose the hardware interfaces).

Said this, on Redox the GPU driver needs to be a user-space daemon which use the kernel functions to talk with hardware.

The last step is to adapt our Mesa3D [fork](https://gitlab.redox-os.org/redox-os/mesa)/[recipe](https://gitlab.redox-os.org/redox-os/cookbook/-/blob/master/recipes/mesa/recipe.toml) to use these user-space daemons.

### Orbital

Orbital provides a display server, window manager and compositor.

The display server is written in Rust, thus being an alternative to Wayland/X11.

Current features:

- Custom Resolutions
- App Launcher (bottom bar)
- File Manager
- Text Editor
- Calculator
- Terminal Emulator

If you hold the **Super** key (generally the key with a Windows logo) it will show all keyboard shortcuts in a pop-up.

### Accelerated Graphics

We don't have GPU drivers yet but [LLVMpipe](https://docs.mesa3d.org/drivers/llvmpipe.html) from Mesa3D is working.
