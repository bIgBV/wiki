---
title: 15 November 2018
subtitle: >
    Homework 5 discussion
---

# GPU programming

* Massive parallelism without a lot of communication between individual execution units.
* problems always specified as N-dimensional array.
* work-group maps to a multi-processor:
    * contains work-items which matp to individual processor within MP
* OpenCL:
    * host program: normal C program
    * device program: written in OpenCL
