#include "hip/hip_runtime.h"

__global__ void saxpy2(int n, float a, float *x, float *y);
