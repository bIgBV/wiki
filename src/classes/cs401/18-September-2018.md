# Notes on some examples of greedy algorithms

* Scheduling to minimize lateness
    * Earliest deadline first is the most optimal algorithm
        * $t_1 = t_2 = 1$, $d_1 = 1$, $d_2 = 2$
        * This example shows that if earliest deadline first is not chosen, then lateness will be > than if earliest deadline is chosen.
    * This algorithm does not have inversions (a job j having a later deadline than i scheduled before i)
        * $t_1 = 1, d_1 = 10$, $t_2 = 1, d_2 = 5$
        * Swapping two consecutive reduces the maximum number of inversions and does not increase maximum lateness
* Optimal offline caching
    * Cache that can store $k$ items
    * Sequence of $m$ item requests $d_1, d_2, \cdots, d_m$
    * cache hit: item already in cache
    * cache miss: item not already in cache
        * must bring item in and evict something else if there isn't enough space.
    * LRU is not the most optimal
        * we know the future requests, so it could be possible that the next item which is requested is the evicted item
    * Farthest in the future
        * Evict the item which is not going to be used for the longest time.
        *
