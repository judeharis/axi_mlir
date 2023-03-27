#ifndef MMHELPER
#define MMHELPER

// Defining Dims here to change , easier to change all at once
#define N (argc != 4 ? 8 :  strtol(argv[1], NULL, 10))
#define M (argc != 4 ? 8 :  strtol(argv[2], NULL, 10))
#define K (argc != 4 ? 8 :  strtol(argv[3], NULL, 10))

#include <vector>
#include <iostream>
#include <string>
#include <fstream>

template <int r> int rounddown(int x) { return x - x % r; }

template <int r> int roundup(int x) { return rounddown<r>(x + (r - 1)); }

int rounddown(int x, int r) { return x - x % r; }

int roundup(int x, int r) { return rounddown(x + (r - 1), r); }

void print_matrix(int N_dim, int M_dim, std::vector<int> &matrix) {
  std::cout << "==================================" << std::endl;
  for (int n = 0; n < N_dim; n++) {
    std::cout << "|";
    for (int m = 0; m < M_dim; m++) {
      // std::cout << matrix[r * M_dim  + c];
      printf("%-3d", matrix[n * M_dim + m]);
      if (m + 1 < M_dim)
        std::cout << ",";
    }
    std::cout << "|" << std::endl;
  }
  std::cout << "==================================" << std::endl;
}

void print_matrix(int N_dim, int M_dim, std::vector<int> &matrix, std::string header) {
  std::cout << header << std::endl;
  print_matrix(N_dim, M_dim, matrix);
}

void save_matrix(std::string file, int N_dim, int M_dim, std::vector<int> &matrix) {
  std::ofstream outfile;
  outfile.open(file, std::ios_base::app);
  outfile << "==================================" << std::endl;
  for (int n = 0; n < N_dim; n++) {
    outfile << "|";
    for (int m = 0; m < M_dim; m++) {
      outfile << (int)matrix[n * M_dim + m];
      if (m + 1 < M_dim)
        outfile << ",";
    }
    outfile << "|" << std::endl;
  }
  outfile << "==================================" << std::endl;
}

void compare_matrix(int N_dim, int M_dim, std::vector<int> &A, std::vector<int> &B) {
  bool equal = true;
  for (int n = 0; n < N_dim; n++) {
    for (int m = 0; m < M_dim; m++) {
      if (A[n * M_dim + m] != B[n * M_dim + m]) {
        equal = false;
        break;
      }
    }
    if (!equal)
      break;
  }
  if (equal)
    std::cout << "A == B" << std::endl;
  else
    std::cout << "A != B" << std::endl;
}

void simpleMM(int N_dim, int M_dim, int K_dim, std::vector<int> &A, std::vector<int> &B,
              std::vector<int> &C) {
  for (int n = 0; n < N_dim; n++) {
    for (int m = 0; m < M_dim; m++) {
      int acc = 0;
      for (int k = 0; k < K_dim; k++) {
        int x = A[n * K_dim + k];
        int y = B[k * M_dim + m];
        acc += x * y;
      }
      C[n * M_dim + m] = acc;
    }
  }
}

void trans_matrix(int N_dim, int pN, int M_dim, std::vector<int> &A,
                  std::vector<int> &B) {
  for (int n = 0; n < N_dim; n++)
    for (int m = 0; m < M_dim; m++)
      B[m * pN + n] = A[n * M_dim + m];
}

void pad_matrix(int N_dim, int M_dim, int tN, int tM, std::vector<int> &A,
                std::vector<int> &padded_A) {
  int pM = roundup(M_dim, tM);
  for (int n = 0; n < N_dim; n++) {
    for (int m = 0; m < M_dim; m++) {
      padded_A[n * pM + m] = A[n * M_dim + m];
    }
  }
  // int pN = roundup(N_dim, tN);
  // print_matrix(pN, pM, padded_A, "Padded Matrix");
}

void unpad_matrix(int N_dim, int M_dim, int tN, int tM,
                  std::vector<int> &padded_A, std::vector<int> &A) {
  int pM = roundup(M_dim, tM);
  for (int n = 0; n < N_dim; n++) {
    for (int m = 0; m < M_dim; m++) {
      A[n * M_dim + m] = padded_A[n * pM + m];
    }
  }
  // int pN = roundup(N_dim, tN);
  // print_matrix(pN, pM, padded_A, "Padded Matrix");
  // print_matrix(N_dim, M_dim, A, "UnPadded Matrix");
}

void padT_matrix(int N_dim, int M_dim, int tN, int tM, std::vector<int> &A,
                 std::vector<int> &padded_AT) {
  int pN = roundup(N_dim, tN);
  trans_matrix(N_dim, pN, M_dim, A, padded_AT);
  // int pM = roundup(M_dim, tM);
  // print_matrix(pM, pN, padded_AT, "Padded_Transformed Matrix");
}

#endif // MMHELPER