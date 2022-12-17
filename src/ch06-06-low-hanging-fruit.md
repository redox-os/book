# Low-Hanging Fruit

## aka Easy Targets for Newbies, Quick Wins for Pros

If you're not fluent in Rust:

 * Writing documentation
 * Using/testing Redox, filing issues for bugs and needed features
 * Web development ([Redox website, separate repo](https://gitlab.redox-os.org/redox-os/website))
 * Writing unit tests (may require minimal knowledge of rust)

If you are fluent in Rust, but not OS Development:

 * Port applications written in Rust to Redox
 * Rewritten-in-Rust libc ([relibc](https://gitlab.redox-os.org/redox-os/relibc))
 * Shell ([Ion](https://gitlab.redox-os.org/redox-os/ion))
 * Package manager ([pkgutils](https://gitlab.redox-os.org/redox-os/pkgutils))

If you are fluent in Rust, and have experience with OS Dev:

 * Familiarize yourself with the repository and codebase
 * Grep for `TODO`, `FIXME`, `BUG`, `UNOPTIMIZED`, `REWRITEME`, `DOCME`, and `PRETTYFYME` and fix the code you find.
 * Update older code to remove warnings.
 * Improve and optimize code, especially in the kernel

For those who want to contribute to the Redox GUI, our GUI strategy has recently changed.

 * OrbTk is now sunsetting, and its developers have moved to other projects such as the ones below. There is currently no Redox-specific GUI development underway.
 * Redox is in the process of adopting other Rust-lang GUIs such as [Iced](https://iced.rs) and [Slint](https://slint-ui.com/). Please check out those projects if this is your area of interest.