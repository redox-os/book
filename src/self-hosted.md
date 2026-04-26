# Self-hosted Development

This page explain how to configure the build system or Redox for development from Redox.

## QEMU in Linux

This method is used if you are doing self-hosted development in QEMU from Linux.

- Add the `cookbook` recipe to your Redox image and go to the `cookbook` directory:

```
make rp.cookbook qemu
```

```
cd cookbook
```

- Build Redox from source

```
make prefix r.sys
```

- Build and install your system changes

```
make ri.sys
```

If the process is successful you can reboot the system to load your changes:

- Shutdown the system (reboot is not reliable yet)

```
sudo shutdown -r
```

- Launch QEMU again

```
make qemu
```

## Real Hardware

TODO
