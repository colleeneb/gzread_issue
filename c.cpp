#include <c.h>
#include <iostream>
#include <string.h>  // for memcpy

#ifdef GZSTREAM_NAMESPACE
namespace GZSTREAM_NAMESPACE {
#endif

// ----------------------------------------------------------------------------
// Internal classes to implement gzstream. See header file for user classes.
// ----------------------------------------------------------------------------

// --------------------------------------
// class gzstreambuf:
// --------------------------------------

void open( const char* name, int open_mode) {
  gzFile file = gzopen( name, "rb");
    const int bufferSize = 1024;
    char buffer[bufferSize];
  int num = gzread( file, buffer, bufferSize);
   double *g = (double *)malloc( sizeof(int)*7);
   g[3]=1;
}
#ifdef GZSTREAM_NAMESPACE
} // namespace GZSTREAM_NAMESPACE
#endif
