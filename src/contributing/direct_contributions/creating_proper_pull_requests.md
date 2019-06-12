# Creating a Proper Pull Request

The steps given below are for the main Redox project - submodules and other projects may vary, though most of the approach is the same.


1. Clone the original repository to your local PC using one of the following commands based on the protocol you are using:
    * HTTPS: `git clone https://gitlab.redox-os.org/redox-os/redox.git --origin upstream --recursive`
    * SSH: `git clone git@gitlab.redox-os.org:redox-os/redox.git --origin upstream --recursive`
    * Use HTTPS if you don't know which one to use. (Recommended: learn about SSH if you don't want to have to login every time you push/pull!)
2. Then rebase to ensure you're using the latest changes: `git rebase upstream master`
3. Fork the repository
4. Add your fork to your list of git remotes with
    * HTTPS: `git remote add origin https://gitlab.redox-os.org/your-username/redox.git`
    * SSH: `git remote add origin git@gitlab.redox-os.org:your-username/redox.git`
5. Alternatively, if you already have a fork and copy of the repo, you can simply check to make sure you're up-to-date
    * Fetch the upstream:`git fetch upstream master`
    * Rebase with local commits:`git rebase upstream/master`
    * Update the submodules:`git submodule update --recursive --init`
6. Optionally create a separate branch (recommended if you're making multiple changes simultaneously) (`git checkout -b my-branch`)
7. Make changes
8. Commit (`git add . --all; git commit -m "my commit"`)
9. Optionally run [rustfmt](https://gitlab.redox-os.org/rust-lang-nursery/rustfmt) on the files you changed and commit again if it did anything (check with `git diff` first)
10. Test your changes with `make qemu` or `make virtualbox` (you might have to use `make qemu kvm=no`, formerly `make qemu_no_kvm`)
(see [Best Practices and Guidelines](./contributing/best_practices/overview.html))
11. Pull from upstream (`git fetch upstream; git rebase upstream/master`) (Note: try not to use `git pull`, it is equivalent to doing `git fetch upstream; git merge master upstream/master`, which is not usually preferred for local/fork repositories, although it is fine in some cases.)
12. Repeat step 9 to make sure the rebase still builds and starts
13. Push to your fork (`git push origin my-branch`)
14. Create a pull request, following the template
15. Describe your changes
16. Submit!
