# Syntax

```
# Simple hello world example:
echo Hello world! # End of line comments are ignored

# `echo` is a command that allows you to print something in the stdout.
# Each command starts on a new line, or after semicolon:
echo 'This is the first line'; echo 'This is the second line'

# Declaring a variable looks like this:
let identifier = "Some string"

# Note that spaces between the identifier and value are optional:
let identifier="Some string"

# Using the variable:
echo $identifier    # stdout: `Some string`
echo b$identifier   # stdout: `bSome string`
echo $identifiere   # an empty string will be printed
                    # as no value can be found for $identifiere
                    # note that this does not count as an error ($?=0)
echo "$identifier"  # stdout: `Some string`
echo '$identifier'  # stdout: `Some string`
# When you use the variable itself
# If you want to use the variable's value, you should use $.
# Note that ' (single quote) won't expand the variables!
echo identifier # stdout: `identifier`

# the dollar sign `$` can be escaped with a backslash `\` to echo $identifier:
echo \$identifier #stdout: `$identifier`

# You can also remove a variable:
drop $foo # no value will be available anymore for the identifier `$foo`

# All variables can be listed as follows:
let

# Parameter expansion ${ }:
echo ${Variable}
# This is useful when you for example
# you want to have a character right after your variable:
let Name=John; echo Hello, ${Name}! # stdout: `Hello, John!`

# Bracket expansion:
echo h{i,aa,ooo} # stdout: `hi, haa, hooo`
echo n{i,u,o}l # stdout: `nil nul nol`
# Note that spaces in between the commas (`,`) and brackets (`{`, `}`)
# aren't allowed and will make the expansion not work:
echo n{i, u}l # stdout: `n{i, u}l`

# Builtin variables:
# There are some useful builtin variables, like
echo "Last program's return value: $?"
echo "The Shell Prompt: $PROMPT"
echo "Username controlling the current shell environment: $USER"
echo "The current working directory: $PWD" # also available as command pwd
echo "The previous working directory: $OLDPWD"
echo "The the maximum size of the internal history buffer: $HISTORY_SIZE"
echo "The maximum amount of commands to retain in the log: $HISTORY_FILE_SIZE"
echo "Path of the log file: $HISTORY_FILE"

# Now that we know how to echo and use variables,
# let's learn some of the other basics of Ion!

# Our current directory is available through the command `pwd`.
# `pwd` stands for "print working directory".
# We can also use the builtin variable `$PWD`.
# Observe that the following are equivalent:
echo "I'm in $PWD" # interpolates the variable
echo "I'm in $(pwd)" # execs `pwd` and interpolates output

# If you get too much output in your terminal, or from a script, the command
# `clear` clears your screen
clear
# Ctrl-L also works for clearing output

# Reading a value from input:
echo "What's your name?"
read Name # Note that we didn't need to declare a new variable
echo Hello, ${Name}!

# We have the usual if structure:
# use 'man test' for more info about conditionals
if $Name != $USER
    echo "Your name isn't your username"
else
    echo "Your name is your username"
end

# NOTE: if $Name is empty, ion sees the above condition as:
if "" != $USER # ...
# which works as expected

# Unlike other programming languages, Ion is a shell so it works in the context
# of a current directory. You can list files and directories in the current
# directory with the ls command:
ls

# These commands have options that control their execution:
ls -l # Lists every file and directory on a separate line

# Results of the previous command can be passed to the next command as input.
# grep command filters the input with provided patterns. That's how we can list
# rust source files in the src directory:
ls -l src | grep "\.rs"

# Use `cat` to print files to stdout:
cat src/main.rs

# Use `cp` to copy files or directories from one place to another.
# `cp` creates NEW versions of the sources,
# so editing the copy won't affect the original (and vice versa).
# Note that it will overwrite the destination if it already exists.
cp srcFile.txt clone.txt
cp -r srcDirectory/ dst/ # recursively copy

# Use `mv` to move files or directories from one place to another.
# `mv` is similar to `cp`, but it deletes the source.
# `mv` is also useful for renaming files!
mv s0urc3.txt dst.txt # sorry, l33t hackers...

# Since Ion works in the context of a current directory, you might want to
# run your command in some other directory. We have cd for changing location:
cd ~    # change to home directory, also available as `$HOME`
cd ..   # go up one directory
        # (^^say, from /home/username/Downloads to /home/username)
cd /home/username/Documents   # change to specified directory
cd ~/Documents/..    # still in home directory...isn't it??

# Use `mkdir` to create new directories.
mkdir myNewDir

# You can redirect output of a command to a file
echo "Hello" > hello.txt # will overwrite file if already exists
echo "Another line" >> hello.txt # will append to an existing file,
                                 # this command will fail if the file does not exist yet

# You can use a file as input for a command
cat < hello.txt

# Last redirection example:
cat < foo > bar
# will write the contents of a file named "foo" to a file named "bar"

# for loops iterate for as many arguments given:
for i in 1 2 3 4 5
  echo $i
end

# You can also define functions

# a function with no parameters
fn ask_name_and_say_hello
  read name
  echo "Hello, ${name}!"
end

# a function with parameters
fn test a b c
  echo $a
  echo $b
  echo $c
end

# Calling your functions
ask_name_and_say_hello
test hello world goodbye
# not passing the correct amount of parameters will result in an error ($?=127)

# Read Ion shell builtins documentation with the Ion 'help' builtin command:
help        # displays available builtin commands
help cd     # displays help information available for builtin cd command
```
