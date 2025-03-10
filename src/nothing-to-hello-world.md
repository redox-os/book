# From Nothing To Hello World

This page explains the most quick way to test a program on Redox, this tutorial don't build Redox from source.

In this example we will use a "Hello World" program written in Rust.

- Create the `tryredox` folder

```sh
mkdir -p ~/tryredox
```

- Open the `tryredox` folder

```sh
cd ~/tryredox
```

- Download the script to bootstrap Podman and download the Redox build system

```sh
curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/podman_bootstrap.sh -o podman_bootstrap.sh
```

- Execute the downloaded script

```sh
time bash -e podman_bootstrap.sh
```

- Enable the Rust toolchain on the current shell

```sh
source ~/.cargo/env
```

- Change the active directory to the Redox build system directory

```sh
cd redox
```

- Create the `.config` file and add the `REPO_BINARY` environment variable to enable the binary-mode

```sh
echo "CONFIG_NAME?=my_config" >> .config
```

- Create the `hello-world` recipe folder

```sh
mkdir cookbook/recipes/other/hello-world
```

- Create the `source` folder of the recipe

```sh
mkdir cookbook/recipes/other/hello-world/source
```

- Change the active directory to the `source` folder

```sh
cd cookbook/recipes/other/hello-world/source
```

- Create a Cargo project with the "Hello World" string

```sh
cargo init --name="hello-world"
```

- Go back to the main folder

```sh
cd ~/tryredox/redox
```

- Create the `hello-world` recipe configuration

```sh
nano cookbook/recipes/other/hello-world/recipe.toml
```

- Add the recipe configuration text

```toml
[build]
template = "cargo"
```

- Create the `my_config` filesystem configuration

```sh
cp config/x86_64/desktop.toml config/x86_64/my_config.toml
```

- Open the `my_config` filesystem configuration file at `config/x86_64/my_config.toml` with your text editor and add the `hello-world` recipe, the following code block show where you need to edit.

```toml
[packages]
# Add the item below
hello-world = "recipe"
```

- Build the Hello World program and the Redox image

```sh
time make prefix r.hello-world image
```

- Start the Redox VM without a GUI

```sh
make qemu gpu=no
```

In the "redox login" screen write "user" as user name and press Enter.

- Run the "Hello World" program

```sh
hello-world
```

- Power off the Redox VM

```sh
sudo shutdown
```
