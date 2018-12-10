---
title: Snippets
---

### Clamp

```js
function clamp(val) {
    return val && Math.max(Math.min(val, 26), 10);
}
```

A cool little function that _clamps_ the given value between a max and a min, here 10 and 26.
