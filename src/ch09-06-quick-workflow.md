# Quick Workflow

This page will describe the most quick testing/development workflow for people that want an unified list to do things.

**You need to fully understand the build system to use this workflow, as it don't give detailed explanation of each command to save time and space**

- Download/run the `bootstrap.sh` script (commonly used when breaking changes on upstream require a fresh build system copy)

```sh
curl -sf https://gitlab.redox-os.org/redox-os/redox/raw/master/bootstrap.sh -o bootstrap.sh
```

```sh
bash -e bootstrap.sh
```

- Download and build the toolchain and recipes

```sh
cd redox
```

```sh
make all
```

- Update the build system and its submodules

```sh
make pull
```

- Update the toolchain and relibc

```sh
touch relibc
```

```sh
make prefix
```

- Update recipes and the QEMU image

```sh
make rebuild
```

- Wipe the toolchain and build again (commonly used to fix problems)

```sh
rm -rf prefix
```

```sh
make prefix
```

- Wipe the toolchain and recipe binaries and build them again (commonly used to fix unknown problems or update the build system after breaking changes on upstream)

```sh
make clean all
```

- Wipe the toolchain and recipe sources/binaries and download/build them again (commonly used to fix unknown problems or update the build system after breaking changes)

```sh
make distclean all
```

- Create a recipe to insert your files on the QEMU image

```sh
mkdir cookbook/recipes/myfiles
```

```sh
mkdir cookbook/recipes/myfiles/source
```

```sh
nano cookbook/recipes/myfiles/recipe.toml
```

```toml
[build]
template = "custom"
script = """
mkdir -pv "${COOKBOOK_STAGE}"/home/user
cp -rv "${COOKBOOK_SOURCE}"/* "${COOKBOOK_STAGE}"/home/user
"""
```

```sh
nano config/your-arch/your-config.toml
```

```
myfiles = {}
```

```sh
make myfiles image
```

- Comment out a recipe from the build configuration (mostly used if some default recipe is broken)

```sh
nano config/your-cpu-arch/your-config.toml
```

```
#recipe-name = {}
```

- Create logs

```sh
make some-command 2>&1 | tee file-name.log
```