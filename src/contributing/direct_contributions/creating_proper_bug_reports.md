# Creating a Proper Bug Report

1. Make sure the code you are seeing the issue with is up to date with `upstream/master`. This helps to weed out reports for bugs that have already been addressed.
2. Make sure the issue is reproducible (trigger it several times). If the issue happens inconsistently, it may still be worth filing a bug report for it, but indicate approximately how often the bug occurs
3. Record build information like:
  * The rust toolchain you used to build Redox
    * `rustc -V` and/or `rustup show` from your Redox project folder
  * The commit hash of the code you used
    * `git rev-parse HEAD`
  * The environment you are running Redox in (the "target")
    * `qemu-i386 -version` or your actual hardware specs, if applicable
  * The operating system you used to build Redox
    * `uname -a` or an alternative format
4. Make sure that your bug doesn't already have an issue on Github. If you submit a duplicate, you should accept that you may be ridiculed for it, though you'll still be helped. Feel free to ask in the Redox [chat](./contributing/communication/chat.html) if you're uncertain as to whether your issue is new
5. Create a Github issue following the template
    * Non-bug report issues may ignore this template
6. Watch the issue and be available for questions
7. Success!

With the help of fellow Redoxers, legitimate bugs can be kept to a low simmer, not a boil.
