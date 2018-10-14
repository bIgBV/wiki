---
title: CS 401
subtitle: >
    4th October 2018
header-includes:
    - \usepackage{amsmath}
---

* Closest pairs on a plane
* Find a bisector on the plane which splits the point in two half
    * Assuming all `x` coordinates are distinct
    * Find the closest pair on the left $\delta(1)$ and $\delta(2)$
    * If there is a pair with distance less than $\delta$ then it should be within $\delta$ of the bisector as anything more would be more than $\delta$
    * The shortest should be present within the band $2 * \delta$
    * Sort all points by $y$
    * Take the one of the band and split it into 2 of width $\delta / 2$
    * split it horizontally with bands $\delta / 2$ in height
* Dynamic programming
    * Longest increasing subsequence problem
        * Input: $x_1, \cdots, x_n \in \mathbb{N}$
        * Goal: Find $i_1 < i_2 < \cdots < i_k \epsilon \{1, \cdots, n\}$ such that $X_i_1 < X_i_2 < \cdots < X_i_k$
        * Objective: Maximize $k$
        * Brute force approach will consider all subsequences (powerset ) $2^N$ and check each for increasing: $N$, total: $\mathcal{O}(n2^n)$
        * $Opt(i)$ = Longest increasing subsequence that starts at $X_i$ and includes $X_i$
        * $Opt = \max_{i \in {1,\cdots,n}} Opt(i)$
        * $Opt(i) = 1 + \max_{j=\{i+1, \cdots, n+1\}: X_j > X_i} \{Opt(j), Opt(N + 1)\} = 0$
        ```
        Opt(i):
            if M[i] != 0:
                return M[i]
            if i = n + 1:
                return 0
            for j = i+1 to n+1:
                if X_j > X_i :
                    c = Opt(j)
                    best = max{best, 1 + c}
            M[i] = best
            return best
        ```
        
        Without recursion:
        
        ```
        M[n+1] = 0
        for i = n to 1:
            M[i] = 1
            for j = i + 1 to n:
                if X_i < X_j and M[i] < 1 + M[j]:
                    M[i] = 1 + M[j]
        return max{M[1],..., M[n]}
        ```
    * Subset sum problem
        * Input: $X_1, \cdots, X_n \epsilon \{1,..C\}$ where $C$ is at most a constant and $k \epsilon \mathbb{N}$
        * Question: Is there a subset of $\{X_i, \cdots, X_n$ that sums up to $k$
        $$
        Answer(i, l)=\begin{cases}
            true& \text{if $\exists$ subsequences in $X_i, \cdots, X_n$ that sums to l},\\
            false& \text{otherwise}
        \end{cases}
        Answer = Answer(1, k)
        Answer(i, l) = Answer(i + 1, l) OR Answer(1 + 1, l - X_i)
        $$
