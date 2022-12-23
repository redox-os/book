# Creating a Proper Pull Request

The steps given below are for the main Redox project - submodules and other projects may vary, though most of the approach is the same.


1. In an appropriate directory, e.g. `~/tryredox`, clone the Redox repository to your computer using one of the following commands:
  - HTTPS: 
  ```sh
  git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive
  ```
  - SSH: 
  ```sh
  git clone git@gitlab.redox-os.org:redox-os/redox.git --origin upstream --recursive
  ```
  - Use HTTPS if you don't know which one to use. (Recommended: learn about SSH if you don't want to have to login every time you push/pull!)
  - If you used `bootstrap.sh` (see [Building Redox](./ch02-05-building-redox.md)), this was done for you and you can skip this step.
2. Change to the newly created redox directory and rebase to ensure you're using the latest changes: 
  ```sh
  cd redox
  git rebase upstream master
  ```
3. Log into Redox Gitlab and fork the [Repository](https:/gitlab.redox-os.org/redox-os/redox). Look for the button in the upper right.
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
  git rebase upstream/master
  git submodule update --recursive --init
  ```
6. Create a separate branch:
  ```sh
  git checkout -b MY_BRANCH
  ```
7. Make your changes.
8. Commit:
  ```sh
  git add . --all
  git commit -m "COMMIT MESSAGE"
  ```
9.  Optionally run [rustfmt](https://github.com/rust-lang/rustfmt) on the files you changed and commit again if it did anything (check with `git diff` first).
10. Test your changes with `make qemu` or `make virtualbox`.
11. Pull from upstream:
  ```sh
  git fetch upstream
  git rebase upstream/master
  ```
  - Note: try not to use `git pull`, it is equivalent to doing `git fetch upstream; git merge master upstream/master`, which is not usually preferred for local/fork repositories, although it is fine in some cases.)
12. Repeat step 10 to make sure the rebase still builds and starts.
13. Push your changes to your fork:
  ```sh
  git push origin MY_BRANCH
  ```
14. On the [Redox Gitlab](https://gitlab.redox-os.org/), create a Merge Request, following the template. Describe your changes. **Submit!**
