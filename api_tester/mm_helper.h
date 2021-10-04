#ifndef MMHELPER
#define MMHELPER

using namespace std;
#include <vector>

template <int r> int rounddown(int x) { return x - x % r; }

template <int r> int roundup(int x) { return rounddown<r>(x + (r - 1)); }

int rounddown(int x, int r) { return x - x % r; }

int roundup(int x, int r) { return rounddown(x + (r - 1), r); }

void print_matrix(int N, int M, std::vector<int> &matrix) {
  cout << "==================================" << endl;
  for (int n = 0; n < N; n++) {
    cout << "|";
    for (int m = 0; m < M; m++) {
      // cout << matrix[r * M  + c];
      printf("%-3d", matrix[n * M + m]);
      if (m + 1 < M)
        cout << ",";
    }
    cout << "|" << endl;
  }
  cout << "==================================" << endl;
}

void print_matrix(int N, int M, std::vector<int> &matrix, string header) {
  cout << header << endl;
  print_matrix(N, M, matrix);
}

void save_matrix(string file, int N, int M, std::vector<int> &matrix) {
  std::ofstream outfile;
  outfile.open(file, std::ios_base::app);
  outfile << "==================================" << endl;
  for (int n = 0; n < N; n++) {
    outfile << "|";
    for (int m = 0; m < M; m++) {
      outfile << (int)matrix[n * M + m];
      if (m + 1 < M)
        outfile << ",";
    }
    outfile << "|" << endl;
  }
  outfile << "==================================" << endl;
}

void compare_matrix(int N, int M, std::vector<int> &A, std::vector<int> &B) {
  bool equal = true;
  for (int n = 0; n < N; n++) {
    for (int m = 0; m < M; m++) {
      if (A[n * M + m] != B[n * M + m]) {
        equal = false;
        break;
      }
    }
    if (!equal)
      break;
  }
  if (equal)
    cout << "A == B" << endl;
  else
    cout << "A != B" << endl;
}

void simpleMM(int N, int M, int K, std::vector<int> &A, std::vector<int> &B,
              std::vector<int> &C) {
  for (int n = 0; n < N; n++) {
    for (int m = 0; m < M; m++) {
      int acc = 0;
      for (int k = 0; k < K; k++) {
        int x = A[n * K + k];
        int y = B[k * M + m];
        acc += x * y;
      }
      C[n * M + m] = acc;
    }
  }
}

void trans_matrix(int N, int pN, int M, std::vector<int> &A,
                  std::vector<int> &B) {
  for (int n = 0; n < N; n++)
    for (int m = 0; m < M; m++)
      B[m * pN + n] = A[n * M + m];
}

void pad_matrix(int N, int M, int tile_N, int tile_M, std::vector<int> &A,
                std::vector<int> &padded_A) {
  int pM = roundup(M, tile_M);
  for (int n = 0; n < N; n++) {
    for (int m = 0; m < M; m++) {
      padded_A[n * pM + m] = A[n * M + m];
    }
  }
  // int pN = roundup(N, tile_N);
  // print_matrix(pN, pM, padded_A, "Padded Matrix");
}

void unpad_matrix(int N, int M, int tile_N, int tile_M,
                  std::vector<int> &padded_A, std::vector<int> &A) {
  int pM = roundup(M, tile_M);
  for (int n = 0; n < N; n++) {
    for (int m = 0; m < M; m++) {
      A[n * M + m] = padded_A[n * pM + m];
    }
  }
  // int pN = roundup(N, tile_N);
  // print_matrix(pN, pM, padded_A, "Padded Matrix");
  // print_matrix(N, M, A, "UnPadded Matrix");
}

void padT_matrix(int N, int M, int tile_N, int tile_M, std::vector<int> &A,
                 std::vector<int> &padded_AT) {
  int pN = roundup(N, tile_N);
  trans_matrix(N, pN, M, A, padded_AT);
  // int pM = roundup(M, tile_M);
  // print_matrix(pM, pN, padded_AT, "Padded_Transformed Matrix");
}

#endif // MMHELPER