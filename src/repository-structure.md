# Repository Structure

Redox GitLab consists of a large number of **Projects** and **Subprojects**. The difference between a Project and a Subproject is somewhat blurred in Redox GitLab, so we generally refer to the `redox` project as the main project and the others as subprojects. On the [Redox GitLab](https://gitlab.redox-os.org/) website, you will find the projects organized as a very large, flat alphabetical list. This is not indicative of the role or importance of the various projects.

## The Redox Project

The `redox` project is actually just the root of the build system. It does not contain any of the code that the final Redox image will include. It includes the Makefiles, configuration files, and a few scripts to simplify setup and building. The `redox` project can be found [here](https://gitlab.redox-os.org/redox-os/redox).

Doing a `git clone` of `redox.git` with `--recursive` fetches the full build system, as described in the `.gitmodules` file. The submodules are referred to using a SHA hash to identify what commit to use, so it's possible that your fetched subprojects do not have the latest from their `master` branch. Once the latest SHA reference is merged into `redox`, you can update to get the latest version of the subproject.

## Recipes

The many **recipes** that are added into the Redox image are built from the corresponding subprojects. The name of a Redox package almost always matches the name of its subproject, although this is not enforced.

The **recipe** contains the instructions to download and build a program, for its inclusion in the Redox image. The recipe is stored with the Cookbook.

## Cookbook

The `cookbook` subproject contains the mechanism for building the Redox recipes. If a recipe is modified, it is updated in the `cookbook` subproject. In order for the updated recipe to get included in your downloaded cookbook, the `redox` project needs to be updated with the new `cookbook` SHA commit hash. Connect with us on the [chat](./ch13-01-chat.md) if a recipe is not getting updated.

## Crates

Some subprojects are built as Rust crates, and included in Redox recipes using Cargo's dependency management system. Updates to a crate subproject must be pushed to the crate repository in order for it to be included in your build.

## Forks, Tarballs and Other Sources

Some recipes obtain their source code from places other than Redox GitLab. The Cookbook mechanism can pull in source from any Git repository URL. It can also obtain tarballs which is most used by C/C++ programs.

In some cases, the Redox GitLab has a fork of another repository, in order to add Redox-specific patches. Where possible, we try to push these changes upstream, but there are many reasons why this might not be feasible.

## Personal Forks

When you are contributing to Redox, you are expected to make your changes in a Personal Fork of the relevant project, then create a Merge Request (PR) to have your changes pulled from your fork into the master. Note that your personal fork is required to have public visibility.

In some rare situations, e.g. for experimental features or projects with licensing that is not compatible with Redox, a recipe may pull in sources located in a personal repository. Before using one of these recipes, please check with us on [Chat](./ch13-01-chat.md) to understand why the project is set up this way, and do not commit a Redox config file containing such a recipe without permission.
