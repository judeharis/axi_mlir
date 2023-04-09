#!/usr/bin/python3

import math
import sys
from itertools import product

C_W = 2
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

def get_best(outputs):
    least = sys.maxsize
    for data in outputs:
        if data[7] < least:
            least = data[7]

    bests_accesses = []
    for data in outputs:
        if data[7] == least:
            bests_accesses.append(data)
    
    least_computes = sys.maxsize
    for data in bests_accesses:
        if data[8] < least_computes:
            least_computes = data[8]

    best_access_computes = []
    for data in bests_accesses:
        if data[8] == least_computes:
            best_access_computes.append(data)
    
    return best_access_computes


def get_access_count(M,N,K,tile_sizes):
    A_buffer_size = 4096
    B_buffer_size = 4096
    C_buffer_size = 4096
    outputs = []
    count = 0
    for tile_M, tile_K, tile_N in product(tile_sizes, repeat=3):
        if tile_N * tile_K <= A_buffer_size and tile_M * tile_K <= B_buffer_size and tile_N * tile_M <= C_buffer_size:
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
    best=get_best(outputs)
    return best


def get_access_count_C(M,N,K,tile_sizes):
    A_buffer_size = 4096
    B_buffer_size = 4096
    C_buffer_size = 4096
    outputs = []
    count = 0
    for tile_M, tile_K, tile_N in product(tile_sizes, repeat=3):
        if tile_N * tile_K <= A_buffer_size and tile_M * tile_K <= B_buffer_size and tile_N * tile_M <= C_buffer_size:
            num_computes = math.ceil(K / tile_K) * math.ceil(N / tile_N) * math.ceil(M / tile_M)
            num_accesses_A, num_accesses_B, num_accesses_C =  c_stationary_num_accesses(M,N,K,tile_M,tile_K,tile_N)
            sum_accesses = num_accesses_A + num_accesses_B + num_accesses_C
            outputs.append(["C",tile_M, tile_N, tile_K,num_accesses_A, num_accesses_B, num_accesses_C,sum_accesses,num_computes])
            count += 1
    best=get_best(outputs)
    return best


def get_access_count_A(M,N,K,tile_sizes):
    A_buffer_size = 4096
    B_buffer_size = 4096
    C_buffer_size = 4096
    outputs = []
    count = 0
    for tile_M, tile_K, tile_N in product(tile_sizes, repeat=3):
        if tile_N * tile_K <= A_buffer_size and tile_M * tile_K <= B_buffer_size and tile_N * tile_M <= C_buffer_size:
            num_computes = math.ceil(K / tile_K) * math.ceil(N / tile_N) * math.ceil(M / tile_M)
            num_accesses_A, num_accesses_B, num_accesses_C =  a_stationary_num_accesses(M,N,K,tile_M,tile_K,tile_N)
            sum_accesses = num_accesses_A + num_accesses_B + num_accesses_C
            outputs.append(["A",tile_M, tile_N, tile_K,num_accesses_A, num_accesses_B, num_accesses_C,sum_accesses,num_computes])
            count += 1
    best=get_best(outputs)
    return best