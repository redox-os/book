# Shell
The [shell](http://linuxcommand.org/lts0010.php) used in Redox is ion.

When ion is called without "-c", it starts a main loop,
which can be found inside `Shell.execute()`.

```Rust
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

The documentation about `trim()` can be found [here](https://doc.rust-lang.org/std/primitive.str.html#method.trim).
If the command is not empty, the `on_command` method will be called.
Then, the shell will update variables, and reprint the prompt.




```Rust
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
```Rust
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
```Rust
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
