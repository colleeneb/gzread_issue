#include "k.h"

#define HIP_ASSERT(x) (assert((x)==hipSuccess))

__global__
void saxpy2(int n, float a, float *x, float *y)
{
  int i = hipBlockDim_x * hipBlockIdx_x + hipThreadIdx_x;
  if (i < n) y[i] = a*x[i] + y[i];
}

void test()
{
    int N = 1<<20;
  float *x, *y, *d_x, *d_y;
  x = (float*)malloc(N*sizeof(float));
  y = (float*)malloc(N*sizeof(float));

  HIP_ASSERT(hipMalloc(&d_x, N*sizeof(float)));
  HIP_ASSERT(hipMalloc(&d_y, N*sizeof(float)));

  for (int i = 0; i < N; i++) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  HIP_ASSERT(hipMemcpy(d_x, x, N*sizeof(float), hipMemcpyHostToDevice));
  HIP_ASSERT(hipMemcpy(d_y, y, N*sizeof(float), hipMemcpyHostToDevice));


  hipLaunchKernelGGL(saxpy2,(N+255)/256, 256,0,0,N, 2.0f, d_x, d_y );
    hipDeviceSynchronize ();
}
