# Repository Structure

The [Redox GitLab](https://gitlab.redox-os.org/) consists of a large number of **Projects**, you will find the projects organized as a very large, flat alphabetical list. This is not indicative of the role or importance of the various projects.

## The Redox Project

The `redox` project is actually just the root of the build system. It does not contain any of the code that the final Redox image will include. It includes the Makefiles, configuration files, package system and a few scripts to simplify setup and building. The `redox` project can be found on the [GitLab repository](https://gitlab.redox-os.org/redox-os/redox).

## Recipes

The many **recipes** that are added into the Redox image are built from the corresponding software sources. The name of a Redox package almost always matches the name of its program or library, although this is not enforced.

The **recipe** contains the instructions to download and build a program, for its inclusion in the Redox image.

## Cookbook

The `cookbook` system contains the infrastructure for building the Redox recipes, you can find its source code in the `src` folder and recipes under the `recipes` folder.

## Crates

Some Redox projects are built as Rust crates, and included in Redox recipes using Cargo's dependency management system. Updates to a crate must be pushed to the crate repository in order for it to be included in your build.

## Forks, Tarballs and Other Sources

Some recipes obtain their source code from places other than Redox GitLab. The Cookbook system can pull in source from any Git repository URL. It can also obtain tarballs which is most used by C/C++ programs.

In some cases, the Redox GitLab has a fork of another repository, in order to add Redox-specific patches. Where possible, we try to push these changes upstream, but there are some reasons why this might not be feasible.

## Personal Forks

When you are contributing to Redox, you are expected to make your changes in a personal fork of the relevant project, then create a Merge Request (PR) to have your changes pulled from your fork into the `master` or `main` branches. Note that your personal fork is required to have public visibility.

In some rare situations, e.g. for experimental features or projects with licensing that is not compatible with Redox, a recipe may download sources located in a personal repository. Before using one of these recipes, please check with us on the [chat](./chat.md) to understand why the project is set up this way, and do not commit a Redox configuration file containing such a recipe without permission.
