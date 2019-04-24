# Notes

The 3-Sat problem reduces to the indepandant set problem and this redusces to vertex cover which to set cover.

This means that 3-Sat reduces to Set Cover.

You can think of any computational problem as a set of strings. As at the end of the day, the representation of anything on a computer is in binary, which is just a set of strings of 0 and 1 interpreted as particular value.

Decision problems:
* X is a set of strings
* Instance: string s
* Algorithm A solves problems X: A(s) = yes iff s \in X.

*Polynomial time*: Algorithm A runs in poly-time if for every string s, A(len(s)) terminates at most p(|s|) "steps", where p(.) is some polynomial

Meaning that the algorithm is polynomial time if it terminates in some poly factor of the length of the input.


# Definitaion of P

P is a class of problems, for which the algorithms are in poly-time.

## Class NP

NP stands non-deterministic poly-time.

Decision problems for which there exists a poly-time certifier. You can efficiently certify that a solution is a valid solution.

*Definition*: Algorithm C(s, t) is a certifier for a problem X if for every string s, s \in X iff there exists a string t such that C(s, t) = yes.

## Composite numbers problem:

Given an integer s, is s composite

There should be two numbers whose product is s.

This is NP, but to prove that, we need to show there is a certifier that runs in poly time.
