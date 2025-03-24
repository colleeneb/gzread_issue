#!/bin/bash -xe

rm -f *.o *.a

# this build works:
hipcc --emit-static-lib -fPIC -I. k.cpp -o libk.a
#ar rcsD  libk.a k.o

# this build leads to
# + ./a.out
# CHIP error [TID 107681] [1742822104.819146107] : hipErrorLaunchFailure (Failed to find kernel via kernel name: _Z6saxpy2ifPfS_) in /lus/flare/projects/Aurora_deployment/bertoni/chip-spv_source-20250227-Release/chip-spv/src/CHIPBackend.cc:271:getKernelByName

# CHIP error [TID 107681] [1742822104.819272286] : Caught Error: hipErrorLaunchFailure
# CHIP error [TID 107681] [1742822104.823249041] : hipErrorLaunchFailure (Failed to find kernel via kernel name: _Z6saxpy2ifPfS_) in /lus/flare/projects/Aurora_deployment/bertoni/chip-spv_source-20250227-Release/chip-spv/src/CHIPBackend.cc:271:getKernelByName

# CHIP error [TID 107681] [1742822104.823276123] : Caught Error: hipErrorLaunchFailure
# Max error: 4.000000

# hipcc -fgpu-rdc -I. -c k.cpp
# ar rcsD  libk.a k.o

hipcc  -fgpu-rdc  -I. -c t.cpp

#hipcc -Wl,--no-pie  -fgpu-rdc --hip-link t.o ./libgzstream.a  ./libk.a
hipcc  -fgpu-rdc --hip-link  t.o ./libk.a

./a.out
