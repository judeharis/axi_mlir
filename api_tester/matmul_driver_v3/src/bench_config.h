#ifndef BENCHCONFIG_H
#define BENCHCONFIG_H

// Accelerator size
#ifndef tile_M
#define tile_M 4
#endif

#ifndef tile_N
#define tile_N 4
#endif

#ifndef tile_K
#define tile_K 4
#endif

// Problem Size
#ifndef M
#define M 64
#endif

#ifndef N
#define N 64
#endif

#ifndef K
#define K 64
#endif


#endif /* BENCHCONFIG_H */