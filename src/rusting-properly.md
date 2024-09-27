# Rusting Properly

Some general guidelines:

* Use `std::mem::replace` and `std::mem::swap` when you can.
* Use `.into()` and `.to_owned()` over `.to_string()`.
* Prefer passing references to the data over owned data. (Don't take `String`, take `&str`. Don't take `Vec<T>` take `&[T]`).
* Use generics, traits, and other abstractions Rust provides.
* Avoid using lossy conversions (for example: don't do `my_u32 as u16 == my_u16`, prefer `my_u32 == my_u16 as u32`).
* Prefer in place (`box` keyword) when doing heap allocations.
* Prefer platform independently sized integer over pointer sized integer (`u32` over `usize`, for example).
* Follow the usual idioms of programming, such as "composition over inheritance", "let your program be divided in smaller pieces", and "resource acquisition is initialization".
* When `unsafe` is unnecessary, don't use it. 10 lines longer safe code is better than more compact unsafe code!
* Be sure to mark parts that need work with `TODO`, `FIXME`, `BUG`, `UNOPTIMIZED`, `REWRITEME`, `DOCME`, and `PRETTYFYME`.
* Use the compiler hint attributes, such as `#[inline]`, `#[cold]`, etc. when it makes sense to do so.
* Try to banish `unwrap()` and `expect()` from your code in order to manage errors properly. Panicking must indicate a bug in the program (not an error you didn't want to manage). If you cannot recover from an error, print a nice error to stderr and exit. Check Rust's book about [Error Handling](https://doc.rust-lang.org/book/error-handling.html).
