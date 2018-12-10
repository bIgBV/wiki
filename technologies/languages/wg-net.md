---
title: WG net
subtitle: >
    A collection of notes regarding the Rust networking work group
---

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


We recently sent out a survey regarding the state of the current Rust web ecosystem and we got over a 1000 responses! Today, we would like to go over the responses and understand the results.

Rust is a relatively new language and our users reflect that, with more than 60% of them having only used it for the last two years. Coming to web development, the two most popular frameworks for building web applications are [Rocket]() followed by [Actix]() at 43% and 40% respectively. Though those are not the only two frameworks. Some of the many other popular web frameworks currently being used building web applications are APPLICATIONS HERE. There are many users who are using the [Hyper]() crate directly to write web services.

Almost all web applications need to talk to a database and ORM's provide a convienient abstraction to do so in the same programming language as the one you are using to write the web application. To this end, [Diesel]() is the most popular ORM framework for rust followed by INSERT RUNNER UP.

Coming to what people feel is mising from the Rust networking/web ecosystem, the majority of the users INSERT NUMBER HERE find the lack of examples to be the biggest issue currently with the ecosystem followed by the lack of documentation. This is something that is actively being addressed by initatives such as the [Tokio doc blitz]() and the [Rust async book](). There is also users talking about the lack of a One True Framework a la Django in python and Rails in ruby. This is something which was considered by the netoworking work group and to this end, work has begun on [Tide]() a framework meant to provide a good starting point for people to get started with building web applications in Rust and for people wanting to dig deeper and learn how to write such services in Rust.

The next issue which users mentioned is the lack of bindings for frameworks and services used when building applications. This includes bindings for applications like Cassandara, support for running on Kubernetes and LDAP authentication. A few people also touch on the lack of async database access support and no idiomatic example of how to go about doing it.

Rust aims to make writing systems software on various platforms easier. This is not always possible though, and is shows as our users report that using OpenSSL is the biggest platform specific pain faced by them.


92% of our respondants have written a web application in a different language and provide information regarding what Rust can learn from those languages. People find that they miss the vast batteries included standard library of Go which lets you write performant web applications and services straight out of the box. They also mention the good documentation of projects such as Django and Rails. The most popular reason why people chose to use Rust for they web service/application was the language itself at 90%. The next reason was the runtime performance Rust offered at 70%.

After going through all the great responses, these are some of the common themes I found:

* There is a lot of excitement for the future of the Rust networking and web ecosystem.
* Most of the users  are really excited for the Rust language itself.
* The lack of documentation and examples is the majaor limiting factor for people to build services and applications in Rust today.
