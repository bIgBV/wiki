---
title: Notes on Virito
subtitle: >
	Things I learnt while reading the amazing spec: http://docs.oasis-open.org/virtio/virtio/v1.0/cs04/virtio-v1.0-cs04.html#x1-20001
---

# Notes:

 `u8, u16, u32, u64`
     An unsigned integer of the specified length in bits.
 `le16, le32, le64`
	 An unsigned integer of the specified length in bits, in little-endian byte order.
 `be16, be32, be64`
	 An unsigned integer of the specified length in bits, in big-endian byte order.


# Basic facilities of a Virtio device:
* Device status field
* Feature bits
* Device config space
* virtqueue(s)


## Device status field:

* Used during device initialization by driver.
* Provides a simple low-level indication of the completed steps of this sequence

`ACKNOWLEGE`: 1

Guest OS has found the device and recognizes it as a valid virtio device.

`DRIVER`: 2

Guest OS knows how to drive device

`FAILED`: 128

Something went wrong.

`FEATURES_OK`: 8

Driver has acknowledged and negotiated all it's features.

`DRIVER_OK`: 4

Driver ready to run

`DEVICE_NEEDS_RESET`: 64

Device stuck on an unrecoverable error.

### Device status field: Driver requirements:

**MUST** update device sstatus to indicate completion of initialization sequence completion

**MUST NOT** clear the status bit

If the driver sets the **FAILED** bit then it must reset the deivice before trying to re-initialize

**SHOULD NOT** rely on request completion if `DEVICE_NEEDS_RESET` is set.


## Feature bits

During initialization driver reads all the features the device provides and tells the device the featurs that it understands. The only way to renegotiate is to reset the device.

Feature bits are allocated with backwards and forwards compatibility in mind

`0-23`:

Bits for specific device types

`24-32`:

Bits reserved for extentions to the queue and feature negotiation mechanisms


`33+`:

Reserved for future extentions

For example, the bit 0 for a network device (Device ID 1 ) being set means that the device supports checksumming.


### Driver requirements: Feature bits

** *MUST NOT** accept a feature which wasn't offered.
* **MUST NOT** Accept a feature which depends on another feature which was not accepted.
* **SHOULD** go into backwards compatibility mode(what's this?) if the device doesn't offer a feature it wants, or else, **MUST** set the `FAILED` bit and stop


## Device config space

Used for rarely-used initialization time parameters. When config fields are optional their existence is indicated by feature bits.

### Note:

Uses little endian byte order for  multi-byte fields


### Driver requirements: Device config space

* **MUST NOT** assume reads from fields > 32 bits and multi-byte filds are atomic
* **SHOULD** read the config space fields like so:

    ```
    u32 before, after;
    do {
            before = get_config_generation(device);
            // read config entry/entries.
            after = get_config_generation(device);
    } while (after != before);
    ```
    For optional config space fields, the driver **MUST** check the feature bits to see if the feature is offered.

* Drivers MUST NOT limit structure size and device configuration space size.
Instead, drivers SHOULD only check that device configuration space is large
enough to contain the fields necessary for device operation. Note: For example,
if the specification states that device configuration space ’includes a single
8-bit field’ drivers should understand this to mean that the device
configuration space might also include an arbitrary amount of tail padding, and
accept any device configuration space size equal to or greater than the
specified 8-bit size

## Virtual queues

* Each device can have 0 or more virtqueues.
* Main form of bulk data transport between device and driver

Each virtqueue consists of three major parts:

* Descriptor table
* Available ring
* Used ring

Each part is physically contiguous in guest memory.

Virtqueue part      Alignment   Size
------------------ ----------- --------------------
Descriptor Table   16          16 * (Queue size)
Available Ring     2           6 + 2 * (Queue size)
Used Ring          4           6 + 8 * (Queue size)


Alignment column is the minimum alignment for each part of the queue. And the size part gives the total number of bytes for each part of the virtqueue.

Queue size is the maximum number of buffers in the virtqueue. It is always power of 2. Maximum queue size is 32678.

When the driver wants to send a buffer to the device, it fills a slot in the descriptor table and puts its index in the available ring and lets the device know. Once the device has filled a buffer it updates its index in the used ring and sends an interrupt to notify the driver of the change


### Driver requirements: Virtqueues

Driver **MUST** ensure that the physical address of the first byte of each virtqueue part is a multiple of the specified alignment value in the above table.

* **Message framing**:

	Framing of messages with the descriptors is separate from the contents of the buffers. For example, you can put the 12 bytes of a ethernet packet in it's own descriptor and the 1514 bytes of the data in a separate descriptor, or but the whole 1526 bytes in the same descriptor or even multiple packets.

	**MUST** place any device writable descriptors after any device-readable descriptor elements.

	**SHOULD NOT** use an execessive number of desciptors to describe a buffer.

### Virtqueue Descriptor table

This table refers to the buffers the driver is using for the device. This looks a little something like this:

```
struct virtq_desc {
	/* Guest physical address */
	le64 addr;
	/* Length */
    le32 len;

	/* This marks a buffer as continuing via the next field
	#define VIRTQ_DESC_F_NEXT 1

	/* This marks a buffer as device write-only (otherwise device read-only) */
	#define VIRTQ_DESC_F_WRITE 2

	/* This means the buffer contains a list of buffer descriptors */
	#define VIRTQ_DESC_F_INDIRECT 4

	le16 flags;

	/* Next field if flags & NEXT */
	le16 next;
}
```

`addr` is guest physical address and buffers can be chained via `next`. Each desciptor describes a buffer which by default is read-only (device readable) or write-only (device-writable) but a chain of descriptors can contain both.

Most common approach is to begin data with a header for the device to read and postfix it with staus for the device to write to.


* **Driver requirements: Virtqueue descriptor table**

	Drivers **MUST NOT** add a descriptor chain over than 232 bytes long in total; this implies that loops in the descriptor chain are forbidden!


### Virtqueue Available Rings

```
struct virtq_avail {
	#define VIRTQ_AVAIL_F_NO_INTERRUPT 1
	le16 flags;
	le idx;
	le16 ring [/* Queue size /*];
	le16 used_event; /* only if  VIRTIO_F_EVENT_IDX */
}

```

Driver uses avaialble ring to notify the device of the buffers it needs to process. Each ring entyry refers to a descriptor chain, and is only written by the driver and read by the device.

### Virtqueue Interrupt Suppression

If the `VIRTIO_F_EVENT_IDX` feature is not negotiated then the `flags` field in the available ring offers a low resolution way for the driver to inform the device that it doesn't want interrupts when buffers are used.

`used_event` is a way better alternative since it is more performant.

If the VIRTIO_F_EVENT_IDX feature bit is not negotiated:

* The driver **MUST** set flags to 0 or 1.
* The driver **MAY** set flags to 1 to advise the device that interrupts are not needed.

Otherwise, if the `VIRTIO_F_EVENT_IDX` feature bit is negotiated:

* The driver **MUST** set flags to 0.
* The driver **MAY** use used_event to advise the device that interrupts are unnecessary until the device writes entry with an index specified by used_event into the used ring (equivalently, until idx in the used ring will reach the value used_event + 1).

The driver **MUST** handle spurious interrupts from the device.

### Virtqueue Used Ring

```
struct virtq_used {
	#define VIRTQ_F_NO_NOTIFY 1
	le16 flags;
	le16 idx;
	struct virtq_used_elem ring[/* Queue size */];
	le16 avail_event; /* Only if VIRTIO_F_EVENT_IDX */
}

/* le32 is used for ids for padding reasons */
struct virtq_used_elems {
	/* INdex of start of used descriptor chain */
	le32 id;

	/* Total length of the descriptor chain which was used (written to) */
	le32 len;
}
```

This is where the device returns the buffers it used to the driver, only written to by the device and read by the driver.

Each entry in the ring is a pair where the `id` is the index into the ring and the `len` is the number of bytes written. This can be useful to zero out buffers before hand so that information is not leaked from using free'd memory.


* **Driver requirements: The Virtqueue Used Ring**

	The driver **MUST NOT** make any assumptions about the data in device writable buffers past the first `len` bytes and instead **should** ignore this data.


Reference code for virtqueue implementation can be found [here][virt_queue.h]

# Device initialization

The driver **MUST** follow the following steps to initialize the device:

1. Reset the device
2. Set the `ACKNOWLEDGE` bit - means the guest OS has found the device.
3. Set the `DRIVER` status bit - guest OS knows how to drive the device.
4. Read the fetaure bits and write the features that the driver understands. The driver **MAY** read device specific config based on the feature bits, but **SHOULD NOT** write write anything.
5. Set the `FEATURES_OK` status bit once the feature negotiation is done.
6. Re-read the status bit to see if the `FEATURES_OK` bit is still set. If it isn't, the device doesn't support some of the requested features.
7. Perform device specific setup including discovery of virtual queues, reading and possibly writing to the device config space.
8. Set the `DRIVER_OK` status bit to indicate that the driver is ready.

If any of these steps fail, the driver **SHOULD** set the `FAILED` status bit. The driver **MUST NOT** notify the device before setting `DRIVER_OK`.


# Device Operation

Two major parts: supplying new buffers to the device and processing used buffers. For example, the simplest virtio network device has two virtqueues: The transmit queue and the receive virtqueue. The driver adds outgoing (device-readable) packets to the transmit queue and then frees them after they are used. Similarly, incomin (device-writable) buffers are added to the receive virtqueue and procesed after they are used. Meaning they are put in the available ring and once the driver fills them, and indicatees as such by putting their indecies in the used queue.


## Device opeeration: Supplying buffers to the device

The driver offers buffers to one of the devices virtqueues as follows:

1. The driver places the buffer into a free descriptor(s) in the descriptor table, chaining them if necessary.
2. The driver places index of the head of the descriptor chain into the next ring entry in the available ring
3. Steps 1 & 2 **MAY** be performed repeatedly if batching is possible
4. The driver performs suitable memory barrier to ensure that the device sees the updated descriptor table and the available ring before the next step
5. The available `idx` is increased by the number of descriptor chain heads have been added to the available ring.
6. The driver performs suitable memory barrier to ensure that the updates to `idx` field happen before checking for the notification suppression
7. If notifications are not suppressed, the driver notifies the device of the new available buffers.

The maximum queue size is 32768

General algorithm for adding items to the descriptor table:

```
for each buffer element b:
    find next free descriptor table entry: d
    set d.addr to the guest physical address of the start of b
    set d.len to len(b)
    if b is device writable:
        d.flags & VIRTQ_DESC_F_WRITE
    else d.flags = 0

    if there is a buffer element after this:
        set d.next to the index of the next free descriptor element.
        d.flags & VIRTQ_DESC_F_NEXT
```

Once the elements have been added, we need ot update the avaialbe ring by pointing the relevant index into the ring to the head of the chain, that is the first buffer element

```
avail->ring[avail->idx % qsize] = head
```
or

```
avail->ring[(avail->idx + added++) % qsize] = head
```
to add multiple descriptor entries at the same time as adding entries to the descriptor table.

`idx` always increments and wraps around after 65536

The driver **MUST** use suitable memory barriers before the `idx` update to ensure the device sees the most up-to-date copy.

### Receiving used buffers from the device

```c
virtq_disable_interrupts(vq);

for (;;) {
        if (vq->last_seen_used != le16_to_cpu(virtq->used.idx)) {
                virtq_enable_interrupts(vq);
                mb();

                if (vq->last_seen_used != le16_to_cpu(virtq->used.idx))
                        break;

                virtq_disable_interrupts(vq);
        }

        struct virtq_used_elem *e = virtq.used->ring[vq->last_seen_used%vsz];
        process_buffer(e);
        vq->last_seen_used++;
}
```




[virt_queue.h]: http://docs.oasis-open.org/virtio/virtio/v1.0/cs04/virtio-v1.0-cs04.html#x1-310000A
