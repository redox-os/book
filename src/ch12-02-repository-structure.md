# Repository Structure

Redox GitLab consists of a large number of **Projects** and **Subprojects**. The difference between a Project and a Subproject is somewhat blurred in Redox GitLab, so we generally refer to the `redox` project as the main project and the others as subprojects. On the [Redox GitLab](https://gitlab.redox-os.org/) website, you will find the projects organized as a very large, flat alphabetical list. This is not indicative of the role or importance of the various projects.

## The Redox Project

The `redox` project is actually just the root of the build system. It does not contain any of the code that the final Redox image will include. It includes the Makefiles, configuration files, and a few scripts to simplify setup and building. The `redox` project can be found on or about [page 9](https://gitlab.redox-os.org/redox-os?page=9), or by appending the name [redox](https://gitlab.redox-os.org/redox-os/redox) to the GitLab path.

Doing a `git clone` of `redox.git` with `--recursive` fetches the full build system, as described in the `.gitmodules` file. The submodules are referred to using an SHA to identify what commit to use, so it's possible that your fetched subprojects do not have the latest from their `master` branch. Once the latest SHA reference is merged into `redox`, you can update to get the latest version of the subproject.

## Packages and Recipes

The many **packages** that are assembled into the Redox image are built from the corresponding subprojects. The name of a Redox package almost always matches the name of its subproject, although this is not enforced.

The **recipe** for a Redox package contains the instructions to fetch and build the package, for its inclusion in the Redox image. The recipe is stored with the [Cookbook](#cookbook), not with with package.

## Cookbook

The `cookbook` subproject contains the mechanism for building the Redox packages. **It also contains the recipes**. If a recipe is modified, it is updated in the `cookbook` subproject. In order for the updated recipe to get included in your fetched cookbook, the `redox` project needs to be updated with the new `cookbook` SHA. Connect with us on [Chat](./ch13-01-chat.md) if a recipe is not getting updated.

## Crates

Some subprojects are built as Crates, and included in Redox packages using Cargo's package management system. Updates to a crate subproject must be pushed to the crate repository in order for it to be included in your build.

## Forks, Tarballs and Other Sources

Some recipes obtain source code from places other than Redox GitLab. The cookbook mechanism can pull in source from any git URL. It can also obtain source tarballs, as is frequently the case for non-Rust applications.

In some cases, the Redox GitLab has a fork of another repository, in order to add Redox-specific patches. Where possible, we try to push these changes upstream, but there are many reasons why this might not be feasible.

## Personal Forks

When you are contributing to Redox, you are expected to make your changes in a Personal Fork of the relevant project, then create a Merge Request (PR) to have your changes pulled from your fork into the master. Note that your personal fork is required to have public visibility.

In some rare situations, e.g. for experimental features or projects with licensing that is not compatible with Redox, a recipe may pull in sources located in a personal repository. Before using one of these recipes, please check with us on [Chat](./ch13-01-chat.md) to understand why the project is set up this way, and do not commit a Redox config file containing such a recipe without permission.
