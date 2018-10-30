---
title: 30 October 2018
subtitle: >
    Synchronization design: various forms of maintaining sanity.
    Lock design
---

# Lock free list

You can have linked list without lock free list where you insert by using a atomic CAS to swap the next to the new node, if it fails, you start from the beginning.

## Insert:

```c
if(!CAS(&rprevious->next, old_previous_next, new_node)) {
    // abort and retry
}

```

## Delete:

Propoasal 1:

* Tag current->next
    ```
    CCAS(&current->next, current_next, tag(current_next))
    ```

    Use the lower order bits which are always going to be 0 because pointers are byte aligned.
    ```
    ptr = ptr | 1
    ```

    Can't dereference it directly, but first clear the low order bit and then dereference it.
    ```c
    CAS(&prev->next, current, detag(current->next))
    ```

    * We use atomic operations to tag the pointer, which means that it will either succeed or fail.
    * If we are unable to delete the node and the previous->next is changed in the time we tag the cur->next pointer, we have to restart the deletion process from the start and find the tagged pointer and properly delete the node. The remaining threads need to consider the node with the tagged pointer as deleted.

# Delegation approaches

## Combine

Threads are performing modifications of the data structures directly when using locks.

Instead the general idea is to ask another thread to apply changes

* Insert:
  
    ```c
    if(!lock_acquire()) {
        // add work to a todo list instead of a spin loop
        // and wait for work to be finished.
    } else {
        // If we do get the lock, do all the work on the list.
    }
    ```
    
    * The lock is only acquired once. If someone is already doing work, they queue will just keep filling up.
    * representing "work":
        * One way to represent it: `enum OP {insert, delete, find};`
        * Easier is to have a function pointer and arguments
          
            ```c
            bfl_linked_list {
                function pointer, arguments
                return value field;
            }
            ```
            
        * we add our work to the list and we wait on the return value to change.
        * If no one is accessing the data structure no onw is looking for work to do.
        * If it is not a busy data structure, then you always get the lock and will always will have work to do.
        * In a contended data structure, this scheme can be a problem.
        * The main idea is that the critical section for adding to the queue is a very quick operation, but the actual work itself is something which more expensive.

## Dedicated delegation

Only relevant when you have a lot of hardware threads.

```c
struct request {
    ready flag;
    function pointer;
    arguments
} request_array[MAX_THREADS];
```

No atomic operations, and instead you have one server thread which is looping through the array to see if there are potential requests. If there is a response then return the response in the response array.

```c
struct response {
    ready flag;
    long long return value;
} response_array[MAX_THREADS];
```

So the operation could look something like:

```c
for (all requests) {
    if(request->ready) {
        response[request_index] = *f(arguments)
    }
}
```

The benefits are:
* You don't need any atomic operations to do the work and since the server is doing all the work
* It has good cache locality.
* Single threaded operations: no synchronization needed.

And drawback:
* Single-threaded vs potentially parallel access with multiple locks or lock free data structures.

Not a good idea for long critical sections.

So at the end of the day, we have the following operations:

* Lock free with no synchronization only for read only
* One big fat lock
* Reader writer locks: readers can run in parallel
* RCU: read-copy-update: where the readers run lock free but the writers have to be careful to never present an inconsistent data structure and has to use garbage collection in order to remove old values.
* Complete lock freeness: best avoided (here be dragons) but can be extremely fast in certain situations.
    * A Pragmatic Implementation of Non-Blocking linked list: Tim Harris
* Delegation:
    * Combining: nodes volunteer to become the server for a little while
    * Dedicated: have a single thread that is in charge of performing the operations.


# Lock design

* Spinlock
    * CAS repeatedly until successful.
* Waitlock
    * scheduler-mediated
    * Good if you have more threads than the number of hardware threads.


## Naive Test-And-Set (TAS) Spinlocks

Not really good

```c
while(!CAS); // basically a spinlock.
```

If you have a lot of threads waiting on the same lock, many of the CAS's fail.

Acquiring the lock means:
* Get the cacheline for the lock in exclusive mode for your core
* Need to some coordination between the cores to maintain order
* Then you have the cacheline and see that the lock is taken.

Releasing the lock means that you have to get the cacheline back in exclusive mode before you can actually free the lock.

* Continuously lots of contention for the cacheline

## Test-and-Test-and-Set (TTAS) spinlock

```c
while(!CAS) { while(locked); }
```

The read of `locked` is not atomic, so even though the cacheline is shared, the copy of it will be present in the shared cache of all cores in a given socket. When the lock is released, we need to invalidate the cacheline for all the other cores (probably a single broadcast message). Then we have to get the cacheline in exclusive mode for our core and try to lock it.

* lots of contetion after every time the lock is released.

Not really fair. As there is no fairness when it comes to acquiring the cacheline in exclusive mode.


## Ticket lock

* ticket_counter
* wall_counter
* acquire: `my_ticket=atomic_inc(ticket_counter); while(my_ticket != wall_counter)`
* release: `wall_counter++;`

There's only one thread that ever increments the `wall_counter`: the thread that is holding the lock. It's fast as the atomic increments are always going to succeed. There is a performance drawback as the core close to the releasing thread cannot get the lock until `wall_counter` increments to it's `ticket_counter`.

A variant of it is called Heirarchical ticket lock: wait to get a ticket if you far from the lock.

Since all threads are spinning on `ticket_counter` and `wall_counter`, the atomic increment will go slower as it has to wait for all the cachelines across the cores have to be invalidated.
