# Systemd

## Resources limit directives and their equivalent ulimit commands

Directive|ulimit equivalent|Unit
--------------------------------
LimitCPU|ulimit -t|Seconds
LimitFSIZE|ulimit -f|Bytes
LimitDATA|ulimit -d|Bytes
LimitSTACK|ulimit -s|Bytes
LimitCORE|ulimit -c|Bytes
LimitRSS|ulimit -m|Bytes
LimitNOFILE|ulimit -n|Number of File Descriptors
LimitAS|ulimit -v|Bytes
LimitNPROC|ulimit -u|Number of Processes
LimitMEMLOCK|ulimit -l|Bytes
LimitLOCKS|ulimit -x|Number of Locks
LimitSIGPENDING|ulimit -i|Number of Queued Signals
LimitMSGQUEUE|ulimit -q|Bytes
LimitNICE|ulimit -e|Nice Level
LimitRTPRIO|ulimit -r|Realtime Priority
LimitRTTIME|No equivalent|Microseconds
