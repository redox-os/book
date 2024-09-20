# Continuous Integration

The [continuous integration](https://en.wikipedia.org/wiki/Continuous_integration) helps developers to automated the program testing as the code evolves, it detects broken things or regressions.

The developer add a configuration file on the Git repository root with the commands to test the things.

Most known as "CI", it's provided by a Git service (like GitHub and GitLab) in most cases.

In Redox we use the [Redoxer](https://gitlab.redox-os.org/redox-os/redoxer) program to setup our GitLab CI configuration file, it downloads our toolchain, build the program to the Redox target using Cargo and run the program inside a Redox virtual machine.

## Configure Your Repository

To setup your CI runner with Redoxer you need to add these commands to your CI configuration file:

- Install Redoxer

```sh
cargo install redoxer
```

- Install the Redox toolchain on Redoxer

```sh
redoxer toolchain
```

- Build your program or library to Redox

```sh
redoxer build
```

You need to customize Redoxer for your needs (test types of your CI jobs)
