What is Redox?
==============

You might still have the question: What is Redox actually?

Redox is an attempt to make a complete, fully-functioning, general-purpose operating system with a focus on safety, correctness, and pragmatism. Redox isn't afraid of dropping the bad parts of POSIX, while preserving modest Linux API compatibility.

Because of certain design choices, we cannot reach complete 1:1 POSIX compatibility. I will expand on this later.

Most importantly, **we will not replicate the mistakes made by others.** This is probably the most important tenet of Redox. In the past, bad design choices were made by Linux, Unix, BSD, HURD, and so on. We all make mistakes, that's no secret, but there is no reason to repeat others' mistakes.

It should be obvious to the reader that this entails a trade-off, namely compatibility versus correctness. As you can see, breaking certain standards does break compatibility. We take a very pragmatic approach to these:

We do not reinvent things, just to reinvent them. Don't fix things that are already fixed, fix things which are broken.

To the extent of correctness, we keep Linux compatibility.

How can we be sure not to make mistakes?
----------------------------------------

Hah! We cannot.

We can do certain things to prevent it, however:

Linux has been way too fast to stabilize things, and way too slow to deprecate them. This meant that old, legacy drivers are a mandatory part of the Linux kernel. We want a slow release model to avoid doing bad design decisions. We will not stabilize before they are well-tested and known to work.

We will not sacrifice correctness for compatibility. We are not afraid of looking at the mistakes that were made during the development of other operating systems, and then learning from them.

The goals of Redox
------------------

We want to be able to use it, without obstructions, as a alternative to Linux on our computers. It should be able to run pretty much all Linux executables with only minimal modifications.

We're aiming towards a complete, safe pure Rust ecosystem. This is a design choice, which hopefully improves correctness and security (see `Why Rust?`).

The non-goals of Redox
----------------------

We are not a Unix clone, nor are we crazy scientists, who wants to redesign everything. Generally, we stick to the well-tested and proven correct designs. If it ain't broken don't fix it.
