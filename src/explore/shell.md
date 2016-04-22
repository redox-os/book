# Shell
ion is the [shell](http://linuxcommand.org/lts0010.php) used in redox. 

when the shell is call without "-c", it start a main loop
which can be found inside `Shell.execute()`

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

the `readln()` is a the input reader which code can be found in `crates/ion/src/input_editor`

The documentation about trim can be found [here](https://doc.rust-lang.org/std/primitive.str.html#method.trim).
if the commands is not empty, the method `on_command` will be called. this method will be developed later.
then the shell will update variables, and reprint the prompt.




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
the first thing the `on_command` does it to add the commands into the history with  `self.history.add(command_string.to_string(), &self.variables);`.

Then the script will be parse. the parser code is in `crates/ion/src/peg.rs`
the parse will return a set of pipelines, each pipeline contains a set of jobs.
Each job represents a single command with its arguments.
you can take a look in `crates/ion/src/peg.rs`
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
what will happen after is in brief :
* if the current block is a collecting block (a for loop or a function declaration) and the current command is end, we close the block:
   *  if the block is a for loop we run the loop
   * if the block is a function declaration we push the function to the functions list
* If the current block is a collecting block but the current command is not end, we add the current command to the block.
* If the current block is not a collecting block, we simply execute the current command.

the code blocks are defined in `crates/ion/src/flow_control.rs`
```Rust
pub struct CodeBlock {
    pub pipelines: Vec<Pipeline>,
}
```
the function code is defined in `crates/ion/src/functions.rs`

the execution of pipeline content will be executer in `run_pipeline()`

the Command class inside `crates/ion/src/main.rs` maps each command with an description and a method
to be executed. for example :
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
`shell.directory_stack.cd(args, &shell.variables)` will be used. you can see its code in `crates/ion/src/directory_stack.rs`
