# System Call Tracing

If you want to monitor what system calls are being made by a program, to investigate behavior, bugs or performance, there is a mechanism set up to do this.

You will learn how to configure the kernel to print a trace of system calls.

## Modifying the Kernel

You will be modifying the kernel, but you won't be making extensive changes, so you don't need to bother with GitLab stuff, unless you intend to do this frequently. This description assumes you will look after that yourself.

- The kernel source is in the directory `cookbook/recipes/core/kernel/source`
- If the directory is missing, go to your `redox` directory and run `make f.kernel`

Once you have fetched the kernel source into its "source" directory, you should disable the `[source]` section of the kernel recipe, so the build system doesn't try to update the kernel code.

- In the file `cookbook/recipes/core/kernel/source/recipe.toml`, comment out the lines in the source section:

```
# [source]
# git = "https://gitlab.redox-os.org/redox-os/kernel.git"
```

## feature "syscall_debug"

In order to configure printing out of system calls, you will need to enable the feature "syscall_debug" for the kernel.

- In the file `cookbook/recipes/core/kernel/source/Cargo.toml`, scroll down to the default features list (maybe around line 50), and add the feature "syscall_debug":

```
default = [
  "acpi",
  "multi_core",
  "graphical_debug",
  "serial_debug",
  "self_modifying",
  "x86_kvm_pv",
  "syscall_debug", <---- Like this
]
```

## Modify the "debug.rs" file

The file `src/syscall/debug.rs` contains the code to print out the system calls that match a particular set of conditions.

In the function `debug_start` (maybe around line 228), the boolean `do_debug` determines if the system calls should be printed.

It looks like this right now:

```
pub fn debug_start([a, b, c, d, e, f]: [usize; 6]) {
    let do_debug = if false && crate::context::current().read().name.contains("acpid") {
        if a == SYS_CLOCK_GETTIME || a == SYS_YIELD || a == SYS_FUTEX {
            false
        } else if (a == SYS_WRITE || a == SYS_FSYNC) && (b == 1 || b == 2) {
            false
        } else {
            true
        }
    } else {
        false
    };
```

Obviously, the condition `false && whatever` will evaluate to false, so remove the first bit (it's to prevent accidentally turning tracing on)

The program name is read from the context, and compared with the string you specify. The name from the context normally has the full path, so we just use the `contains({name})` test.

But if your program is called "ls" for example, you will get a system call trace for any program that contains the letters "ls", so you could try something like `ends_with("/ls")`.

You can modify the boolean expression however you want, assuming you are not publishing the code. You will need something a little fancier if you want messages for more than one program, for example.

If you want to hold onto the lock for the context a little longer, you will have to rework the expression a bit.

Next, there are some system calls that we skip because they are very frequent and not usually interesting. But if you want to get that level of detail, feel free to modify which system calls are filtered, `gettime`, `yield` and `futex` are typically ignored.

Also, writes to file descriptors 1 and 2 (stdout and stderr) are typically not reported so it doesn't interfere with output and debug code from your program as much.

A message will be printed at the start of the system call, and a message will be printed when the system call completes.

(A flag is set so the kernel knows to print the result.)

## Building The Changes

To include these changes in your Redox image, run the following command:

```
make r.kernel image
```

## Where Do The Messages Go

The kernel will print the messages on the console, if you are running `make qemu` the messages will appear in that terminal.

- Consider to run the following command to capture the output:

```
make qemu |& tee my_log.txt
```

If you are doing the testing on real hardware you should probably use the `server` variant and run commands from the console.
