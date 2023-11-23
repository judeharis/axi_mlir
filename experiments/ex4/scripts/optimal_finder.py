#!/usr/bin/python3

import math
import sys
from itertools import product

C_W = 2
A_buffer_size = 4096
B_buffer_size = 4096
C_buffer_size = 4096

def a_stationary_num_accesses(M, N, K, tile_M, tile_K, tile_N):
    num_tiles_A = math.ceil(M / tile_M) * math.ceil(K / tile_K)
    num_tiles_B = math.ceil(K / tile_K) * math.ceil(N / tile_N) * math.ceil(M / tile_M)
    num_tiles_C = math.ceil(M / tile_M) * math.ceil(N / tile_N) * math.ceil(K / tile_K)
    num_accesses_A = num_tiles_A * tile_M * tile_K
    num_accesses_B = num_tiles_B * tile_K * tile_N
    num_accesses_C = num_tiles_C * tile_M * tile_N * C_W
    return num_accesses_A, num_accesses_B, num_accesses_C

def b_stationary_num_accesses(M, N, K, tile_M, tile_K, tile_N):
    num_tiles_A = math.ceil(K / tile_K) * math.ceil(M / tile_M) * math.ceil(N / tile_N)
    num_tiles_B = math.ceil(K / tile_K) * math.ceil(N / tile_N)
    num_tiles_C = math.ceil(M / tile_M) * math.ceil(N / tile_N) * math.ceil(K / tile_K)
    num_accesses_A = num_tiles_A * tile_M * tile_K
    num_accesses_B = num_tiles_B * tile_K * tile_N
    num_accesses_C = num_tiles_C * tile_M * tile_N  * C_W
    return num_accesses_A, num_accesses_B, num_accesses_C

def c_stationary_num_accesses(M, N, K, tile_M, tile_K, tile_N):
    num_tiles_A = math.ceil(K / tile_K) * math.ceil(M / tile_M) * math.ceil(N / tile_N)
    num_tiles_B = math.ceil(K / tile_K) * math.ceil(N / tile_N) * math.ceil(M / tile_M)
    num_tiles_C = math.ceil(M / tile_M) * math.ceil(N / tile_N)
    num_accesses_A = num_tiles_A * tile_M * tile_K
    num_accesses_B = num_tiles_B * tile_K * tile_N
    num_accesses_C = num_tiles_C * tile_M * tile_N * C_W
    return num_accesses_A, num_accesses_B, num_accesses_C


# Gets the best tile sizes for each of the three stationary cases with the least number of accesses
# and the least number of computes
def get_best(outputs):
    least = sys.maxsize
    least_computes = sys.maxsize
    bests_accesses = []
    best_access_computes = []
    for data in outputs:
        if data[7] < least:
            least = data[7]

    for data in outputs:
        if data[7] == least:
            bests_accesses.append(data)
    
    for data in bests_accesses:
        if data[8] < least_computes:
            least_computes = data[8]

    for data in bests_accesses:
        if data[8] == least_computes:
            best_access_computes.append(data)
    
    return best_access_computes

# Gets the best tile sizes for each of the x stationary cases with the least number of accesses
# and the least number of computes
def get_best_stationary(outputs, x):
    least = sys.maxsize
    least_computes = sys.maxsize
    bests_accesses = []
    best_access_computes = []

    for data in outputs:
        if data[7] < least and data[0] == x:
            least = data[7]

    for data in outputs:
        if data[7] == least and data[0] == x:
            bests_accesses.append(data)

    for data in bests_accesses:
        if data[8] < least_computes:
            least_computes = data[8]

    for data in bests_accesses:
        if data[8] == least_computes:
            best_access_computes.append(data)
    
    return best_access_computes


# Gets the best tile sizes for each of the x stationary cases with the least number of accesses
# and the least number of computes and the with square tiles
def get_best_stationary_square_tile(outputs,x):
    least = sys.maxsize
    least_computes = sys.maxsize
    bests_accesses = []
    best_access_computes = []

    for data in outputs:
        if data[7] < least and data[1] == data[2] and data[2] == data[3] and data[0] == x:
            least = data[7]

    for data in outputs:
        if data[7] == least and data[1] == data[2] and data[2] == data[3] and data[0] == x:
            bests_accesses.append(data)

    for data in bests_accesses:
        if data[8] < least_computes:
            least_computes = data[8]

    for data in bests_accesses:
        if data[8] == least_computes:
            best_access_computes.append(data)
    
    return best_access_computes

def check_tile_constraints(tile_M, tile_K, tile_N,M,N,K):
    if tile_M * tile_K <= A_buffer_size and tile_K * tile_N <= B_buffer_size and tile_M * tile_N <= C_buffer_size:
        if tile_M <= M and tile_K <= K and tile_N <= N:
            if M%tile_M==0 and K%tile_K==0  and N%tile_N==0 :
                return True
    return False

def get_access_count(M,N,K,tile_sizes):
    outputs = []
    count = 0
    for tile_M, tile_K, tile_N in product(tile_sizes, repeat=3):
        if check_tile_constraints(tile_M, tile_K, tile_N,M,N,K):
            num_computes = math.ceil(K / tile_K) * math.ceil(N / tile_N) * math.ceil(M / tile_M)
            num_accesses_A, num_accesses_B, num_accesses_C =  a_stationary_num_accesses(M,N,K,tile_M,tile_K,tile_N)
            sum_accesses = num_accesses_A + num_accesses_B + num_accesses_C
            outputs.append(["A",tile_M, tile_N, tile_K,num_accesses_A, num_accesses_B, num_accesses_C,sum_accesses,num_computes])
            num_accesses_A, num_accesses_B, num_accesses_C =  b_stationary_num_accesses(M,N,K,tile_M,tile_K,tile_N)
            sum_accesses = num_accesses_A + num_accesses_B + num_accesses_C
            outputs.append(["B",tile_M, tile_N, tile_K,num_accesses_A, num_accesses_B, num_accesses_C,sum_accesses,num_computes])
            num_accesses_A, num_accesses_B, num_accesses_C =  c_stationary_num_accesses(M,N,K,tile_M,tile_K,tile_N)
            sum_accesses = num_accesses_A + num_accesses_B + num_accesses_C
            outputs.append(["C",tile_M, tile_N, tile_K,num_accesses_A, num_accesses_B, num_accesses_C,sum_accesses,num_computes])
            count += 1
    bests=get_best(outputs)
    bests_square_a = get_best_stationary_square_tile(outputs,"A")
    bests_square_b = get_best_stationary_square_tile(outputs,"B")
    bests_square_c = get_best_stationary_square_tile(outputs,"C")
    best = ""
    best_square_a = ""
    best_square_b = ""
    best_square_c = ""
    best_square_n = ""
    if len(bests) > 0:
        best = bests[0]
    if len(bests_square_a) > 0:
        best_square_a = bests_square_a[0]
    if len(bests_square_b) > 0:
        best_square_b = bests_square_b[0]
    if len(bests_square_c) > 0:
        best_square_c = bests_square_c[0]
        best_square_n = bests_square_c[0].copy()
        best_square_n[0] = "N"
    return best, best_square_a, best_square_b, best_square_c, best_square_n



def get_access_count_C(M,N,K,tile_sizes):
    outputs = []
    count = 0
    for tile_M, tile_K, tile_N in product(tile_sizes, repeat=3):
        if check_tile_constraints(tile_M, tile_K, tile_N,M,N,K):
            num_computes = math.ceil(K / tile_K) * math.ceil(N / tile_N) * math.ceil(M / tile_M)
            num_accesses_A, num_accesses_B, num_accesses_C =  c_stationary_num_accesses(M,N,K,tile_M,tile_K,tile_N)
            sum_accesses = num_accesses_A + num_accesses_B + num_accesses_C
            outputs.append(["C",tile_M, tile_N, tile_K,num_accesses_A, num_accesses_B, num_accesses_C,sum_accesses,num_computes])
            count += 1
    best=get_best(outputs)
    return best


def get_access_count_A(M,N,K,tile_sizes):
    outputs = []
    count = 0
    for tile_M, tile_K, tile_N in product(tile_sizes, repeat=3):
        if check_tile_constraints(tile_M, tile_K, tile_N,M,N,K):
            num_computes = math.ceil(K / tile_K) * math.ceil(N / tile_N) * math.ceil(M / tile_M)
            num_accesses_A, num_accesses_B, num_accesses_C =  a_stationary_num_accesses(M,N,K,tile_M,tile_K,tile_N)
            sum_accesses = num_accesses_A + num_accesses_B + num_accesses_C
            outputs.append(["A",tile_M, tile_N, tile_K,num_accesses_A, num_accesses_B, num_accesses_C,sum_accesses,num_computes])
            count += 1
    best=get_best(outputs)
    return best

def get_access_count_B(M,N,K,tile_sizes):
    outputs = []
    count = 0
    for tile_M, tile_K, tile_N in product(tile_sizes, repeat=3):
        if check_tile_constraints(tile_M, tile_K, tile_N,M,N,K):
            num_computes = math.ceil(K / tile_K) * math.ceil(N / tile_N) * math.ceil(M / tile_M)
            num_accesses_A, num_accesses_B, num_accesses_C =  b_stationary_num_accesses(M,N,K,tile_M,tile_K,tile_N)
            sum_accesses = num_accesses_A + num_accesses_B + num_accesses_C
            outputs.append(["B",tile_M, tile_N, tile_K,num_accesses_A, num_accesses_B, num_accesses_C,sum_accesses,num_computes])
            count += 1
    best=get_best(outputs)
    return best