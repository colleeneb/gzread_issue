#!/bin/bash -xe

rm -f *.o *.a
rm -f libgzstream.a

gcc -I. -c g.C
ar cr libgzstream.a g.o

hipcc -fgpu-rdc -I. -c k.C
ar rcsD  libk.a k.o

hipcc  -fgpu-rdc  -I. -c t.cpp

#hipcc -Wl,--no-pie  -fgpu-rdc --hip-link t.o ./libgzstream.a  ./libk.a
hipcc  -fgpu-rdc --hip-link  t.o   ./libgzstream.a ./libk.a

./a.out
