# Creating Proper Bug Reports

If you identify a problem with the system that has not been identified previously, please create a GitLab Issue. In general, we prefer that you are able to reproduce your problem with the latest build of the system. 

1. Make sure the code you are seeing the issue with is up to date with `upstream/master`. This helps to weed out reports for bugs that have already been addressed.

2. Search Redox Issues to see if a similar problem has been reported before. Then search outstanding merge requests to see if a fix is pending.

3. Make sure the issue is reproducible (trigger it several times). Try to identify the minimum number of steps to reproduce it. If the issue happens inconsistently, it may still be worth filing a bug report for it, but indicate approximately how often the bug occurs.

4. If it is a significant problem, join us on [Chat] and ask if it is a known problem, or if someone plans to address it in the short term.

5. Identify the Redox package that is causing the issue. If a particular command is the source of the problem, look for a repo on Redox GitLab with the same name. Or, for certain programs such as games or command line utilities, you can search for the package containing the command with `grep -rnw COMMAND --include Cargo.toml`, where `COMMAND` is the name of the command causing the problem. The location of the `Cargo.toml` file can help indicate which Redox package contains the command. This is where you should expect to report the issue.

6. If the problem involves multiple packages, kernel interactions with other programs, or general build problems, then you should plan to log the issue against the `redox` repository.

7. If the problem occurs during build, record the build log using `script` or `tee`, e.g.
    ```sh
    make r.games | tee build.log
    ```
    If the problem occurs while using the Redox command line, use `script` in combination with your Terminal window.
    ```sh
    script qemu.log
    make qemu
    # wait for Redox to start, then in this window,
    redox login: user
    # execute the commands to demonstrate the bug
    # terminate qemu
    sudo shutdown
    # if shutdown does not work (there are known bugs) then
    # use the QEMU menu to quit
    # then exit the shell created by script
    exit
    ```

8. Join us in the chat 

9. Record build information like:
     - The rust toolchain you used to build Redox
       - `rustc -V` and/or `rustup show` from your Redox project folder
     - The commit hash of the code you used
       - `git rev-parse HEAD`
     - The environment you are running Redox in (the "target")
       - `qemu-system-x86_64 -version` or your actual hardware specs, if applicable
     - The operating system you used to build Redox
       - `uname -a` or an alternative format

10. Make sure that your bug doesn't already have an issue on GitLab. Feel free to ask in the Redox [Chat] if you're uncertain as to whether your issue is new

11. Create a GitLab issue following the template. Non-bug report issues may ignore this template

12. Watch the issue and be available for questions

[Chat]: ./ch13-01-chat.md