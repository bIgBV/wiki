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

# Rust wg-net survey notes

* Most respondants were new to rust with over 60% of the users having used Rust for less than 2 years
* The two dominant web frameworks are actix-web and Rocket ad around 40% and 43% respectively.
* Diesel is the most popular ORM
* A lot of people seem to be using hyper directly.
* The most important things that people feel is missing from the rust web crate ecosystem are examples followed by documentation.
    * a few respondants also mention stability.
* The common denominators when speaking of gaps are more examples, better documentation and more fleshed out examples.
    * Some respondants also touch on the lack of one true framework for the ecosystem ala Django for python and Rails for Ruby.
    * A lot of people mention various bindings for the backend services layer like cassandra, kubernetes, LDAP.
    * A few respondants also touch on async db support and idiomatic examples for the same.
    * Also, validation, authetication and authorization right now seems to be non-trivial
    * My own take on this is that it's a good thing. It seems to me that writing basic web services has become relatively straight forward in Rust, and now people are looking to solve secondary challanges. I feel this is a good sign of a growing ecosystem. We need to capilalize this new interest and momentum to set up best practices and canonical examples/crates/documentation/etc.
* The biggest platform specific pain seems to be OpenSSL.
    * So many respondants for the platform/target specific question mention OpenSSL. Seems to be a major issue.
* The biggest reason for people chosing Rust for web services is the language itself(at 90%), which is awesome.
    * The next reason being runtime performance at 70%
* 92% of the respondants have written web applications in other programming languages.
    * Python, Ruby, Go, Javascript and Java being the most common
* A lot of poeople feel that rust can learn a lot from Go's net/http
    * A batteries included standard library for writing performant web applications/services.
    * Have one established web framework and have lots of examples using that framework to point to.
    * Documentation is another theme that is repeated.

All in all, the biggest things I got from reading through the responses are:

* Lots of excitement for the language and the future of it.
* The rust web space is severely lacking in the examples space.
    * This is my take, but I think there isn't enough existing literature on writing web applications in web. Things like books, documentations, blog posts!
    * Looking at python and ruby, there are entire books dedicated to django and rails. I think that is something we have to keep in mind for the future.
    * But for now, blog posts talking about how to build web services/applications in rust would be great.
    * And having example applications who's source code people can go thorugh will also be helpful.

# Notes

- [General notes](rust/general-notes.md)
- [Talks](rust/talks.md)
- [WG-net-blog](wg-net.md)
