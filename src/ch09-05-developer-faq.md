# Developer FAQ

The website [FAQ](https://www.redox-os.org/faq/) have questions/answers for newcomers and end-users, while this FAQ will cover organization/technical questions/answers of developers/testers, feel free to suggest new questions.

(If all else fails, join us on [Chat](./ch13-01-chat.md))

- [General Questions](#general-questions)
    - [What is the correct way to update the build system?](#what-is-the-correct-way-to-update-the-build-system)
    - [How can I verify if my build system is up-to-date?](#how-can-i-verify-if-my-build-system-is-up-to-date)
    - [How can I test my changes on real hardware?](#how-can-i-test-my-changes-on-real-hardware)
    - [How can I write a driver?](#how-can-i-write-a-driver)
    - [How can I port a program?](#how-can-i-port-a-program)
    - [How can I debug?](#how-can-i-debug)
    - [How can I insert files to the QEMU image?](#how-can-i-insert-files-to-the-qemu-image)
    - [How can I change my build variant?](#how-can-i-change-my-build-variant)
    - [How can I increase the filesystem size of my QEMU image?](#how-can-i-increase-the-filesystem-size-of-my-qemu-image)
    - [How can I change the processor architecture of my build system?](#how-can-i-change-the-processor-architecture-of-my-build-system)
    - [I only made a small change to my program. What's the quickest way to test it in QEMU?](#i-only-made-a-small-change-to-my-program-whats-the-quickest-way-to-test-it-in-qemu)
    - [How can I install the packages needed by recipes without a new download of the build system?](#how-can-i-install-the-packages-needed-by-recipes-without-a-new-download-of-the-build-system)
    - [How can I cross-compile to ARM from a x86-64 computer?](#how-can-i-cross-compile-to-arm-from-a-x86-64-computer)
- [Troubleshooting Questions](#troubleshooting-questions)
    - [Scripts](#scripts)
        - [I can't download the bootstrap scripts, how can I fix this?](#i-cant-download-the-bootstrap-scripts-how-can-i-fix-this)
        - [I tried to run the bootstrap.sh and podman_bootstrap.sh scripts but got an error, how to fix this?](#i-tried-to-run-the-bootstrapsh-and-podman_bootstrapsh-scripts-but-got-an-error-how-to-fix-this)
    - [Build System](#build-system)
        - [I called "make all" but it show a "rustup can't be found" message, how can I fix this?](#i-called-make-all-but-it-show-a-rustup-cant-be-found-message-how-can-i-fix-this)
        - [I tried all troubleshooting methods but my build system is still broken, how can I fix that?](#i-tried-all-troubleshooting-methods-but-my-build-system-is-still-broken-how-can-i-fix-that)
    - [Recipes](#recipes)
        - [I had a compilation error with a recipe, how can I fix that?](#i-had-a-compilation-error-with-a-recipe-how-can-i-fix-that)
        - [I tried all methods of the "Troubleshooting the Build" page and my recipe doesn't build, what can I do?](#i-tried-all-methods-of-the-troubleshooting-the-build-page-and-my-recipe-doesnt-build-what-can-i-do)
        - [When I run make r.recipe I get a syntax error, how can I fix that?](#when-i-run-make-rrecipe-i-get-a-syntax-error-how-can-i-fix-that)
    - [QEMU](#qemu)
        - [How can I kill a frozen QEMU process after a kernel panic?](#how-can-i-kill-a-frozen-qemu-process-after-a-kernel-panic)
- [Porting Questions](#porting-questions)
    - [How to determine the dependencies of some program?](#how-to-determine-the-dependencies-of-some-program)
    - [How can I configure the build system of the recipe?](#how-can-i-configure-the-build-system-of-the-recipe)
    - [How can I search for functions on relibc?](#how-can-i-search-for-functions-on-relibc)
- [GitLab Questions](#gitlab-questions)
    - [I have a project/program with breaking changes but my merge request was not accepted, can I maintain the project in a separated repository on the Redox GitLab?](#i-have-a-projectprogram-with-breaking-changes-but-my-merge-request-was-not-accepted-can-i-maintain-the-project-in-a-separated-repository-on-the-redox-gitlab)
    - [I have a merge request with many commits, should I squash them after merge?](#i-have-a-merge-request-with-many-commits-should-i-squash-them-after-merge)
    - [Should I delete my branch after merge?](#should-i-delete-my-branch-after-merge)
    - [How can I have an anonymous account?](#how-can-i-have-an-anonymous-account)

## General Questions

### What is the correct way to update the build system?

- Read [this](./ch08-06-build-system-reference.md#update-the-build-system) page.

### How can I verify if my build system is up-to-date?

- After the `make pull` command, run the `git rev-parse HEAD` command on the build system folders to see if they match the latest commit hash on GitLab.

### How can I test my changes on real hardware?

- Make sure your build system is up-to-date and use the `make live` command to create a bootable image of your changes.

### How can I write a driver?

- Read this [README](https://gitlab.redox-os.org/redox-os/drivers/-/blob/master/README.md).

### How can I port a program?

- Read [this](./ch09-03-porting-applications.md) page.

### How can I debug?

- Read [this](./ch08-05-troubleshooting.md#debug-methods) section.

### How can I insert files to the QEMU image?

- Read [this](./ch09-02-coding-and-building.md#insert-files-on-qemu-image) section.

### How can I change my build variant?

- Insert the `CONFIG_NAME?=your-config-name` environment variable to your `.config` file, read [this](./ch02-07-configuration-settings.md#config) section for more details.

### How can I increase the filesystem size of my QEMU image?

- Change the `filesystem_size` field of your build configuration (`config/ARCH/your-config.toml`) and run `make image`, read [this](./ch02-07-configuration-settings.md#filesystem-size) section for more details.

### How can I change the processor architecture of my build system?

- Insert the `ARCH?=your-arch-code` environment variable on your `.config` file and run `make all`, read [this](./ch02-07-configuration-settings.md#config) section for more details.

### I only made a small change to my program. What's the quickest way to test it in QEMU?

- If you already added the program recipe to your configuration file, run:

```sh
make r.recipe-name image qemu
```

### How can I install the packages needed by recipes without a new download of the build system?

- Download the `bootstrap.sh` script and run:

```sh
./bootstrap.sh -d
```

### How can I cross-compile to ARM from a x86-64 computer?

- - Insert the `ARCH?=aarch64` environment variable on your `.config` file and run `make all`.

## Troubleshooting Questions

### Scripts

#### I can't download the bootstrap scripts, how can I fix this?

- Verify if you have `curl` installed or download the script from your browser.

#### I tried to run the bootstrap.sh and podman_bootstrap.sh scripts but got an error, how to fix this?

- Verify if you have the GNU Bash shell installed on your system.

### Build System

#### I called "make all" but it show a "rustup can't be found" message, how can I fix this?

- Run this command:

```sh
source ~/.cargo/env
```

(If you installed Rustup before the first `bootstrap.sh` run, this error doesn't happen)

#### I tried all troubleshooting methods but my build system is still broken, how can I fix that?

- If `make clean pull all` doesn't work, run the `bootstrap.sh` again to download a fresh build system or install Pop OS!, Ubuntu or Debian.

### Recipes

#### I had a compilation error with a recipe, how can I fix that?

- Read [this](./ch08-05-troubleshooting.md#solving-compilation-problems) section.

#### I tried all methods of the "Troubleshooting the Build" page and my recipe doesn't build, what can I do?

- It happens because your system has an environment problem or missing packages, remove the recipe from your build configuration file to workaround this.

All recipes follow this syntax - `recipe = {}` below the `[packages]` section, the configuration files is placed at - `config/your-arch`.

#### When I run make r.recipe I get a syntax error, how can I fix that?

- Verify if your `recipe.toml` has some typo.

### QEMU

#### How can I kill a frozen QEMU process after a kernel panic?

- Read [this](./ch08-05-troubleshooting.md#kill-the-frozen-qemu-process) section.

## Porting Questions

### How to determine the dependencies of some program?

- Read [this](./ch09-03-porting-applications.md#dependencies) section.

### How can I configure the build system of the recipe?

- Read [this](./ch09-03-porting-applications.md#templates) category.

### How can I search for functions on relibc?

- Read [this](./ch09-03-porting-applications.md#search-for-functions-on-relibc) section.

## GitLab Questions

### I have a project/program with breaking changes but my merge request was not accepted, can I maintain the project in a separated repository on the Redox GitLab?

- Yes.

### I have a merge request with many commits, should I squash them after merge?

- Yes.

### Should I delete my branch after merge?

- Yes.

### How can I have an anonymous account?

- During the account creation process you should add a fake name on the "First Name" and "Last Name" fields and change it later after your account approval (single name field is supported).