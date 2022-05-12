#include "mlir/ExecutionEngine/axi/api_v1.h"
#include <chrono>
#include <iostream>

using namespace std;
using namespace std::chrono;
#define str(s) #s

// #define penable
#ifdef penable
#define pstart(N) auto start##N = chrono::steady_clock ::now();
#define pend(N, X)                                                             \
  auto end##N = chrono::steady_clock ::now();                                  \
  X += end##N - start##N;

#define pprint(X)                                                              \
  std::cout << str(X:) << " "                                                  \
            << std::chrono::duration_cast<std::chrono::nanoseconds>(X).count() \
            << " ns\n";

#define pstr(X)                                                                \
  std::chrono::duration_cast<std::chrono::nanoseconds>(X).count() << " ,"

#define ALOG(X) cout X

#else
#define pstr(X)
#define pprint(X)
#define pend(N, X)
#define pstart(N)
#define ALOG(X)
#endif

typedef std::chrono::nanoseconds time_ns;

#define PAGE_SIZE getpagesize()
#define acc_address 0x43C00000
// #define tile_M 8
// #define tile_N 8
// #define tile_K 8

// #define M 16
// #define N 16
// #define K 16

// int arg0[M][K];
// int arg1[K][N];
// int arg2[M][N];

#define aN (argc != 4 ? 16 : strtol(argv[1], NULL, 10))
#define aM (argc != 4 ? 16 : strtol(argv[2], NULL, 10))
#define aK (argc != 4 ? 16 : strtol(argv[3], NULL, 10))

void dump(int *arg0, int *arg1, int *arg2, int M, int N, int K) {
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

void reset(int *arg0, int *arg1, int *arg2, int M, int N, int K) {
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < K; j++) {
      arg0[i * K + j] = 1;
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

void writeMappedReg(int *acc, uint32_t offset, uint32_t val) {
  void *base_addr = (void *)acc;
  *((volatile uint32_t *)(reinterpret_cast<char *>(base_addr) + offset)) = val;
}

uint32_t readMappedReg(int *acc, uint32_t offset) {
  void *base_addr = (void *)acc;
  return *((volatile uint32_t *)(reinterpret_cast<char *>(base_addr) + offset));
}

int *getArray(size_t base_addr, size_t length) {
  std::fstream myfile;
  size_t virt_base = base_addr & ~(getpagesize() - 1);
  size_t virt_offset = base_addr - virt_base;
  int fd = open("/dev/mem", O_RDWR | O_SYNC);
  void *addr = mmap(NULL, length + virt_offset, PROT_READ | PROT_WRITE,
                    MAP_SHARED, fd, virt_base);
  close(fd);
  if (addr == (void *)-1)
    exit(EXIT_FAILURE);
  int *array = reinterpret_cast<int *>(addr);
  return array;
}

void v1_ts1(int *A, int *B, int *C, int M, int N, int K) {

#ifdef PROFILE
  time_ns dload = time_ns(0);
  time_ns dreduce = time_ns(0);
  time_ns dmat = time_ns(0);
  time_ns send = time_ns(0);
  time_ns recv = time_ns(0);
  time_ns cpu = time_ns(0);
  time_ns total = time_ns(0);
#endif

#ifdef HW_Counters
  int *acc = getArray(acc_address, PAGE_SIZE);
  int start_count = 0;
  writeMappedReg(acc, 0x14, 0);
  writeMappedReg(acc, 0x1c, 1);
  writeMappedReg(acc, 0x1c, 0);
#endif

  pstart(0);
  pstart(5);
  struct dma dma1;
  dma1.dma_init(0x40400000, 0x16000000, 65536, 0x16400000, 65536);
  pend(5, dmat);
  for (int k = 0; k < K; k += tile_K) {
    for (int n = 0; n < N; n += tile_N) {
      for (int m = 0; m < M; m += tile_M) {

        pstart(3);
        unsigned int *dma_inbuffer = dma1.dma_get_inbuffer();
        int data_len = 0;
        for (int tm = 0; tm < tile_M; tm++)
          for (int tk = 0; tk < tile_K; tk++)
            dma_inbuffer[data_len + tile_K * tm + tk] =
                A[(m + tm) * K + (k + tk)];
        data_len += tile_M * tile_K;
        for (int tn = 0; tn < tile_N; tn++)
          for (int tk = 0; tk < tile_K; tk++)
            dma_inbuffer[data_len + tile_K * tn + tk] =
                B[(k + tk) * N + (n + tn)];
        data_len += tile_N * tile_K;
        pend(3, dload);

        pstart(1);
#ifdef HW_Counters
        writeMappedReg(acc, 0x14, ++start_count);
#endif      
        dma1.dma_start_send(data_len, 0);
        dma1.dma_wait_send();
        pend(1, send);

        pstart(2);
        dma1.dma_start_recv(tile_N * tile_M, 0);
        dma1.dma_wait_recv();
        pend(2, recv);

        pstart(4);
        unsigned int *dma_outbuffer = dma1.dma_get_outbuffer();
        for (int tn = 0; tn < tile_N; tn++) {
          for (int tm = 0; tm < tile_M; tm++) {
            C[(m + tm) * N + (n + tn)] += dma_outbuffer[tile_M * tn + tm];
          }
        }
        pend(4, dreduce);
      }
    }
  }
  pstart(6);
  dma1.dma_free();
  pend(6, dmat);
  pend(0, total);

  cpu = total - recv - send;
  // ALOG(<< "----------------" << endl);
  ALOG(<< pstr(dload) << pstr(send) << pstr(recv) << pstr(dreduce) << pstr(dmat)
       << pstr(total) << endl);
  // ALOG(<< "----------------" << endl);
}

int main(int argc, char *argv[]) {
  int M = aM;
  int N = aN;
  int K = aK;

  auto arg0 = new int[M * K];
  auto arg1 = new int[K * N];
  auto arg2 = new int[M * N];

  reset(arg0, arg1, arg2, M, N, K);

  // C++ Code
  // ALOG(<< "Call Accelerator with C++" << endl);
  v1_ts1(arg0, arg1, arg2, M, N, K);
  // ALOG(<< "Done" << endl);
  // dump(arg0, arg1, arg2, M, N, K);
}