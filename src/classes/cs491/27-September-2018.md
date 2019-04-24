## September 27th

Storage heirarchy in a multi-threaded application. threads running on at least two separate cores and try to access the same piece of memory.

* load virtual_address, register
    * virtual_address -> physical address.
        * address: [page number]:[12 bit page offset]
        * page table: lookup table from virtual page number -> physical page (4096 bytes).
        * Translation Lookaside Buffer: page table cache.
        * Check some caches:
            * L1
            * L2
            * LLC (Last Level Cache)
            * remote LLC
            * DRAM
        * No guarantee that the value is the most recent change.
* store
    * virtual -> physical
    * Example when two processes try writing to one cache line.
    * acquire the cache line in exclusive mode(MOESI)
        * modified: a process has modified the value and the latest value needs to be asked from it.
        * owned: read only but only one process has the copy (probably?)
        * exclusive: before writing to a cache line, only one process can be in exclusive mode. Need to coordinate with other cores/sockets to ensure that.
        * shared: read only, but multiple copies.
        * invalid:
    * example: two stores to different cache lines.
        * on a single CPU it's not really an issue as there is no dependency between the two.
        ```
        data = {some data} // in a remote LLC
        data_is_ready_flat = 1 // in L1
        ```

        Now we have an issue here as the flag will be updated before the data being written to the cache line since write to a remote LLC take time.

    * Memory consistency model:
        * Sequential consistency:
            * If we can interleave the instructions running on multiple cores and run it on a single CPU and get the same results, it's sequential consistency model.
        * On x86: Total store order
            * any stores by a single CPU are visisble to all other CPUs in the same order
            * So in the previous example, it would okay that the data is being written to a remote LLC
            * In order to ensure that, the data doesn't end up on the cache, it stores the value in a store buffer, a FIFO queue.
        * Store buffer:
            * there to provide total store order
            * or to make stores faster
            * 56 entries in recent CPUs
        * Example load after store:
            ```
            mov $5, x
            mov x, %rax
            ```
            * loads from store buffer ~L1 speeds
        * atomic/locked instructions
            * `lock xchg`
            * `lock inc`
            * Get the cacheline in exclusive mode when you read. Then you perform a write, wait for the write to clear out from the store buffer before releasing the cacheline.

