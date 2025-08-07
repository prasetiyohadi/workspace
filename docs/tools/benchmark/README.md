# Benchmark

Multiple benchmark methods

## FIO

Disk benchmarking ([source](https://docs.microsoft.com/en-us/azure/virtual-machines/disks-benchmarks#fio))

* Maximum write IOPS `sudo fio --runtime 30 fiowrite.ini`
* Maximum read IOPS `sudo fio --runtime 30 fioread.ini`
* Maximum read and write IOPS `sudo fio --runtime 30 fioreadwrite.ini`
