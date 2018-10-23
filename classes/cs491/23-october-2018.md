---
title: 23 October 2018
Subtitile: Synchronization mechanisms and HW4
---

* Have a signle threaded linked-list, but doesn't run well with multiple threads.
    * A reader-writer lock
    * A fine grained locking implementation
    * Next assignment probably lock free data structures.

# Locks:

## Spinlock: simplest possible lock.
* Use atomic instruction to set lock variable to 1
* Only set it to one if it was already 0

```
while(CAS(&lockvar, 0, 1)); // lock xchg
```

Set `lockvar` to 1 if it was already a 0

* If the lock is already taken, all the CPU's waiting on the lock will all be spinning
* Actively polls the lock until it becomes available
* Good if all threads are always active, but not so good when the thread holding the lock is sleeping

## Sleeplock/pthread_mutex_t:
* If the lock is available, just take it, or else sleep

```
while(we don't have the lock) {
    if(lock is available) { take it and when releasing it, wake any sleepers on this lock (futex) }
    else { sleep until it becomes available }
}
```
* If we just yeild, then it's not a good idea when there are multiple threads
* `sys_futex(&lock, old_value)`
* If the value at the address of lock is still the old value, put the thread to sleep.
* Great when you have more threads than hardware threads, but not that great if the number of threads equals the number of hardware threads.
* There's a lot of overhead due to the multiple syscalls being made.
    * syscalls themselves are 10k+ cycles, then we are sleeping. The release thread now does another syscall and there's communication between the cores to make the wakeup happen.

It's always better to use a mutex over a futex as you're almost always going to have more threads than hardware threads. So mutexes work for the general case

# Data structure considerations

## Hashtables:

* N buckets
* M entries M > N
* Linked list hanging off of each bucket.

Consider when we are accessing this from multiple threads.

### Synchronization design options

* Big fat lock:
    * One giant lock locked, so only one thread can access the table at a time.
* One per bucket:
    * One the value of one bucket is being changed, then other users don't generally will be doing the same.
    * The drawback is you end up using a lots of locks.
    * only one thread can access each bucket at a time.
    * It would be better if we only had as many locks as the number of threads.
* Split the buckets evenly across `k` locks, `k == num_threads*C` where C is some constant to have a more even spread of locks across the hash space.
    * `lock(lock_array[bucket%size(lock_array)])`
* Concurrent linked-list:
    * inside a popular bucket, there is one linked list which has to be traversed.
    * Bit fat lock:
        * probably great for very short lists. Because list traversal doesn't need to bother with locks
    * Bit fat readers/writer lock:
        * `pthread_rwlock_t`
            * count = number of readers in lock
            * lock r = protecting the count
            * lock g: global lock to keep writers out.
        * `rdlock()`
            ```
            lock(r)
            inc count
            if count == 1 {
                lock(g)
            }
            ```
        * `wrlock()`
            ```
            lock(g)
            ```
        * `rdunlock()`
            ```
            lock(r)
            dec count
            if count == 0 {
                unlock(g);
            }
            unlock(r)
            ```
        * `wrunlock()`
        * If a reader is holding a lock, then let other readers in but no writers
        * If a writer is holding a lock, don't let any readers in.
        * They can be writer preferring or reader reader preferring.
        * So the writers might be starved as the count might always be > 0
    * One lock per item:
        * hand-over-hand locking
    * Read copy update:
        * Synchronization free for readers.
    * Lock free linked list.
