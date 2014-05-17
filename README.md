GameOfLife
==========

Naive implementation of a Game of Life, to experiment with Repa.
http://en.wikipedia.org/wiki/Conway's_Game_of_Life

This example is a simple show case of Repa (https://hackage.haskell.org/package/repa). It shows how easy it is to switch from sequential to parallel computation with this package.

The tests I performed on the "example/test.gif" file, with 150 iterations, show a significant performance improvement with 4 cores (+RTS -N4 -s).
- With 1 Core: 21.96s
- With 4 Cores: 7.19s (about 3 times faster)
 
Command line argument used (where x stands for the number of cores):
examples/test.gif examples/test_out.gif 150 +RTS -Nx -s


Further testings
================

I noticed that collecting the last image only (instead of collecting all images to produce the animated gif) had for effects:
- To make the program run in constant space (with 8.6 MB maximum residency).
- To make the program more scalable in terms of parallelism.

Using the same machine, I got the following results:
- With 1 Core: 21.97s
- With 4 Cores: 5.63s (about 3.9 times faster)

It shows that Repa takes real good advantage of multiple cores (from 1.1 millions pixels/s to 4.25 millions pixels/s).
