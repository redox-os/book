# Testing

- It's always better to test boot every time you make a system change, because it is important to see how the OS boots and works after it compiles.

- Even though Rust is a safety-oriented language, something as unstable and low-level as a work-in-progress operating system will almost certainly have problems in many cases and may completely break on even the slightest critical change.

- Also, make sure you verified how the unmodified version runs on your machine before making any changes. Else, you won't have anything to compare to, and it will generally just lead to confusion. TLDR: rebuild and test boot often.

- The real hardware testing is more rich in information than QEMU testing, thus catching more bugs

- The [os-test] test suite has the largest number of tests and is the recommended method to test the system, use the `make r.os-test-bins` command to run it

- There's also the [acid] test suite from Redox, run the `make rp.acid` command to install the suite in the Redox image and use the `cargo test` command to run correctness tests and `cargo bench` command to run stress tests.
