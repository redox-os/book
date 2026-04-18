# Testing

- [Manual Test Suite Execution](#manual-test-suite-execution)
- [Test Images](#test-images)

- It's always better to test boot every time you make a system change, because it is important to see how the OS boots and works after it compiles.

- Even though Rust is a safety-oriented language, something as unstable and low-level as a work-in-progress operating system will almost certainly have problems in many cases and may completely break on even the slightest critical change.

- Also, make sure you verified how the unmodified version runs on your machine before making any changes. Else, you won't have anything to compare to, and it will generally just lead to confusion. TLDR: rebuild and test boot often.

- The real hardware testing is bigger than QEMU testing and thus detect more bugs.

- The test suites can be executed in an automated way by running the `make rp.auto-test,--with-package-deps qemu` command from the build system and running the `auto-test` command inside of Redox (testing on real hardware is more rich and thus can have different results compared to QEMU).

## Manual Test Suite Execution

### acid

[acid](https://gitlab.redox-os.org/redox-os/acid) is the smallest test suite on Redox (quickest way to test), to use it run the following commands:

- Install the `acid` source to the Redox image, launch QEMU and go to `acid` directory

```
make rp.acid qemu
```

```
cd acid
```

- Run correctness tests

```
cargo test
```

Or a single test:

```
cargo test test-name
```

- Run stress tests

```
cargo bench
```

Or a single test:

```
cargo bench benchmark-name
```

Or if you don't want to install Cargo:

- Install the `acid` binary to the Redox image and launch QEMU

```
make crp.acid-bins qemu
```

- Run some test

```
acid test-name
```

### relibc-tests

[relibc-tests](https://gitlab.redox-os.org/redox-os/relibc/-/tree/master/tests) is the second most rich test suite in Redox and is used to complement the `acid` test suite (test faster than the `os-test` test suite), to use it run the following commands:

- Install the `relibc-tests` binaries to the Redox image, launch QEMU and go to `relibc-tests` directory

```
make rp.relibc-tests-bins qemu
```

```
cd /usr/share/relibc-tests
```

- Run all tests

```
TODO
```

Or a single test:

```
TODO
```

Or if you also want to build from source for more testing:

- Install the `relibc-tests` binaries to the Redox image, launch QEMU and go to `relibc-tests` directory

```
make rp.relibc-tests qemu
```

```
relibc-tests/check.sh --host --test
```

Or a single test:

```
relibc-tests/check.sh --host --test=test-dir/test-name
```

### os-test

The [os-test](https://sortix.org/os-test/) test suite has the largest number of tests and is the recommended method to test the system (but take more time to test), to use it run the following commands:

- Install the `os-test` binaries to the Redox image, launch QEMU and go to `os-test` directory

```
make crp.os-test-bins qemu
```

```
cd /usr/share/os-test
```

```
make test
```

Or to run a single suite:

```
cd /usr/share/os-test/suite-name
```

```
make test
```

Or if you also want to build from source for more testing:

- Install the `os-test` sources to the Redox image, launch QEMU and go to `os-test` directory

```
make rp.os-test qemu
```

```
cd /home/user/os-test
```

```
make all
```

```
make test
```

Or to run a single suite:

```
cd /usr/share/os-test/suite-name
```

```
make all
```

```
make test
```

## Test Images

There are Redox filesystem configurations for automated testing which shutdown the system if successful, to use these images run one of the following commands from the build system:

- Automated test suite execution

This image run the `acid`, `relibc-tests`, and `os-test` test suites.

```
make CONFIG_NAME=auto-test all qemu
```

- Automated `os-test` test suite execution

This image run the `os-test` test suite.

```
make CONFIG_NAME=os-test all qemu
```

- Automated system compilation

This image build Redox.

```
make CONFIG_NAME=sys-build all qemu
```
