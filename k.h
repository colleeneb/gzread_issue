#ifndef SQUARE_H
#define SQUARE_H
#include "hip/hip_runtime.h"
//__constant__ float c_ABC[3];
__device__ int device_square(int x);
void test(float *d_x,float *d_y, float *x, float *y, int N );
void test2(float *d_x,float *d_y, float *x, float *y, int N );
#endif

