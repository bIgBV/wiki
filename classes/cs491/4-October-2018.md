---
title: Notes for CS491 High Performance Concurrent Systems
subtitle: 4th October 2018
---

* `mfence` instruction prevents any reads after the `mfence` from happening before the instruction
* reads before writes:
    * mov $1, x
    * mov y, %rax
    * The second instruction(read) can execute out of order before the write
    * mov $1, x
    * mfence
    * mov y, %rax
* `mfence` prevents any other instructions from running before the store buffer is drained
* why do we need the cache line to be exclusive mode for the entry in the store buffer to be written to memory?
* intel manual notes: example 8.3/4
* instructions with `lock` as the prefix are atomic instructions.
    * `lock incq`
    * The lock expands to multiple microcode instructions but they are all executed in order.
    * they provide total order.
