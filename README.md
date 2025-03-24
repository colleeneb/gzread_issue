# Overview

This is to demonstrate different ways of build static libs resulting in different outcomes for
chipStar.

```
# this static lib build works:
hipcc --emit-static-lib -fPIC -I. k.cpp -o libk.a

# building and linking in the "main" file t.cpp:
hipcc  -fgpu-rdc  -I. -c t.cpp
hipcc  -fgpu-rdc --hip-link  t.o ./libk.a
./a.out
```

```
# the build below fails with
# + ./a.out
# CHIP error [TID 107681] [1742822104.819146107] : hipErrorLaunchFailure (Failed to find kernel via kernel name: _Z6saxpy2ifPfS_) in /lus/flare/projects/Aurora_deployment/bertoni/chip-spv_source-20250227-Release/chip-spv/src/CHIPBackend.cc:271:getKernelByName
# Max error: 4.000000
hipcc -fgpu-rdc -I. -c k.cpp
ar rcsD  libk.a k.o
hipcc  -fgpu-rdc  -I. -c t.cpp
hipcc  -fgpu-rdc --hip-link  t.o ./libk.a
./a.out
```