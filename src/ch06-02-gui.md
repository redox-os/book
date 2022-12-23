# GUI

The desktop environment in Redox, referred to as Orbital, is provided by a set of programs that run in userspace:

## Programs
The following are command-line utilities that provide GUI services

### orbital
The orbital display and window manager sets up the orbital: scheme, manages the display, and handles requests for window creation, redraws, and event polling

### launcher
The launcher multi-purpose program that scans the applications in the `/apps/` directory and provides the following services:

#### Called Without Arguments
A taskbar that displays icons for each application

#### Called With Arguments
An application chooser that opens a file in a matching program
- If one application is found that matches, it will be opened automatically
- If more than one application is found, a chooser will be shown

## Applications
The following are GUI utilities that can be found in the `/apps/` directory.

## Calculator
A calculator that provides similar functionality to the `calc` program

## Editor
A simple editor that is similar to notepad

## File Browser
A file browser that displays icons, names, sizes, and details for files. It uses the `launcher` command to open files when they are clicked

## Image Viewer
A simple image viewer

## Pixelcannon
A 3d renderer that can be used for benchmarking the Orbital desktop.

## Sodium
A vi-like editor that provides syntax highlighting

## Terminal Emulator
An ANSI terminal emulator that launches `sh` by default.
