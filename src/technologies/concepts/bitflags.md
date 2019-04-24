
# Bitflags

Bitflags are bascially using a single integer to store multiple flags. Each bit in the integer represents something. If `1` is present at that bit, then the feature is enabled, but if it's `0` it's disabled.


```c
#define DISABLE_FEATURE(v,feature) v &= ~(1<<feature)
#define ENABLE_FEATURE(v,feature) v |= (1<<feature)
```

Here these macros take the variable with the bitflags, and selectively change a bit at the `feature` location. This is done by shiting `1` to the right `feature` times.

```c
#define HAS_FEATURE(v,feature) (v & (1<<feature))
```

And here we're `&`ing `1` with the bit at the feature's bit(location).
