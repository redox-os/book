# Troubleshooting Podman

If enabled, the Podman environment is set up. [Podman](./ch02-06-podman-build.md) is recommended for distros other than Pop!_OS/Ubuntu/Debian.

If your build appears to be missing libraries, have a look at [Debugging your Podman Build Process](./ch02-06-podman-build.md#debugging-your-build-process).
If your Podman environment becomes broken, you can use `podman system reset` and `rm -rf build/podman`. In some cases, you may need to do `sudo rm -rf build/podman`.

If you had problems setting Podman to rootless mode, use these commands:

(This commands were taken from the official [Podman rootless wiki], then it could be broken/wrong in the future, read the wiki before to see if the commands match, I will try to update the method to work with everyone)

- Install Podman on your distribution
- `podman ps -a` - this command will show all your Podman containers, if you want to remove all of them, run `podman system reset`.
- Make this [step] if necessary (if the Podman of your distribution use cgroup V2), you will need to edit the `containers.conf` file on `/etc/containers` or your user folder at `~/.config/containers`, change the line `runtime = "runc"` to `runtime = "crun"`.
- Execute `cat /etc/subuid` and `cat /etc/subgid` to see your user/group IDs (UIDs/GIDs) on system.

You can use the values `100000-165535` for your user, just edit the two text files, I recommend `sudo nano /etc/subuid` and `sudo nano /etc/subgid`, when you finish, press Ctrl+X to save the changes.

If you don't want to edit the file, you can use this command:

`usermod --add-subuids 100000-165535 --add-subgids 100000-165535 yourusername`

- After the change on the UID/GID values, execute the command `podman system migrate`.
- If you have a network problem on the container, execute the command:

`sudo sysctl net.ipv4.ip_unprivileged_port_start=443` - This command will allow port connection without root.

- Done, you can have a working Podman build now (if you still have problems with Podman, check the [Troubleshooting](./ch08-05-troubleshooting.md) chapter or call us on the [Redox Support] room)

- If you want to use the tool `ping` on the containers, execute this command:

`sudo sysctl -w "net.ipv4.ping_group_range=0 $MAX_GID"`

[Podman rootless wiki]: https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md
[step]: https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md#cgroup-v2-support
[Redox Support]: https://matrix.to/#/#redox-support:matrix.org
