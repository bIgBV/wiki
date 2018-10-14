---
title: Notes for CS491 High Performance Concurrent Systems
subtitle: 4th October 2018, some compiler tricks and OpenMP
---

* `restrict` when used tells the compiler that there exists no other pointer that points to this value.

  ```
  int indexof(int *buf, int* restrict value) {
    int index = 0;
    while (index < 10000) {
        if (buf[index] == *value) return index;
        buf[index] = 0;
        index++;
    }
    return 10000;
  }
  ```

  Here when not using `restict` the compiler doesn't know if the function will modify the value because the value could be a pointer to somewhere inside the buffer. When using `restrict` it tells the compiler that there is not other pointer pointing to this value.
* To just run the pre processor, pass `-E` to gcc.
* The preprocessor just does string replacement for includes and defines
* OpenMP is kinda like the C preprocessor.
* `#include <omp.h>` just provides some functions.
* Example:
  ```
  #include <stdio.h>
  #include <omp.h>

  int main() {
    #pragma omp parallel
    {
        printf("Hello world %d\n", omp_get_thread_num());
    }
  }
  ```

  The `pragma omp parallel` tells open MP to run the following block in parallel. There is an implicit barrier at the start and end of the block
  D
  ```
    #pragma omp parallel
    {
        printf("Hello world %d\n", omp_get_thread_num());
    }
    #pragma omp parallel
    {
        printf("Hello again %d\n", omp_get_thread_num());
    }
  ```

  "Hello again" will only show up after hello world and it works this way due to the implicit barrier else there would be a few threads writing Hello world and some others writing Hello again.
* `OMP_NUM_THREADS=n` env variable sets up the number of threads to use.
* We can use `#pragma omp single` inside a `parallel` pragma to run a piece of code only once
* Generally OpenMP is used for data parallel programming, meaning the same task performed over different parts/sets of data.
  ```
  int main () {
    long long sum = 0;
    #pragma omp parallel
    {
        #pragma omp for
        for(int i = 0; i < 100000000; i++) {
            sum += i;
        }

        #pragma omp single
        printf("Sum: %lld\n", sum);
    }
  }
  ```

  We need each one of these threads to have it's own value. So we can use `#pragma omp for private(sum)` for that. But that might now work. We can use `lastprivate(sum)` in which the last iteration across all the threasd will be the one being returned.

  A better solution is to use `#pragma omp for reduction(+:sum)` where it's saying make sum a private value before starting the loops across the threads, but before you exit take all the local private values and sum them together.

* Using `#pragma omp for schedule(static, 1)` wuld mean that all the threads will get chunks of size 1 to work with.
* using `schedule(dynamic, 10)` openMP schedules them according to whoever will be free to finish the work.
* Using `schedule(guided, 10)` OpenMP starts with large sized chunks and towards the end of the loop, the size of the chunks start to reduce.
