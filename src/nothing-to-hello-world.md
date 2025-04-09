# From Nothing To Hello World

This page describes the quickest way to test a program on Redox. This tutorial doesn't build Redox from source.

In this example we will use a "Hello World" program written in Rust.

 1. Create the `tryredox` folder.

    ```sh
    mkdir -p ~/tryredox
    ```

 2. Navigate to the `tryredox` folder.

    ```sh
    cd ~/tryredox
    ```

 3. Download the script to bootstrap Podman and download the Redox build system.

    ```sh
    curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/podman_bootstrap.sh -o podman_bootstrap.sh
    ```

 4. Execute the downloaded script.

    ```sh
    time bash -e podman_bootstrap.sh
    ```

 5. Enable the Rust toolchain in the current shell.

    ```sh
    source ~/.cargo/env
    ```

 6. Navigate to the Redox build system directory.

    ```sh
    cd ~/tryredox/redox
    ```

 7. Create the `.config` file and add the `REPO_BINARY` environment variable to enable the binary-mode.

    ```sh
    echo "REPO_BINARY?=1 \n CONFIG_NAME?=my_config" >> .config
    ```

 8. Create the `hello-world` recipe folder.

    ```sh
    mkdir cookbook/recipes/other/hello-world
    ```

 9. Create the `source` folder for the recipe.

    ```sh
    mkdir cookbook/recipes/other/hello-world/source
    ```

10. Navigate to the recipe's `source` folder.

    ```sh
    cd cookbook/recipes/other/hello-world/source
    ```

11. Initialize a Cargo project with the "Hello World" string.

    ```sh
    cargo init --name="hello-world"
    ```

12. Create the `hello-world` recipe configuration.

    ```sh
    cd ~/tryredox/redox
    ```

    ```sh
    nano cookbook/recipes/other/hello-world/recipe.toml
    ```

13. Add the following to the recipe configuration:

    ```toml
    [build]
    template = "cargo"
    ```

14. Create the `my_config` filesystem configuration.

    ```sh
    cp config/x86_64/desktop.toml config/x86_64/my_config.toml
    ```

15. Open the `my_config` filesystem configuration file (i.e., `config/x86_64/my_config.toml`) and add the `hello-world` package to it.

    ```toml
    [packages]
    # Add the item below
    hello-world = "source"
    ```

16. Build the Hello World program and the Redox image.

    ```sh
    time make prefix r.hello-world image
    ```

17. Start the Redox virtual machine without a GUI.

    ```sh
    make qemu gpu=no
    ```

18. At the Redox login screen, write "user" for the user name and press Enter.

19. Run the "Hello World" program.

    ```sh
    helloworld
    ```

20. Shut down the Redox virtual machine.

    ```sh
    sudo shutdown
    ```
