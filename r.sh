#!/bin/bash -xe

#module use /soft/modulefiles
#module load chipStar/latest

module use ~/modulefiles
module load chipStar/.llvm18/20250409/release

rm -f libgzstream.a
rm -f libk.*
rm -f test
COMP=clang++

#gcc  -fPIC -I. -O -c  gzstream.simpler.C
gcc -I. -O -c  gzstream.simpler.C
ar cr libgzstream.a gzstream.simpler.o

# new shared lib that needs open definition for shared_open
$COMP -I. -c s_gzstream.simpler.C
ar cr libk.a s_gzstream.simpler.o
#$COMP -fPIC -shared -Wl,-soname,libk.so -o libk.so s_gzstream.simpler.o

$COMP  -I. -O -c test.C

# problem, reorganizing libs for dynamic loading!
#hipcc    test.o -o test -L.   -lgzstream 

# working:
$COMP -Wl,-no-pie test.o libk.a libgzstream.a   -o test -lz

# reproducer, sort of:
#MPICH_CXX=hipcc mpicxx test.o ./libgzstream.a  -o test


