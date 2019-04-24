# Greedy graph algorithms

* Shortest path algorithms:
    * Input: G: graph
    * $s, t \epsilon V(G)$
    * Goal compute $s-t$ shortest path.
    * Every edge has a non-negative weight in the graph $E(G) \rightarrow N$
    * Variants:
        * Directed graph.
        * Negative and positive edge weights/lengths.
        * All pairs shortest path problem (Djikstra's algorithm)
    * Other type of problems can be transformed into a graph problem
    * The question to ask is: What is all the states we can be in?
        * Once the statespace is identified, we need to identify all the possible transitions that are allowed.
    * BFS works for graphs which are undirected and all edges are of unit length.
        * To find the shortest path from all the found layers, you just go back up the layers from $t$ to $s$.
    * Djikstra's algorithm for finding the shortest path.
        * Could be considered as a generalization of BFS.
    * Initially start with the visited nodes, which at the begining only contains $s$.
    * everyone is in the unvisited set
    * Have an upper bound for the cost to get to the node from $s$.
        * Initially let it be $\inf$ and 0 for the starting vertex.
    * We look at the immediate neighbors of $s$ and update the cost for getting to those neighbors from $s$ according to their edge costs.
    * Once we have the costs for everybody else, we just choose the smallest one.
    * Now we want to update our estimates for the distance from the newly chosen vertex and update the estimated distance from $s$ to it's neighbors.
    * We'll look at all the outoing edges, we see the cost of getting to it's neighbors from the new vertex and update it to be the minimum of the sum of the cost of getting to the current node from $s$ plus the cost of getting to the new vertex for the neighbor and the current estimate.
    * We keep going by choosing the least expensive neighbor to get to from the visited set.
