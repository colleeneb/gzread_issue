#!/bin/bash -xe
export CHIP_BE=level0

rm -f *.o *.a

# this build does not work:
#hipcc -I. -c k.cu
#hipcc -I. -c k1.cu
#hipcc --emit-static-lib  -I. k.o k1.o -o libk.a
#ar rcsD  libk.a k.o

# this build leads to
# + ./a.out
# CHIP error [TID 107681] [1742822104.819146107] : hipErrorLaunchFailure (Failed to find kernel via kernel name: _Z6saxpy2ifPfS_) in /lus/flare/projects/Aurora_deployment/bertoni/chip-spv_source-20250227-Release/chip-spv/src/CHIPBackend.cc:271:getKernelByName

# CHIP error [TID 107681] [1742822104.819272286] : Caught Error: hipErrorLaunchFailure
# CHIP error [TID 107681] [1742822104.823249041] : hipErrorLaunchFailure (Failed to find kernel via kernel name: _Z6saxpy2ifPfS_) in /lus/flare/projects/Aurora_deployment/bertoni/chip-spv_source-20250227-Release/chip-spv/src/CHIPBackend.cc:271:getKernelByName

# CHIP error [TID 107681] [1742822104.823276123] : Caught Error: hipErrorLaunchFailure
# Max error: 4.000000

hipcc -fPIC -I. -c k.cu
hipcc -fPIC -I. -c k1.cu

hipcc -fPIC -I. -c c.cpp

# dynamic lib works
hipcc  -fPIC -shared -Wl,-soname,libk.so -o libk.so k.o k1.o
ar r  libk.a k.o k1.o
ar r  libcpu.a c.o

# main file
hipcc -I. -c t.cpp

#hipcc -Wl,--no-pie  -fgpu-rdc --hip-link t.o ./libgzstream.a  ./libk.a
#hipcc -fgpu-rdc --hip-link  t.o k.o k1.o
#hipcc -fgpu-rdc --hip-link  t.o ./libk.a



# testing just .os

hipcc  -Wl,-no-pie t.o libcpu.a k.o k1.o -lz

LD_LIBRARY_PATH=./:$LD_LIBRARY_PATH ./a.out

# testing dynamic
hipcc -Wl,-no-pie t.o ./libk.so libcpu.a -lz
LD_LIBRARY_PATH=./:$LD_LIBRARY_PATH ./a.out

# testing static
#hipcc -fgpu-rdc --hip-link  t.o ./libk.a ./libcpu.a -lz
#./a.out
