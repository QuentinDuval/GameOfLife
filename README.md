GameOfLife
==========

Naive implementation of a Game of Life, to experiment with Repa.
http://en.wikipedia.org/wiki/Conway's_Game_of_Life

This example is a simple show case of Repa (https://hackage.haskell.org/package/repa). It shows how easy it is to switch from sequential to parallel computation with this package.

The tests I performed on the "example/test.gif" file show a significant performance improvement with 4 cores (+RTS -N4 -s).
- With 1 Core: 26.46s
- With 4 Cores: 8.75s (about 3 times faster)
