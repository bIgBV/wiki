## 13 September 2018

* Speculative execution
* A x86 CPU actually works by translating the CISC instructions on the fly to micro ops (operations) and executing those.
* Store buffers to ensure the result of speculative execution isn't exposed too early and the stores appear to be in order no matter what order they are executed in
* The CPU resources are split in half when hyperthreading.
* a `volatile` variable is always read from memory, and checked to make sure it hasn't changed.

