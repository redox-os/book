# Testing Practices

- It's always better to test boot (`make qemu`) every time you make a change, because it is important to see how the OS boots and works after it compiles.

- Even though Rust is a safety-oriented language, something as unstable and low-level as a work-in-progress operating system will almost certainly have problems in many cases and may completely break on even the slightest critical change.

- Also, make sure you verified how the unmodified version runs on your machine before making any changes. Else, you won't have anything to compare to, and it will generally just lead to confusion. TLDR: Rebuild and test boot often.
