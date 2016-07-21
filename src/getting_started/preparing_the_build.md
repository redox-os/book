Preparing the build.
====================

Woah! You made it so far, all the way to here. Congrats! Now we gotta build Redox.

_If you're lazy, and on a Linux or MacOs computer. Well, you're today's winner! Just run the bootstrapping script, which does the build preparation for you:_

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

We will use `rustup` to manage our Rust versions:

```sh
$ curl https://sh.rustup.rs -sSf | sh
```

Rustup will install the `stable` version of Rust. To run Redox, you have to install the `nightly` version of Rust, like this:

```sh
$ rustup toolchain install nightly
$ rustup override set nightly
```
