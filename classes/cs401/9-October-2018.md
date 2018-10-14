---
title: CS 401
subtitle: >
    4th October 2018, Dynamic programming
---

* Segmented Least Squares
    * Given $n$ points in the plane: $(x_1, y_1), (x_2, x_2), \cdots (x_n, y_n)$
    * Find a line $y = ax + b$ that minimizs the sum of the squared error:
        $$
        \sum_{i=1}^{n} (y_i - ax_i - b_i)^2
        $$

        This is the difference between the y predicted by the line, and the actual value, squared.
    * Instead of a single line to fit, the points lie on a sequence of several line segments.
    * Given $n$ points in the plane with
    * $x_1 < x_2 < \cdots < x_n$ find a sequence of lines that minimizes:
        * The sum of the sums of the squared error $E$ in each segment
        * The number of lines L
    * Tradeoff function: $E + cL$, for some constant $c > 0$
    * Notation:
        * $OPT(j) = minimum cost for points p_1, p_{i+1}, \cdots, p_j$
        * $e(i, j) = minimum sum of squares for points p_i, p_{i+1}, \cdots, p_j$
    * To compute $OPT(j)$:
        * Last segment uses points $p_1, p_{i+1}, \cdots, p_j$ for some i
        * Cost = $e(i, j) + c + Opt(i - 1)$
        $$
        Op
        Opt(j)=\left\{
            \begin{array}{ll}
                , if \exists subsequences in X_i, ..., X_n that sums to l,\\
                false, otherwise
            \end{array}
            \right.
        $$
* Knapsack problem:
    * Given $n$ objects amd a "knapsack"
    * Item $i$ weights $w_i > 0$ kilograms and has values $v_i > 0$
    * Knapsack has capacity fo $W$ kilograms
    * Goal: fill knapsack so as to maximize the total value.
    * Greedy: repeatedly add itemw ith maximum ratio $\frac{v_i}{w_i}$
    * Not optimal as a counter example is present
    * $OPT = OPT(1, W)$
    * $OPT(i, W')$ = max value of items $\in \{i, \cdots, n\}$ that can all fit in a knapsack of capacity of $W'$
    
    $$
    OPT(i, W')
    $$

* String similarity:
    * Edit distance (Levenshtein distance)
    * Gap penality $\delta$; mismatch penality $\alpha_pq$
    * Cost = sum of gap and mismatch penalities.
    * $OPT(i, j)$ = minimum cost of matching $x_i, \cdots, x_n$ & $y_j, \cdots, y_n$
    * The minimum cost of matching some suffix of X and some suffix of Y
    * $OPT = OPT(1, 1)$
    * 
    * Any dynamic programming probem can be expressed as a shortest path problem in a graph of all the sub problems. The edges of the graph is the cost of going from one sub problem to the other.
