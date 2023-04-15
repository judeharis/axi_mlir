
# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <time.h>

# include "tinybert.h"

int main(int argc, char ** argv) {
    int * arg0 = (int *)malloc(2 * 128 * sizeof(int));
    int * arg1 = (int *)malloc(2 * 128 * 30522 * sizeof(int));

    // time the execution
    clock_t start, end;
    double cpu_time_used;
    start = clock();
    forward(arg0, arg0, 0, 2, 128, 128, 1,
            arg1, arg1, 0, 2, 128, 30522, 128*30522, 30522, 1);
    end = clock();
    cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("Time taken: %f seconds\n", cpu_time_used);

    // free the memory
    free(arg0);

    return 0;
}
