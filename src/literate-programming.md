# Literate programming

Literate programming is an approach to programming where the source code serves equally as:

- The complete description of the program, that a computer can understand
- The program's manual for the human, that an *average* human can understand

Literate programs are written in such a way that humans can read them from front to back, and understand the entire purpose and operation of the program without preexisting knowledge about the programming language used, the architecture of the program's components, or the intended use of the program. As such, literate programs tend to have lots of clear and well-written comments. In extreme cases of literate programming, the lines of "code" intended for humans far outnumbers the lines of code that actually gets compiled!

Tools can be used to generate documentation for human use only based on the original source code of a program. The `rustdoc` tool is a good example of such a tool. In particular, `rustdoc` uses comments with three slashes `///`, with special sections like `# Examples` and code blocks bounded by three backticks. The code blocks can be used to writeout examples or unit tests inside of comments. You can read more about `rustdoc` [here](https://doc.rust-lang.org/stable/book/publishing-to-crates-io.html#making-useful-documentation-comments).
