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


# Output of running:
# + mpicxx test.o ./libgzstream.a -o test
# /usr/bin/ld: ./libgzstream.a(gzstream.simpler.o): undefined reference to symbol 'gzread'
# /usr/bin/ld: /lib64/libz.so.1: error adding symbols: DSO missing from command line
# clang++: error: linker command failed with exit code 1 (use -v to see invocation)
#
# failed to execute:/soft/compilers/chipStar/clang-chip-spv/17.0-20250131-release/bin/clang++ -include /soft/compilers/chipStar/chip-spv/20250227-Release/include/hip/spirv_fixups.h -I//soft/compilers/chipStar/chip-spv/2025\
# 0227-Release//include -I/opt/aurora/24.180.3/spack/unified/0.8.0/install/linux-sles15-x86_64/oneapi-2024.07.30.002/mpich-4.3.0rc3-fzmrfta/include -L/opt/aurora/24.180.3/spack/unified/0.8.0/install/linux-sles15-x86_64/one\
# api-2024.07.30.002/mpich-4.3.0rc3-fzmrfta/lib -lmpicxx -Wl,-rpath -Wl,/opt/aurora/24.180.3/spack/unified/0.8.0/install/linux-sles15-x86_64/oneapi-2024.07.30.002/mpich-4.3.0rc3-fzmrfta/lib -lmpi test.o ./libgzstream.a -o \
# test -L/soft/compilers/chipStar/chip-spv/20250227-Release/lib -lCHIP -no-hip-rt -locml_host_math_funcs -Wl,-rpath,/soft/compilers/chipStar/chip-spv/20250227-Release/lib
