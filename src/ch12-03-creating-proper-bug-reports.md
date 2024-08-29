# Creating Proper Bug Reports

If you identify a problem with the system that has not been identified previously, please create a GitLab Issue. In general, we prefer that you are able to reproduce your problem with the latest build of the system. 

- Make sure the code you are seeing the issue with is up to date with `upstream/master`. This helps to weed out reports for bugs that have already been addressed.
- Search Redox Issues to see if a similar problem has been reported before. Then search outstanding merge requests to see if a fix is pending.
- Make sure the issue is reproducible (trigger it several times). Try to identify the minimum number of steps to reproduce it. If the issue happens inconsistently, it may still be worth filing a bug report for it, but indicate approximately how often the bug occurs.
- Explain if your problem happens in a virtual machine, real hardware or both. Also say your configuration (default options or customized), if you had the problem on real hardware say your computer model.
- If it is a significant problem, join us on [Chat](./ch13-01-chat.md) and ask if it is a known problem, or if someone plans to address it in the short term.
- Identify the recipe that is causing the issue. If a particular command is the source of the problem, look for a repository on Redox GitLab with the same name. Or, for certain programs such as `games` or command line utilities, you can search for the package containing the command with `grep -rnw COMMAND --include Cargo.toml`, where `COMMAND` is the name of the command causing the problem. The location of the `Cargo.toml` file can help indicate which recipe contains the command. This is where you should expect to report the issue.
- If the problem involves multiple recipes, kernel interactions with other programs, or general build problems, then you should plan to log the issue against the `redox` repository.
- If the problem occurs during build, record the build log using `script` or `tee`, e.g.

```sh
make r.recipe-name 2>&1 | tee recipe-name.log
```

If the problem occurs while using the Redox command line, use `script` in combination with your Terminal window.

```sh
tee qemu.log
```

```sh
make qemu
```

- Wait for Redox to start, then in this window:

```
redox login: user
```

- Execute the commands to demonstrate the bug
- Terminate QEMU

```sh
sudo shutdown
```

- If shutdown does not work (there are known bugs) then
- Use the QEMU menu to quit
- Then exit the shell created by script

```sh
exit
```

- Join us in the chat.

- Record build information like:

     - The rust toolchain you used to build Redox
       - `rustc -V` and/or `rustup show` from your Redox project folder
     - The commit hash of the code you used
       - `git rev-parse HEAD`
     - The environment you are running Redox in (the "target")
       - `qemu-system-x86_64 -version` or your current hardware configuration, if applicable
     - The operating system you used to build Redox
       - `uname -a` or an alternative format

- Format your log on the message in Markdown syntax to avoid a flood on the chat, you can see how to do it [here](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#quoting-code).

- Make sure that your bug doesn't already have an issue on GitLab. Feel free to ask in the Redox [Chat](./ch13-01-chat.md) if you're uncertain as to whether your issue is new.

- Create a GitLab issue following the template. Non-bug report issues may ignore this template.

- Once you create the issue don't forget to post the link on the Dev or Support rooms of the chat, because the GitLab email notifications have distractions (service messages or spam) and most developers don't left their GitLab pages open to receive desktop notifications from the web browser (which require a custom setting to receive issue notifications).

By doing this you help us to pay attention to your issues and avoid them to be accidentally forgotten.

- Watch the issue and be available for questions.
