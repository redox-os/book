# Branch-based workflow

One of the most important things beyond technical advantage is flexibility of the build system and easy development.

That's why we choose a branch-based workflow instead of a fork-based workflow, the developer will commit his changes in a upstream branch instead of a forked repository.

Why? because it's simple and less time consuming (less steps/commands), if you use a branch-based workflow you just need to create your branch, run `git checkout your-branch-name` on your working folder, commit to it and send a Merge Request when your branch is done, simple like that.

While in a fork-based workflow, you need to fork the repository separated (require configuration changes to the new forks), update the `master` branch of the fork frequently (`git pull` and it's not possible on the GitLab web interface, you need to delete your fork and create a new one to update), create your branch, commit to it and send a Merge Request.

It takes less space too, because you don't need to maintain two forks of the same repository (the local fork and the GitLab fork).

## Redox programs

Redox programs development inside recipe folders is the most improved task by this workflow, because in a fork-based workflow you need to delete the `source` folder or change the `git =` and `branch =` fields on your `recipe.toml`.

How easy is the Redox program development in a branch-based workflow? after your `make pull && make rebuild`, go to the `source` folder of your recipe - `cd cookbook/recipes/your-recipe/source`, run - `git checkout your-branch`, and commit your changes, just that.

When your changes are ready, run `make c.your-recipe && make r.your-recipe && make image` to test your changes (if you have this recipe added to your TOML config, `desktop.toml` for example).

How it is done in a fork-based workflow? you have two ways to do this:

1 - The most easy way is to delete the `source` folder of your recipe, fork your repository on this folder (`git clone`), commit your changes to `master` or your branch.

To test your changes, run - `make c.your-recipe && make r.your-recipe && make image`.

It seems similar to a branch-based workflow, but you need to delete the `source` folder, fork your GitLab repository and update it separated from the build system, you can easily forget to update it and lost recent improvements/bug fixes on the upstream source code.

2 - The time consuming/error-prone way, you change the `git =` and `branch =` fields of your `recipe.toml` to fetch your fork link, delete the `source` folder and run `make c.your-recipe && make r.your-recipe && make image`.

You can bypass these steps if you run - `scrips/rebuild-recipe.sh your-recipe`, it will delete the `source` and `target` folders for you, but it don't run `make image` (you can't use this script on the method 1).

## Recipes

You can create your recipe folder/configuration on separated branches, to active your branch from Cookbook, run:

- `cd cookbook && git checkout your-branch && cd ..`

This command will access the Cookbook folder, change the active branch and go back to your working Redox directory.

To update your Cookbook branches, run - `git pull` on your Cookbook folder (`cd cookbook && git pull && cd ..`).

## Local Changes

Sometimes you don't want to submit stuff to Redox GitLab and just test offline, for that purpose you can use a fork-based approach following the steps described on method 1 of "Redox programs" section or edit the files directly without commits.

To avoid unwanted changes caused by the `make rebuild` command, you can remove the `[source]`, `git =` and `tar =` fields from the `recipe.toml` (a `source` folder must exist to avoid error).