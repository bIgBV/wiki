---
title: 27 November 2018
---

# Approximation algorithms

* If we allow for some small error in the answer, then we can find an approximate answer.
* Normally with NP complete problems we discussed the hardness of descision problems:
    * Decision problem: The answer is Yes or No.
    * Ex: 3-SAT, Vertex cover of size at most k
* Optimization problems:
    * Given some input $x$ and we want to optimize some object function $f$.
    * e.g: Vertex cover of minimum size(Minimization problem), Max-SAT (Find a truth assignment that satisfies maximum number of clauses. Maximization problem)
* Really only two types of optimization problems: minimization problem vs maximization problem
* For many opt problems, the descision version is hard.


* $\alpha$-Approximation algorithm form minimization problem $\pi$

Given input $X$ output solution $S$ such that $f(S) <= \alpha . OPT(x)$

* $\alpha$-Approximation algorithm for maximization prblem $\pi$

Given input $X$ compute some solution $S$ such that $f(S) >= \frac{OPT(X)}{\alpha}$

$\apha$ is called the approximation ratio


# Bin packing problem

Input: N numbers $S_1, \cdots, S_n \in (0, 1]$ item sizes

Output: Compute partitions of $\{1, \cdots, n\}$ into "bins" $B_1, \cdots, B_k$ for some $k > 0$ such that for all $i \in \{1, \cdots, k\} \exists{j \in B_i} S_j <= 1$

Greedy algorithm is a 2 approximation, meaning if optimum has k bins, then the greedy algorithm will have at most 2k bins

Optimal algorithm is bounded by the total size of the items. If each bin is of size 1, and the total size of all items is 6, then we need at least 6 bins.

If the grreedy solution, at least k - 1 of the bins are half full. The one bin which is not half full, the item in it cannot be added to any other bin as they are at least half full, as that's the only time when we use a new bin is when we cannot fit another item in the bin.

=> $ Opt >= \sum{i=1}{n} s_i > \frac{k-1}{2}$

This means that $k < 2 OPT + 1 <= 2OPT$


# Knapsack problem

Input: 
