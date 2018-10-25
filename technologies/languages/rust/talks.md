---
title: Rust
subtitle: >
    A place to store ideas about talks.
---


# Rust chicago meetup

* **Date: 27 November 2018**

## General ideas

* The talk will be on tokio and using tokio-codec to write a simple protocol
* Needs to be around 30 minutes in length.
* Some topics that I could cover:
    * What is tokio?
    * What is Beanstalkd:
        * What does the protocol look like?
    * What is a Future
        * Some very useful combinators:
            * then
            * and_then
            * inspect
            * map
            * map_err
    * What are the building blocks of working with IO in tokio:
        * Sinks
        * Streams
        * How Sinks and Streams are futures on to pof an IO object
        * Framed
        * How framed is a wrapper type of a Sink + Stream
    * What is tokio-codec?
        * Building blocks of tokio-codec:
            * Encoder
            * Decoder
        * What is BytesMut
    * Bringing it all together:
        * top level usses codec to send requests and map response to the right type.
        * Codec encodes and decodes data into the BytesMut buffers
            * The decoder handlers parsing the various responses.

## Notes on reveal.js

The general structure seems to be a HTML document with each individual section being one topic, sub sections of the top level sections will become vertical slides. Pretty straightforward really. The next thing I'd have to look into is styling ti.
