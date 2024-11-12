# Ion

Ion is a terminal shell and library for shells/command execution in Redox, it's used by default. Ion has it's own manual, which you can find on the [Ion Manual](https://doc.redox-os.org/ion-manual/).

## 1. The default shell in Redox

### What is a terminal shell?

A terminal shell is a layer around the operating system kernel and libraries, that allows users to interact with the operating system. That means a shell can be used on any operating system (Ion runs on both Linux and Redox) or implementation of a standard library as long as the provided API is the same. Shells can either be graphical (GUI) or command-line (CLI).

### Text shells

Text shells are programs that provide interactive user interface with an operating system. A shell reads from users as they type and performs operations according to the input. This is similar to read-eval-print loop (REPL) found in many programming languages (e.g. Python).

### Typical Unix shells

Probably the most famous shell is [GNU Bash](https://www.gnu.org/software/bash/), which can be found in the majority of Linux distributions, and also in MacOSX. On the other hand, FreeBSD uses **tcsh** by default.

There are many more shell implementations, but these two form the base of two fundamentally different sets:

- Bourne shell syntax (bash, sh, zsh)
- C shell syntax (csh, tcsh)

Of course these two groups are not exhaustive; it is worth mentioning at least the **fish** shell and **xonsh**. These shells are trying to abandon some features of old-school shell to make the language safer and more sane.

### Fancy features

Writing commands without any help from the shell would be very exhausting and impossible to use for everyday work. Therefore, most shells (including Ion of course!) include features such as command history, autocompletion based on history or man pages, shortcuts to speed-up typing, etc.

## 2. A scripting language

Ion can also be used to write simple scripts for common tasks or system configuration after startup. It is not meant as a fully-featured programming language, but more like a glue to connect other programs together.

### Relation to terminals

Early [terminals](https://en.wikipedia.org/wiki/Computer_terminal) were devices used to communicate with large computer systems like [IBM mainframes](https://en.wikipedia.org/wiki/IBM_mainframe). Nowadays Unix-like operating systems usually implement so called virtual terminals (tty stands for teletypewriter ... whoa!) and terminal emulators (e.g. xterm, gnome-terminal).

Terminals are used to read input from a keyboard and display textual output of the shell and other programs running inside it. This means that a terminal converts key strokes into control codes that are further used by the shell. The shell provides the user with a command line prompt (for instance: user name and working directory), line editing capabilities (Ctrl + a,e,u,k...), history, and the ability to run other programs (ls, uname, vim, etc.) according to user's input.  

TODO: In Linux we have device files like `/dev/tty`, how is this concept handled in Redox?

# Shell

When Ion is called without "-c", it starts a main loop, which can be found inside `Shell.execute()`.

```rust
        self.print_prompt();
        while let Some(command) = readln() {
            let command = command.trim();
            if !command.is_empty() {
                self.on_command(command, &commands);
            }
            self.update_variables();
            self.print_prompt();
        }
```

`self.print_prompt();` is used to print the shell prompt.

The `readln()` function is the input reader. The code can be found in `crates/ion/src/input_editor`.

The documentation about `trim()` can be found on the [libstd documentation](https://doc.rust-lang.org/std/primitive.str.html#method.trim).
If the command is not empty, the `on_command` method will be called.
Then, the shell will update variables, and reprint the prompt.

```rust
fn on_command(&mut self, command_string: &str, commands: &HashMap<&str, Command>) {
    self.history.add(command_string.to_string(), &self.variables);

    let mut pipelines = parse(command_string);

    // Execute commands
    for pipeline in pipelines.drain(..) {
        if self.flow_control.collecting_block {
            // TODO move this logic into "end" command
            if pipeline.jobs[0].command == "end" {
                self.flow_control.collecting_block = false;
                let block_jobs: Vec<Pipeline> = self.flow_control
                                               .current_block
                                               .pipelines
                                               .drain(..)
                                               .collect();
                match self.flow_control.current_statement.clone() {
                    Statement::For(ref var, ref vals) => {
                        let variable = var.clone();
                        let values = vals.clone();
                        for value in values {
                            self.variables.set_var(&variable, &value);
                            for pipeline in &block_jobs {
                                self.run_pipeline(&pipeline, commands);
                            }
                        }
                    },
                    Statement::Function(ref name, ref args) => {
                        self.functions.insert(name.clone(), Function { name: name.clone(), pipelines: block_jobs.clone(), args: args.clone() });
                    },
                    _ => {}
                }
                self.flow_control.current_statement = Statement::Default;
            } else {
                self.flow_control.current_block.pipelines.push(pipeline);
            }
        } else {
            if self.flow_control.skipping() && !is_flow_control_command(&pipeline.jobs[0].command) {
                continue;
            }
            self.run_pipeline(&pipeline, commands);
        }
    }
}
```

First, `on_command` adds the commands to the shell history with  `self.history.add(command_string.to_string(), &self.variables);`.

Then the script will be parsed. The parser code is in `crates/ion/src/peg.rs`.
The parse will return a set of pipelines, with each pipeline containing a set of jobs.
Each job represents a single command with its arguments.
You can take a look in `crates/ion/src/peg.rs`.

```rust
pub struct Pipeline {
    pub jobs: Vec<Job>,
    pub stdout: Option<Redirection>,
    pub stdin: Option<Redirection>,
}
pub struct Job {
    pub command: String,
    pub args: Vec<String>,
    pub background: bool,
}
```

What Happens Next:
* If the current block is a collecting block (a for loop or a function declaration) and the current command is ended, we close the block:
   * If the block is a for loop we run the loop.
   * If the block is a function declaration we push the function to the functions list.
* If the current block is a collecting block but the current command is not ended, we add the current command to the block.
* If the current block is not a collecting block, we simply execute the current command.

The code blocks are defined in `crates/ion/src/flow_control.rs`.
```Rust
pub struct CodeBlock {
    pub pipelines: Vec<Pipeline>,
}
```

The function code can be found in `crates/ion/src/functions.rs`.

The execution of pipeline content will be executed in `run_pipeline()`.

The Command class inside `crates/ion/src/main.rs` maps each command with a description and a method
to be executed.
For example:

```rust
commands.insert("cd",
                Command {
                    name: "cd",
                    help: "Change the current directory\n    cd <path>",
                    main: box |args: &[String], shell: &mut Shell| -> i32 {
                        shell.directory_stack.cd(args, &shell.variables)
                    },
                });
```

`cd` is described by  `"Change the current directory\n    cd <path>"`, and when called the method
`shell.directory_stack.cd(args, &shell.variables)` will be used. You can see its code in `crates/ion/src/directory_stack.rs`.

<!---
Sources:
http://hyperpolyglot.org/unix-shells
http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html
https://en.wikipedia.org/wiki/Shell_(computing)
http://unix.stackexchange.com/questions/4126/what-is-the-exact-difference-between-a-terminal-a-shell-a-tty-and-a-con
http://xonsh.org/
-->
