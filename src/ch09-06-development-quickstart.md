# Development Quickstart

This page contains advanced information for development on the build system submodules and recipes, while the [Coding and Building] page is guided by examples.

Build system components use submodules while system components use recipes, thus you have two development workflows:

```sh
cd submodule-name
cd cookbook/recipes/some-category/recipe-name/source
```

(Be aware of [pinned commits](./ch08-06-build-system-reference.md#pinned-commits))

You should have a fork of the repositories on GitLab and a local copy on your computer. The local copy should have two remotes; `upstream` and `origin`, `upstream` should be set to the main repository and `origin` should be your fork. Log into Redox Gitlab and fork the repository that you want - look for the button in the upper right.

If you are developing in a submodule you should fork the `redox` repository, if you are developing in a recipe you should fork the repository on the `git` data type at `recipe.toml`

- Add your fork to your list of git remotes with:

  - HTTPS:

    ```sh
    git remote add origin https://gitlab.redox-os.org/MY_USERNAME/your-repository.git
    ```

  - SSH:

    ```sh
    git remote add origin git@gitlab.redox-os.org:MY_USERNAME/your-repository.git
    ```

  - Note: If you made an error in your `git remote` command, use `git remote remove origin` and try again.

- Alternatively, if you already have a fork and copy of the repository, you can simply check to make sure you're up-to-date. Fetch the upstream, rebase with local commits, and update the submodules:

    ```sh
    git fetch upstream master

    ```

    ```sh
    git rebase upstream/master
    ```

    ```sh
    git submodule update --recursive --init
    ```

    - Usually, when syncing your local copy with the master branch, you will want to rebase instead of merge. This is because it will create duplicate commits that don't actually do anything when merged into the master branch.

- Before you start to make changes, you will want to create a separate branch, and keep the `master` branch of your fork identical to the main repository, so that you can compare your changes with the main branch and test out a more stable build if you need to. Create a separate branch:

    ```sh
    git checkout -b MY_BRANCH
    ```

- Make your changes and test them.
- Commit:

    ```sh
    git add . --all
    ```

    ```sh
    git commit -m "COMMIT MESSAGE"
    ```

    - Commit messages should describe their changes in present-tense, e.g. "`Add stuff to file.ext`" instead of "`added stuff to file.ext`".
    - Try to remove duplicate/merge commits from PRs as these clutter up history, and may make it hard to read.

- Optionally run [rustfmt](https://github.com/rust-lang/rustfmt) on the files you changed and commit again if it did anything (check with `git diff` first).
- Test your changes with `make qemu` or `make virtualbox`.
- Pull from upstream:

    ```sh
    git fetch upstream
    ```

    ```sh
    git rebase upstream/master
    ```

  - Note: try not to use `git pull`, it is equivalent to doing `git fetch upstream; git merge master upstream/master`.
  
- Test your changes with `make qemu` or `make virtualbox` to make sure the rebase still builds and starts.
- Push your changes to your fork:

    ```sh
    git push origin MY_BRANCH
    ```
