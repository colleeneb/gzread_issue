#!/bin/bash -xe

module use /soft/modulefiles
module load chipStar/latest

rm -f libgzstream.a
rm -f test

hipcc  -I. -O -c  gzstream.simpler.C
ar cr libgzstream.a gzstream.simpler.o

hipcc  -I. -O -c test.C

# problem, reorganizing libs for dynamic loading!
#hipcc    test.o -o test -L.   -lgzstream 

# working:
MPICH_CXX=hipcc mpicxx test.o ./libgzstream.a  -o test -lz

# reproducer, sort of:
MPICH_CXX=hipcc mpicxx test.o ./libgzstream.a  -o test


