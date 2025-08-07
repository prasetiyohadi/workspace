# Cgroups

`/sys/fs/cgroups`

## Fundamental concepts

Reference: [A Linux sysadmin's introduction to cgroups][1]

Cgroups are a facility built into the kernel that allow the administrator to
set resource utilization limits on any process on the system. In general,
cgroups control:
* The number of CPU shares per process
* The limits on memory per process
* Block Device I/O per process
* Which network packets are identified as the same type so that another
application can enforce network traffic rules

Control groups (cgroups) are a Linux Kernel mechanism for fine-grained
control of resources. Originally put forward by Google engineers in 2006,
cgroups were eventually merged into the Linux kernel around 2007. There are
currently two versions of cgroups, most distributions and mechanisms use
version 1 since 2.6.24 with slow adoption rate, version 2 also has slow
adoption rate.

The important features of cgroups:
* Resource limiting (CPU, RAM, block device I/O, device groups)
* Prioritization
* Accounting
* Process control (_freezer_ facility)

Using the features of cgroups, a system administrator can have these
benefits
* Achieve greater density on a single server by carefully managing the type
of workload, the applications, and the resource that they require,
* Enhance security by imposing restrictions by default,
* Do significant amount of performance tuning through cgroups.

Most technology such as Kubernetes, OpenShift, Docker, and so on still rely
on cgroups version 1 while version 2 is available in RHEL 8 but disabled by
default.

Cgroups are a mechanism for controlling certain subsystems in the kernel.
These subsystems, such as devices, CPU, RAM, network access, and so on, are
called _controllers_ in the cgroup terminology. Each type of controller
(cpu, blkio, memory, etc) is subdivided into a tree-like structure. Each
branch or leaf has its own weights or limits. A control group has multiple
processes associated with it, making resource utilization granular and easy
to fine-tune. Each child inherits and is restricted by the limits set on
the parent cgroup.

## [TODO]Examine CPUShare

Reference: [How to manage cgroups with CPUShares][2]

## [TODO]Doing cgroups the hardway

Reference: [Managing cgroups the hard way-manually][3]

## [TODO]Cgroups as managed by systemd

Reference: [Managing cgroups with systemd][4]

[1]: https://www.redhat.com/sysadmin/cgroups-part-one
[2]: https://www.redhat.com/sysadmin/cgroups-part-two
[3]: https://www.redhat.com/sysadmin/cgroups-part-three
[4]: https://www.redhat.com/sysadmin/cgroups-part-four
