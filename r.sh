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

# working somehow:
g++ test.o libk.a libgzstream.a   -o test -lz

$COMP test.o libk.a libgzstream.a   -o test -lz

# reproducer, sort of:
#MPICH_CXX=hipcc mpicxx test.o ./libgzstream.a  -o test


# + return 0
# + rm -f libgzstream.a
# + rm -f libk.a
# + rm -f test
# + COMP=clang++
# + gcc -I. -O -c gzstream.simpler.C
# + ar cr libgzstream.a gzstream.simpler.o
# + clang++ -I. -c s_gzstream.simpler.C
# + ar cr libk.a s_gzstream.simpler.o
# + clang++ -I. -O -c test.C
# + clang++ test.o libk.a libgzstream.a -o test -lz
# /usr/bin/ld: libgzstream.a(gzstream.simpler.o): relocation R_X86_64_32 against `.rodata.str1.1' can not be used when making a PIE object; recompile with -fPIE
# /usr/bin/ld: failed to set dynamic section sizes: bad value
# clang++: error: linker command failed with exit code 1 (use -v to see invocation)
