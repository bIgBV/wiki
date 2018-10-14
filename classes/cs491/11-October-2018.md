---
title: Notes for CS491 High Performance Concurrent Systems
subtitle: 11th October 2018, Topics for the mid term
---
# `#pragma omp parallel`

- Single
    - Master
- for
- barrier
- critical
- task

Mid term will be comprehensive except for OpenMP

* Midterm review
    * Units
    * typical quantities
        * Cacheline is 64 bytes
        * word - 64 bits
        * How long will it take to access memory from DRAM: probably 200 cycles.
        * LLC hit: 40
        * L2: 10
        * L1: 4 cycles.
    * profiling tools
        * perf stat / record / annotate
        * gettimeofday / rdtsc
        * impact of measuring on execution
        * time
    * Single threaded performance
        * implementation of C in assembly
        * stack / heap / local variables / global variables / malloc / registers
        * instruction throughput vs latency
            * rough idea of basic instruction costs.
        * out of order execution
            * instruction re-order window
            * register renaming buffer
            * data dependencies
            * order constraints - intel memory consistency guarantees
            * store buffer
            * execution units
        * speculative execution
            * missed speculation costs 20 cycles
        * Understanding memory access
            * how does a load actually work?
            * same thing for store
        * cache
            * cache line granularity
            * associativity
            * address alignment
    * understanding the compiler / optimizer
        * reordering of instructions
        * Dead code elimination
        * inlining
        * common subexpression elimination
        * loop unrolling
        * `asm volative ("":::"memory")`
            * prevents the compiler from reordering things
        * important keywords
            * volative, const, restrict, static
    * multi-threaded consistency
        * Operation and effect of cache and store buffer
            * generally values we read are stale
        * atomic operation to get work with the most current value
        * allowable reordering of instructions
        * atomic operations
        * mfence all stores before mfence much finish before any loads after the mfence
        * synchonization
            * locks / condition variables / barriers / fork / join
        * multi-threaded performance
            * false sharing / true sharing
                * false sharing: two variables seemingly use the same cache line
                * true sharing: 
            * impact of shared memroy access
            * effect f out of order execution and store buffer
