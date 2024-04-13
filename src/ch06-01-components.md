# Components of Redox

Redox is made up of several discrete components. 

## Core

- bootloader - Kernel bootstrap
- kernel - System manager
- bootstrap - User-space bootstrap
- init
- initfs
- drivers - Device drivers
- redoxfS - Filesystem
- audiod - Audio daemon
- netstack - TCP/UDP stack
- ps2d - PS/2 driver
- relibc - Redox C library
- randd
- zerod
- ion - Shell
- orbital - Desktop environment

## Orbital

- orbterm - Terminal
- orbdata - Images, fonts, etc.
- orbaudio - Audio
- orbutils - Bunch of applications
- orblogin - Login prompt
- orbfont - Font rendering library
- orbclient - Display client
- orbimage - Image rendering library 
- orbtk - Cross-platform Rust GUI toolkit, similar to GTK

## Default Programs

- sodium - Text editor
- orbutils
  - background - Wallpaper program
  - browser
  - calculator - Math program
  - character map - Characters list
  - editor - Text Editor
  - file manager
  - launcher - Program menu
  - viewer - Image viewer
