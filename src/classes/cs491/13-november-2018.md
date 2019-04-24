# More SIMD

## Handy vector instructions

* Permute: swap upper and lower parts of the register.

  ```
  VPERM2I128
  ```

* Try to work step by step, and try to look at the intermediate values.
* inline asm:
    * `+` means that put the sum in a ymm register (through `x`) and then read it back (because `x`)
    * assembly stuff followed by inputs and outputs (only outputs but + means input) followed by output and then clobber
    ```
    asm("vpaddb %0, %1, %0;"
        "vperm2i128 $0x01, $0, $0, %%ymm0;"
        :"+x"(sum):"x"(vals):"%ymm0");
    ```

```c
int integers[1024];

int min_asm(int size) {
    __m256i mins = *((__m256i*)&integers);
    for(int i = 0; i< size; i+=8) {

    }

    for(int i = 0; i < 8; i++) {
    printf("%d", *((int*)&mins[i]))}
}

int main() {
    for(int i = 0; i<GIG; i++) {
        arr[i] = (unsigned char)i % 129;
    }

    for(int i = 0; i < 1024; i++) {
        integers[i] = i
    }

    integers[500] = -1;

    int m = min_asm(1024);
}
```
