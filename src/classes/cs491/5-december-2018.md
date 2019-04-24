# Notes

* Units and prefixes, table 2.1
* statistics, 2.4
* Tools and techniques:
    * profiling
    * timing
    * performance
    * time:
        * difference between real / user / sys
        * real is the wall time
        * user is how long it was on the CPU
        * sys is how long the program spent in the kernel
* single threaded program performance:
    * concurrency in the context of a single thread.
    * out of order execution
    * memory hierarchy
* multi-threaded program performance:
    * parallelism of a program
    * coordination between threads can slow things down
    * contention over cachelines:
        * false sharing
        * true sharing
    * contentions over locks:
        * different performance based on lock type
    * memory allocation:
        * stack
        * heap
        * global
    * consistency
    * fences:
        * mfence
        * lfence
    * synchronization primitives
* Data parallel execution:
    * vectorized code.
    * GpGPU
