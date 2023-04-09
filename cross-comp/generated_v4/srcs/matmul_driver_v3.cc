#include <cstdint>
#include <iomanip>
#include <iostream>

#include "bench_config.h"
#include "mlir_utils.h"

#include "tiling/mm_man_v1_Ns.h"

#include "tiling/mm_man_v2_As.h"
#include "tiling/mm_man_v2_Bs.h"
#include "tiling/mm_man_v2_Ns.h"

#include "tiling/mm_man_v3_As.h"
#include "tiling/mm_man_v3_Bs.h"
#include "tiling/mm_man_v3_Cs.h"
#include "tiling/mm_man_v3_Ns.h"

#include "tiling/mm_man_v4_As.h"
#include "tiling/mm_man_v4_Bs.h"
#include "tiling/mm_man_v4_Cs.h"
#include "tiling/mm_man_v4_Ns.h"

#include "System.hpp"

void dump(int *arg0, int *arg1, int *arg2) {
  printf("--\narg0:\n");
  for (int i = 0; i < M; i++) {
    printf("[");
    for (int j = 0; j < K; j++)
      printf("%d,\t", (int)arg0[i * K + j]);
    printf("]\n");
  }
  printf("--\narg1:\n");
  for (int i = 0; i < K; i++) {
    printf("[");
    for (int j = 0; j < N; j++)
      printf("%d,\t", (int)arg1[i * N + j]);
    printf("]\n");
  }
  printf("--\narg2:\n");
  for (int i = 0; i < M; i++) {
    printf("[");
    for (int j = 0; j < N; j++)
      printf("%d,\t", (int)arg2[i * N + j]);
    printf("]\n");
  }
}

void dump_out(int *arg2) {
  printf("--\narg2:\n");
  for (int i = 0; i < M; i++) {
    printf("[");
    for (int j = 0; j < N; j++)
      printf("%d,\t", (int)arg2[i * N + j]);
    printf("]\n");
  }
}

// void dump(int *arg0, int *arg1, int *arg2) {
//   using namespace std;
//   std::ofstream myfile;
//   myfile.open("tmp1.csv");
//   // // myfile << "--\narg0:\n";
//   // for (int i = 0; i < M; i++) {
//   //   // myfile << "[";
//   //   for (int j = 0; j < K; j++)
//   //     myfile << setfill(' ') << setw(7) << (int)arg0[i * K + j] << ",";
//   //   myfile << "\n";
//   // }
//   // myfile << "\n";
//   // // myfile << "--\narg1:\n";
//   // for (int i = 0; i < K; i++) {
//   //   // myfile << "[";
//   //   for (int j = 0; j < N; j++)
//   //     myfile << setfill(' ') << setw(7) << (int)arg1[i * N + j] << ",";
//   //   myfile << "\n";
//   // }
//   // myfile << "\n";

//   // myfile << "--\narg2:\n";
//   for (int i = 0; i < M; i++) {
//     // myfile << "[";
//     for (int j = 0; j < N; j++)
//       myfile << setfill(' ') << setw(4) << (int)arg2[i * N + j] << ",";
//     myfile << "\n";
//   }
//   myfile << "\n";
//   myfile.close();
// }

// void dump_out(int *arg2) {
//   using namespace std;
//   std::ofstream myfile;
//   myfile.open("tmp1.csv", std::ios_base::app);
//   // myfile << "--\narg2:\n";
//   for (int i = 0; i < M; i++) {
//     for (int j = 0; j < N; j++)
//       myfile << setfill(' ') << setw(4) << (int)arg2[i * N + j] << ",";
//     myfile << "\n";
//   }
//   myfile << "\n";
//   myfile.close();
// }

void reset(int *arg0, int *arg1, int *arg2) {
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < K; j++) {
      arg0[i * K + j] = i;
    }
  }
  for (int i = 0; i < K; i++) {
    for (int j = 0; j < N; j++) {
      arg1[i * N + j] = j;
    }
  }
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
      arg2[i * N + j] = 0;
    }
  }
}

void simpleMM(int *arg0, int *arg1, int *arg2) {
  for (int m = 0; m < M; m++) {
    for (int n = 0; n < N; n++) {
      int acc = 0;
      for (int k = 0; k < K; k++) {
        int x = arg0[m * K + k];
        int y = arg1[k * N + n];
        acc += x * y;
      }
      arg2[m * N + n] = acc;
    }
  }
}

int testCorrect(int *arg1, int *arg2) {
  bool equal = true;
  for (int i = 0; i < N * M; i++) {
    if (arg1[i] != arg2[i]) {
      equal = false;
      break;
    }
  }
  if (!equal)
    std::cout << "  FAILED" << std::endl;
  else
    std::cout << "  PASSED" << std::endl;
  return equal == true ? 0 : -1;
}

int main() {

  // This allocation is allowed if right dim is known at compile time.
  // However, MLIR expects a flattened array, and this is allocating
  // an `int **`, which has additional bytes every row of elements.
  // auto arg0 = new int [M][K];
  // auto arg1 = new int [K][N];
  // auto arg2 = new int [M][N];

  auto arg0 = new int[M * K];
  auto arg1 = new int[K * N];
  auto arg2 = new int[M * N];
  auto arg3 = new int[M * N];

  // printf("Before accelerator\n");
  // dump(arg0, arg1, arg2);

  reset(arg0, arg1, arg3);
#if TEST
  // C++ MM implementation
  simpleMM(arg0, arg1, arg3);
#endif

  reset(arg0, arg1, arg2);
  System::profile("perf_output_v4/perf-results-tmp", [&]() {
    for (int i = 0; i < 20; ++i) {
      // if (i % 20 == 0)
      //   std::cout << "Iteration " << i << std::endl;
#ifdef RUNCPP
        // ==========================================================
        // C++ Version
#ifdef ACCv4As
      v4_As(arg0, arg1, arg2);
#elif ACCv4Bs
  v4_Bs(arg0, arg1, arg2);
#elif ACCv4Cs
  v4_Cs(arg0, arg1, arg2);
#elif ACCv4Ns
  v4_Ns(arg0, arg1, arg2);
#else
  std::cout << "No accelerator version specified" << std::endl;
  exit(1);
#endif
#if DBG
      printf("Executed MANUAL version on accelerator\n");
#endif

#elif RUNMLIR
  // ==========================================================
  // MLIR without C interface
  // clang-format off
  MLIRMATMULCALL((int *)arg0, (int *)arg0, 0, M, K, K, 1,
                 (int *)arg1, (int *)arg1, 0, K, N, N, 1,
                 (int *)arg2, (int *)arg2, 0, M, N, N, 1);
// clang-format on
#if DBG
  printf("Executed MLIR version on accelerator\n");
#endif
#endif
    }
  });

#if DBG
  printf("Problem ");
  printf("M=%d, N=%d, K=%d, tile_M=%d, tile_N=%d, tile_K=%d ", M, N, K, tile_M,
         tile_N, tile_K);
  printf("finished execution. Printing matrices: \n");
  dump(arg0, arg1, arg2);
  printf("Done.\n");
#endif

  int ret = 0;
#if TEST
  // Compare with C++ MM implementation
  ret = testCorrect(arg2, arg3);
#if DBG
  dump_out(arg3);
#endif
  free(arg3);
#endif

  free(arg0);
  free(arg1);
  free(arg2);
  return ret;
}
