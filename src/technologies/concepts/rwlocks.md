---
title: Read Write Locks.
subtitle: >
    Some notes on read write locks
---
# Locks

Locks are a kind of synchronizatoin primitives which are used to ensure safe
and correct concurrent access to shared data between different threads

## RWLock

A read write lock is a type of a lock that allows mutiple concurrent read
accesses to shared data, while there can only be one writer at a given time.
This means that it is shared access for reading vs exclusive access for
writing.

*Note*: This seems pretty similar to [Rust's](technologies/languages/rust)
story around references, there can be multiple immutable references to the same
value while only a single mutable reference.

Implementations:

* [Parking lot](https://github.com/Amanieu/parking_lot/ )
* [pthread_rwlock_t](https://en.wikipedia.org/wiki/Readers%E2%80%93writer_lock#Programming_language_support )
