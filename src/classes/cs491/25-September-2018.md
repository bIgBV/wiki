
## 25 September 2018

* task parallel programming with pthreads
* threads appear to run continuously.
    * Done through context switching, using timing interrups.
    * With timing interrupts: pre-emtive multitasking
    * The alternate is cooperative multitasking.
    * Generally 10 ms intervals, sometimes 1ms
* `pthread_create(funciton_to_run)`: start a thread.
* pthread_exit(ret_val): finish executing thread. Or just return from the function passed to `pthread_create`.
* `pthread_join(thread_to_join)`: wait until this thread finishes executing.
    * wait until other thread calls pthread_exit.
    * Run 5 things in parallel and wait until they are done executing
    * creates a happens-before-edge
        * This means that anything that happens in the main thread after the join happens after everything that happened in the parallel threads.
* Lock
    * Mutual exclusion. Doesn't enforce an order, but ensure that things don't happen at the same time.
    * acquisition: pthread_mutex_lock/ptrhead_spinlock_lock
        * alternative: ptrhead_mutex_trylock - doesn't block.
    * release: pthread_mutex_unlock/pthread_spinlock_unlock
    * Critical section - a piece of code that runs single-threaded (per lock.)
        * acquire(lock) -> critical section -> release(lock)
    * fine-grained locking, usually preferable to coarse-grained locking.
        * Ex: one big lock on a hash table vs individual locks for each bucket.
* Barrier
    * pthread_barrier_init(size)
    * pthread_barrier_wait()
* Condition variable
    * kinda difficult to use.
    * `pthread_cond_t condvar`
    * `pthread_cond_wait(condvar, lock)`: supposed to wait until you get a signal on the condition variable. You hold the lock when sleeping, but cond wait will ensure that you release that lock when you wake back up.
    * `pthread_cond_signal(condvar)`
    * cond_wait can return spuriously as well
* ad-hoc synchronization.
    * `while(!start)`
    * Kinda sketchy. If `start` is not declared `volatile` the compiler might optimize it away to a `while(true)` and the thread loops forever.

