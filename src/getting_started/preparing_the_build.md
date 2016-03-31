Preparing the build.
====================

Woah! You made it so far, all the way to here. Congrats! Now we gotta build Redox.

_If you're lazy, and on an Linux computer. Well, you're today's winner! Just run the bootstrapping script, which does the build preparation for you:_

```sh
$ curl -sf https://raw.githubusercontent.com/redox-os/redox/master/bootstrap.sh -o bootstrap.sh && bash -e bootstrap.sh
```

Oh, you're not lazy? Well, then the next section is for you!

Cloning the repository
----------------------
 
 ```sh
 $ git clone https://github.com/redox-os/redox.git && cd redox && git submodule update --init
 ```
 
 Give it a while. Redox is big.
 

Installing the build dependencies manually
------------------------------------------


I assume you have a package manager, which you know how to use (if not, you have to install the build dependencies manually). We need the following deps: `make` (probably already installed), `nasm` (the assembler, we use in the build process), `qemu` (the hardware emulator, we will use. If you want to run Redox on real hardware, you should read the `fun` chapter):)

```
$ [your package manager] install make nasm qemu
```

While the following step is not _required_, it is recommended. If you already have a functioning Rust nightly installation, you can skip this step:

We will use `multirust` to manage our Rust versions:

```sh
$ curl -sf https://raw.githubusercontent.com/brson/multirust/master/quick-install.sh | sh
```

Now, we have to configure our multirust installation to default to `nightly`:

```sh
$ multirust override nightly
```
