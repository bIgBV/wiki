---
title: Rust
subtitle: >
    A collection of things I learn about the Rust programming language.
---

# Notes

General notes about the things I learned while building things in Rust.

## Working with Tokio:

When using futures combinators, some thing to take note of are:

* `and_then` is for taking the result of one future and returning a new future.
  This is because the `Item` of the type has the trait bound of `IntoFuture`.
* `map` if for when you want to take a future, and return an entirely new value
  from the resolved value
* When using and_then make sure that the closure inside is actually returning
  something and that a `;` won't rui your day
* when you `send` something, you have to use `and_then` because this ensure
  that the future is actually resolved successfully
* when using `then` the returned value must implemnt `IntoFuture`, a good thing
  though is that `Result` implements it, so you can just return that

# Projects

## tokio-beanstalkd

I've decided to make an async version of a client for the Beanstalkd protocol.
So far, these are my thoughts on building it.

* Getting hte mental model of Tokio is pretty difficult.
* When working with tokio_codec, there aren't enough examples to base your
  solution off of.
    * One thing I'm still unsure of is when I should be returning `None` vs
      when I should be returning `Err`
* But once it is setup, it makes for a pretty clean API, especially with `impl
  Future`
* Some of the error messages I've gotten are pretty bad
    * For example, for the longest time, my library wasn't compiling becasue of
      the function:

    ```
    pub fn connect(addr: &SocketAddr) -> impl Future<Item = Self, Error = failure::Error> {
        tokio::net::TcpStream::connect(addr)
            .map_err(failure::Error::from)
            .and_then(|stream| Beanstalkd::setup(stream))
    }
    ```

    The error I was getting was something similar to this:

    ```
    .and_then(|stream| Beanstalkd::setup(stream))
   |              ^^^^^^^^ the trait `futures::Future` is not implemented for `Beanstalkd<tokio::net::TcpStream>`
    ```

    After asking about this on the dicord chat, did someone clear it up that
    I need to use `map` there instead of `and_then`.

### Protocol:

* Put:
 The putmethid creates a new job.

 ```
 put <pri> <delay> <ttr> <bytes>\r\n
 <data>\r\n
 ```

### Implementation notes
* Going to implement a tokio version of the beanstalkd client.
* Right now, I am figuring out how to structure the API when using futures.
* Might not use tokio-codec
    * This is because there is barely any documented examples of using it

