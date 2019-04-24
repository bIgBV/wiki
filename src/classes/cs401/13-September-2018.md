# Notes

* Greedy algorithms
* Interval scheduling:
    * Job $j$ starts at $j_j$ and finishes at $f_j$
    * Two jobs _compatible_ if they don't overlap
    * Goal: find maximum subset of mutually compatible jobs
    * We need to find a way to order these jobs.
    * Can be done in a few ways:
        * Earliest start time
            * Not correct because it might pick a job which starts early but runs long instead of smaller jobs starting at a different time.
        * Earliest finish time
            * the correct algorithm.
            * Sort in term of finishing time and go through each job one by one.
            * Proof:
                * Assume greedy is not optimal
                * Let $i_1, i_2, \cdots, i_k$ denote set of jobs selected by greedy.
                * Let there be some other algorithm that is optimal.
                * For the instance we are looking at outputs something different from all the other algorithm.
                * Now if you sort by finishing time, the first $r$ steps everything lines up, but after that it doesn't.
                * Pick an optimal solution that agrees with our algorithm for the longest possible prefix.
                * If we look at the $r + 1$th job that the optimal algorithm chooses, it must end before the $r + 1$th job chosen by our solution.
                * Now if the $r + 1$st job chosen by the optimal algo finishes before the one chosen by our algorithm, then our algorithm would've chosen that one.
        * Shortest interval
            * Not correct.
        * Fewest conflicts.
* Interval partitioning
    *
