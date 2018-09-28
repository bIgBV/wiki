---
title: CS 401, 20 September 2018
subtitle: >
    Greedy graph algorithms
---

* Clustering of maximum spacing:
    * Build a graph out of the plane on which all the points are present.
    * $P = R^2, |P| = n$
    * Points are vertices $V = P$
    * Edges are all possible edges between all the points. $E = (P 2)$
    * Construct a minimum spanning tree from the graph $\forall u, v \epsilon V, l(u, v) = d(u, v) = ||u - v||_2$
    * delete the largest edges in decreasing order.
    * Each deletion creates a new connected component.
    * Single link k-clustering algorithm

## Divide and conquer algorithms

* Create smaller subproblems from larger probelem. Recursively solve the smaller sub problems and merge the results.
* Counting inversions
