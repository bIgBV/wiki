---
title: Rust
subtitle: >
    A collection of things I learn about the Rust programming language.
---

# Patterns:

One way to sort of extend enums and extract common variants across different enums is to have a `Base` enum and have one variant of the base in different enums:

```rust
enum Base {
    Alpha,
    Beta
}

enum Foo {
    Base(Base),
    Roo,
}

enum Bar {
    Base(Base),
    Bar
}
```

This is pretty useful when creting custom `Error` kinds for protocols, where there could be protocol errors which are commmon and each command has a separate enum for its own errors.

Something to keep in mind with Enums is to make then non-exhaustive. This is great for public API where the enum variants might change in the future. This can be added by a `__NonExhaustive` variant

# Notes

- [General notes](rust/general-notes.md)
- [Talks](rust/talks.md)
