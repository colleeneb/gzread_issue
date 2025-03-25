#!/bin/bash -xe

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

hipcc -fgpu-rdc -fPIC -I. -c k.cu
hipcc -fgpu-rdc -fPIC -I. -c k1.cu

# dynamic lib works
hipcc -fgpu-rdc --hip-link -fPIC -shared -Wl,-soname,libk.so -o libk.so k.o k1.o
ar rcs  libk.a k.o k1.o

# main file
hipcc -fgpu-rdc  -I. -c t.cpp

#hipcc -Wl,--no-pie  -fgpu-rdc --hip-link t.o ./libgzstream.a  ./libk.a
#hipcc -fgpu-rdc --hip-link  t.o k.o k1.o
#hipcc -fgpu-rdc --hip-link  t.o ./libk.a



# testing just .os
hipcc -fgpu-rdc --hip-link  t.o k.o k1.o

# testing dynamic
hipcc -fgpu-rdc --hip-link  t.o ./libk.so

# example with device functions called from other translation units but in the same .a
# global constant used in other files -- hipmemcopy to

LD_LIBRARY_PATH=./:$LD_LIBRARY_PATH ./a.out

# testing static
hipcc -fgpu-rdc --hip-link  t.o ./libk.a

./a.out
