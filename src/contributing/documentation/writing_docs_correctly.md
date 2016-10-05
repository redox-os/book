# Writing Documentation Correctly (TM)

Documentation for Redox appears in two places:
- In the source code
- On the website (the Redox Book and online API documentation)

Redox functions and modules should use `rustdoc` annotations where possible, as they can be used to generate online API documentation - this ensures uniform documentation between those two halves. In particular, this is more strictly required for public APIs; internal functions can generally eschew them (though having explanations for any code can still help newcomers to understand the codebase). When in doubt, making code more literate is better, so long as it doesn't negatively affect the functionality. Run `rustdoc` against any added documentation of this type before submitting them to check for correctness, errors, or odd formatting.

Documentation for the Redox Book generally should not include API documentation directly, but rather cover higher-level overviews of the entire codebase, project, and community. It is better to have information in the Book than not to have it, so long as it is accurate, relevant, and well-written. When writing documentation for the Book, be sure to run `mdbook` against any changes to test the results before submitting them.
