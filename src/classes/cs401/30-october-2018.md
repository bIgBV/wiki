# Reductions and Disjoint paths

# Disjoint paths

Given a graph \\(G = (V,E)\\) and two nodes \\(s\\) and \\(t\\), we need to find the number of edge-disjoint paths from \\(s\\), \\(t\\).

Two paths are edge disjoint if they have no edge in common. They can share vertices.

A greedy algorithm which finds any path from \\(s\\) to \\(t\\), and then deletes the edges and tries again is not right.

Instead think of this problem as a max flow problem where the capacities of the edges are 1.

Now compute the max flow and the value of the value of the max-flow is equal to the maximum number of edge-disjoint paths in the graph/network. The capacity of each edge is 1, so you cannot have 2 units of flow through an edge.

Two things to show:
1. Number of edge disjoint paths cannot be > than the value of max flow
2. The value of max flow is the number of edge disjoint paths.

Proove: if you have \\(k\\) edge disjoint paths, find \\(k\\) units of max flow through the reduced flow network.


# Circulation with Demands

Instead of a single source and single sink, we can allow flows to enter at arbitrary locations and exit at arbitrary locations.
