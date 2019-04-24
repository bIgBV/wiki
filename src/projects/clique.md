> Clique is a rust implementation of distributed membership protocols


# General notes

# SWIM

# Lifeguard

# Stable and Consistent Membership at Scale with Rapid

## Abstract and introduction

* Mulit-process cut detection:
    * suspect failure only after alerts arrive from multiple sources
    * When a group experiences problems, it detects failures in the entire group.
* Uses a leaderless consensus protocol.
* Claim is that failures are common at scale, and generally occur due to mis-configured firewalls, connectivity losses and random packet drops.
* *Expander-based monitoring edge overlay*:
    * A set of processes: a `Configuration`
    * `Configuration` organized into failure detection topology with `observers` monitoring about their communications across `edges` to their `subjects`.
    * This forms a directed graph with strong connectivity.
* M*ulti-process cut detection*: detects a multi-node cut (group) of processes who are faulty and uses _almost everywhere agreement_.
* *Practical consensus*: leaderless consensus where every process checks the number of identical cut detections, if there s a quorum of 3/4ths of the nodes, then without a leader or any communication then this is considered as a consensus decision.
* Akka cluster seems to be the most inonsistent, not being able to handle more than 500 nodes, and has a lot of false positives when 1% of the nodes suffer high packet loss.
* Memberlist and zookeeper seem to be unstable over time, but not as bad as Akka cluster.

## The Rapid service

* *API*: `join(addr, seeds, view-change-callback)`, `addr` is TCP address. Creates a rapid internal `ID` which changes if the same process leaves and joins again.
* *Configuration*: config id and a membership-set. All nodes have a local view and start with the seed-list as the initial configuration.
* *Failure model*: Each process is monitored by `K` observers, and if `L` out of them cannot communicate with the process, then it is considered as failed.
* *Cut detection guarantees*: it can handle upto `F` processes out of `C` being faulty when `|F/C| < 1/2``
* Every process in the non-faulty group receives a notification about `F`.
* Every process isnotified when a set of non faulty nodes join.
* These hold when the system is stable, when unstability is present, it might not be the case.
* See Figure 3 for a pretty good overview of how this works.

## Decentralized design

* immutable sequence of configuration changes.
* So the one thing is, the reason for swim and consequently lifeguard was the idea that failure detection should be a low overhead process. With the way rapid seems to be designed, this doesn't seem to be the case. When everyone is observing everyone else, there is going to be a lot of network traffic related to configuration changes.Sure, the consensus is achieved without a leader, but the health checks would be pretty expensive. I wonder if they consider this.
* Each process monitors `K` peers and is monitored by `K` peers.
* Each process when receving a notification, locally determines its subjects and creates the channels.
* Two types of alerts (notification): `join` and `remove`.
* Every node uses these alerts as a part of the multi process cut detection mechanism.


### Expander based monitoring

* `K` pseudo-randomly constructed rings where each ring contains all the members.
* Duplicate edges are allowed.
* *Topology properties* : each process has `K` observers and observs `K` subjects. This means that the overall monitoring overhead is `O(K)`, which is awesome.
* If you have a set `V` processes out of which `F` are faulty, you have `(V - F)/F` edges going from `V/F` (`V` cut `F`) to `F` meaning that you can detect failure consistently.

*So I understand how locally, a process can see which of it's subjects isn't working, but how is this information spread globally without a gossip mechanism?*
Through multi process cut detection. Alerts are broadcast and each nodes performs cut detection.

* Newly joining nodes get a list of `K` temporary observers who generaly independant alerts about the new nodes until the configuration change reflects the new nodes.
* Monitoring edges are pluggable.
* Remove alerts are irrevocable.

### Multi-process Cut detection

* Alerts are aggregated at each node and each node independantly comes to agreement based on the counts of the alerts. It waits until no process' alert count is above a low watermark (L) and below a high watermark (H) threshold.
* The state is reset after each configuration change.
* Each process injects boadcast alerts by observers about their subject edges.
* Remove can only about nodes in `C`. It indicates that the edge to it's subject is faulty.
* Join can only be about new nodes. It indicates that a new edge is to be created.
* Every process `p` maintains a set of observer node relationships `M(o, s)`, if an alert is received for this edge, it sets `M(o, s) = 1`, it is 0 by default. To tally distinct alerts, it's the sum of all `M(*, s)`.
* If the tally of a process is < L it is considered noise. If it is L < tally < H it is considered unstable, and if it is > H it is considered stable.
* *Aggregation* :
    * Each process follows the rule _delay proposing config change until at least one stable process and there are no unstable processes_.
    * Once this happens, a config change is proposed consisting of all the processes in stable mode.
    * See Figure 4
* *Ensuring liveness* :
    * Two cases when a subject node cannot get enough observer reports:
        * When the observer itself is unstable, in this case both the observer and the subject will be in the unstable set and an implicit alert is generated. `Remove` is the observer is in `C`, `Join` otherwise.
        * When the subject has a good connection to some observers and a bad connection to others. In this case, is `s` has been in unstable mode for a certain timeout, each observer reinforces the detection. If an `o` of `s` didn't already send a `Remove` it broadcasts them now. This means that those observers reporting `s` as non-faulty now report it as faulty.


### View change agreement.

* Each processes config change protocol is put in a consensus algorithm to drive agreement.
* Fast paxos is used for the simple case:
    * If > 3/4 of the set have the same proposal it is accepted.
* Given the almost everywhere nature of the cut detection scheme, this is usually true.
* The counting protocol uses gossip to disseminate a bitmap of votes for each proposal
* As soon as a process has a proposal for which >= 3/4 has voted, it accepts it.
* If this doesn't happen due to conflicting proposals or a timeout, rapid falls back to classical paxos to drive consensus.
* Rapid separates out the majority during a partition. The minority are logically separate. This is explicit and the minority might want to join the majority and applications can decide how this has to provceed.

## Logically centralized design

* A set of auxiliary nodes `S` records membership changes.
* Nodes in `C` continue to monitor each other using the k-ring topology, and instead of gossipping alerts within themselves, report to set `S`
* nodes in S apply cut detection, and execute view change internally.
* Nodes in `C` learn about these changes through S.
