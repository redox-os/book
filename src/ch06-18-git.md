# Git Guidelines

* Commit messages should describe their changes in present-tense, e.g. "`Add stuff to file.ext`" instead of "`added stuff to file.ext`".
* Try to remove useless duplicate/merge commits from PRs as these clutter up history, and may make it hard to read.
* Usually, when syncing your local copy with the master branch, you will want to rebase instead of merge. This is because it will create duplicate commits that don't actually do anything when merged into the master branch.
* When you start to make changes, you will want to create a separate branch, and keep the `master` branch of your fork identical to the main repository, so that you can compare your changes with the main branch and test out a more stable build if you need to.
* You should have a fork of the repository on GitLab and a local copy on your computer. The local copy should have two remotes; `upstream` and `origin`, `upstream` should be set to the main repository and `origin` should be your fork.
