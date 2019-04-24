
## 11 September 2018
* `H` in perf report annotate to go to the hottest line
* `perf stat` output: `stalled-cycles-frontend` the part which figures out what to run next
* Effects of memory allocation
    * Local variables
        * allocated on the stack or in a register
        * or not at all (with an optimizing compiler)
        * Callee-save registers
             * r8-r15
        * caller-save registers
            * rax-r8
    * Stack
        * local variables
        * good memory locality
            * since your program is always accessing the stack, so it'll be in the cache.
        * Limited storage space.
        * Limited lifetime
    * Heap
        * sbrk-allocated heap, malloc managed
            * high overhead for allocation
            * virtually unlimited size
            * space: min 24 bytes
            * CPU: needto find a chunk
            * freeing a large amount of memory doesn't always work
        * mmap allocated.
        * Dynamically allocate as much as you want.
        * Generally speaking slower because memory locality.
    * Static
        * allocated compile time
        * if initialized they are allocated in the binary.
    * Thread local
        * _thread int count;
        * now there is a count for every thread.
    * speculative execution
        * for each branch, guess which way it will go
            * execute speculatively
            * but don't save the results.

