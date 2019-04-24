---
title: Qemu
subtitle: >
    a pretty cool emulator
---

To set up a tap backend, you need root permissions as qmeu needs to configure `dev/net/tun`


Looks like each virtio capability is actually the cap + any additional fields that might be required. Only the CFG_PCI_CAP has special handling due to the way it is setup. All the other memory regions are set up in `virtio_pci_modern_regions_init` which itself is called from `virtio_pci_device_plugged`.

So question:

* Why isn't my memory region read not working.
* Why isn't my io region read not working.

I checked the status and command registers and see the appropriate bits are toggled in order to perform these operations.


## 4.1.4.7 PCI configuration access capability

In this section, there is a mention of `pci_cfg_data` providing a windo into the BAR. It is exactly that. You specify which bar you want to read, and the bars themselves will have differnt data in it. For example, virtio devices will have the common config in bar 4 (the modern 64 bit bar). Therefore, when you write cap.bar = 4 and cap.offset = 4 and cap.length = 4, that translates to give me 4 bytes from offset 0 in the common bar, which in this case will be the device feature select.

no wonder is it sub optimal, because it's so roundabout.


The reason why I am always hitting `virtio_read_config` is because I am accessing data through the PCI config space. I need to access it through the memory space or IO space. But when I try to read from the addresses given to me my qemu the accessor functions are not being called. In fact nothing is being called.


## Networking

A TAP interface is basically a way to get raw ethernet frames from the kernel in userspace. This is what qemu is uisng in order to emulate the network deice backend.

A TUN interface is similar except, the ethernet headers are removed.
