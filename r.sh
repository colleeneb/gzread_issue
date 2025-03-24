#!/bin/bash -xe

rm -f *.o *.a
rm -f libgzstream.a

gcc -I. -c g.C
ar cr libgzstream.a g.o

hipcc -I. -c k.C
ar cr  libk.a k.o

hipcc  -fgpu-rdc  -I. -c t.C

#hipcc -Wl,--no-pie  -fgpu-rdc --hip-link t.o ./libgzstream.a  ./libk.a
hipcc  -fgpu-rdc --hip-link k.o t.o ./libgzstream.a

./a.out
