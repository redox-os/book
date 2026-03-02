# Testing

- It's always better to test boot every time you make a system change, because it is important to see how the OS boots and works after it compiles.

- Even though Rust is a safety-oriented language, something as unstable and low-level as a work-in-progress operating system will almost certainly have problems in many cases and may completely break on even the slightest critical change.

- Also, make sure you verified how the unmodified version runs on your machine before making any changes. Else, you won't have anything to compare to, and it will generally just lead to confusion. TLDR: rebuild and test boot often.

- The real hardware testing is bigger than QEMU testing and thus detect more bugs.

- The test suites can be executed in an automated way by running the `make rp.sys,--with-package-deps` command from the build system and running the `auto-test` command inside of Redox (testing on real hardware is more rich and thus cna have different results compared to QEMU).

## Manual Test Suite Execution

- [acid](https://gitlab.redox-os.org/redox-os/acid) is the smallest test suite on Redox (quickest way to test), to use it run the `make rp.acid` command from the build system to install the suite in the Redox image, run the `cd acid` command to go to the `acid` directory and use the `cargo test` command to run correctness tests and `cargo bench` command to run stress tests.

- [relibc-tests](https://gitlab.redox-os.org/redox-os/relibc/-/tree/master/tests) is the second most rich test suite in Redox and is used to complement the `acid` test suite (test faster than the `os-test` test suite), use the `make r.relibc-tests-bins` command from the build system to run it or the `make rp.relibc-tests` command to add the source in the Redox image, build (`cd relibc-tests` and `make run` commands) and run it (`make test` command) later inside of Redox for more testing.

- The [os-test](https://sortix.org/os-test/) test suite has the largest number of tests and is the recommended method to test the system (but take more time to test), use the `make r.os-test-bins` command from the build system to run it or the `make rp.os-test` command to add the source in the Redox image, build (`cd os-test` and `make all` commands) and run it (`make test` command) later inside of Redox for more testing.
