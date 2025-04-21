# Creating Proper Pull Requests

In order for changes you have made to be added to Redox, or other related projects, it is necessary to have someone review your changes, and merge them into the official repository.

This is done by preparing a feature branch, and submitting a merge request.

For small changes, it is sufficient to just submit a pull request. For larger changes, which may require planning or more extensive review, it is better to start by creating an [issue](./filing-issues.md). This provides a shared reference for proposed changes, and a place to collect discussion and feedback related to it.

The steps given below are for the main Redox project repository - submodules and other projects may vary, though most of the approach is the same.

### Please note:
  - **Once you have marked your MR as ready, don't add new commits.**
  - **If you need to add new commits mark the MR as draft again.**

## Preparing your branch

1. In an appropriate directory, e.g. `~/tryredox`, clone the Redox repository to your computer using one of the following commands:
  - HTTPS:

    ```sh
    git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive
    ```

  - SSH:

    ```sh
    git clone git@gitlab.redox-os.org:redox-os/redox.git --origin upstream --recursive
    ```

  - Use HTTPS if you don't know which one to use. (Recommended: learn about [SSH](./signing-in-to-gitlab.md#using-ssh-for-your-repo) if you don't want to have to login every time you push/pull!)
  - If you used `bootstrap.sh` (see the [Building Redox](./podman-build.md) page), the `git clone` was done for you and you can skip this step.
2. Change to the newly created redox directory and rebase to ensure you're using the latest changes:

    ```sh
    cd redox
    ```

    ```sh
    git rebase upstream master
    ```
3. You should have a fork of the repository on GitLab and a local copy on your computer. The local copy should have two remotes; `upstream` and `origin`, `upstream` should be set to the main repository and `origin` should be your fork. Log into Redox Gitlab and fork the [Repository](https://gitlab.redox-os.org/redox-os/redox) - look for the button in the upper right.
4. Add your fork to your list of git remotes with
  - HTTPS:

    ```sh
    git remote add origin https://gitlab.redox-os.org/MY_USERNAME/redox.git
    ```

  - SSH:

    ```sh
    git remote add origin git@gitlab.redox-os.org:MY_USERNAME/redox.git
    ```

  - Note: If you made an error in your `git remote` command, use `git remote remove origin` and try again.
5. Alternatively, if you already have a fork and copy of the repo, you can simply check to make sure you're up-to-date. Fetch the upstream, rebase with local commits, and update the submodules:

    ```sh
    git fetch upstream master
    ```

    ```sh
    git rebase upstream/master
    ```

    ```sh
    git submodule update --recursive --init
    ```

    Usually, when syncing your local copy with the master branch, you will want to rebase instead of merge. This is because it will create duplicate commits that don't actually do anything when merged into the master branch.
6. Before you start to make changes, you will want to create a separate branch, and keep the `master` branch of your fork identical to the main repository, so that you can compare your changes with the main branch and test out a more stable build if you need to. Create a separate branch:

    ```sh
    git checkout -b MY_BRANCH
    ```

7. Make your changes and test them.
8. Commit:

    ```sh
    git add . --all
    ```

    ```sh
    git commit -m "COMMIT MESSAGE"
    ```

    Commit messages should describe their changes in present-tense, e.g. "`Add stuff to file.ext`" instead of "`added stuff to file.ext`".
    Try to remove duplicate/merge commits from PRs as these clutter up history, and may make it hard to read.
9.  Optionally run [rustfmt](https://github.com/rust-lang/rustfmt) on the files you changed and commit again if it did anything (check with `git diff` first).
10. Test your changes with `make qemu` or `make virtualbox`.
11. Pull from upstream:

    ```sh
    git fetch upstream
    ```

    ```sh
    git rebase upstream/master
    ```

  - Note: try not to use `git pull`, it is equivalent to doing `git fetch upstream; git merge master upstream/master`.
12. Repeat step 10 to make sure the rebase still builds and starts.
13. Push your changes to your fork:

    ```sh
    git push origin MY_BRANCH
    ```

## Submitting a merge request

1. On [Redox GitLab](https://gitlab.redox-os.org/), create a Merge Request, following the template. Explain your changes in the title in an easy way and write a short statement in the description if you did multiple changes. **Submit!**
2. Once your merge request is ready, notify reviewers by sending the link to the [Redox Merge Requests](https://matrix.to/#/#redox-mrs:matrix.org) room.

## Incorporating feedback

Sometimes a reviewer will request modifications. If changes are required:

1. Reply or add a thread to the original merge request notification in the [Redox Merge Requests](https://matrix.to/#/#redox-mrs:matrix.org) room indicating that you intend to make additional changes.

   **Note**: It's best to avoid making large changes or additions to a merge request branch, but if necessary, please indicate in chat that you will be making significant changes.
2. Mark the merge request as "Draft" before pushing any changes to the branch being reviewed.
3. Make any necessary changes.
4. Reply on the same thread in the [Redox Merge Requests](https://matrix.to/#/#redox-mrs:matrix.org) room that your merge request is now ready.
5. Mark the merge request as "Ready"

This process communicates that the branch may be changing, and prevents reviewers from expending time and effort reviewing changes that are still in progress.


## Using GitLab web interface

1. Open the repository that you want and click in "Web IDE".
1. Make your changes on repository files and click on "Source Control" button on the left side.
1. Name your commits and apply them to specific branches (each new branch will be based on the current master branch, that way you don't need to create forks and update them, just send the proper commits to the proper branches, it's recommended that each new branch is a different change, more easy to review and merge).
1. After the new branch creation a pop-up window will appear suggesting to create a MR, if you are ready, click on the "Create MR" button.
1. If you want to make more changes, finish them, return to the repository page and click on the "Branches" link.
1. Each branch will have a "Create merge request" button, click on the branches that you want to merge.
1. Name your MR and create (you can squash your commits after merge to not flood the upstream with commits)
1. If your merge request is ready, send the link on [Redox Merge Requests](https://matrix.to/#/#redox-mrs:matrix.org) room.

- Remember that if you use forks on GitLab web interface you will need to update your forks manually in web interface (delete the fork/create a new fork if the upstream repository push commits from other contributors, if you don't do this, there's a chance that your merged commits will come in the next MR).
