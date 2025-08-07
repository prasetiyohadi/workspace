#!/usr/bin/env bash
set -euo pipefail

# Start containerd
sudo echo -n
sudo containerd &
sudo chgrp "$(id -gn)" /run/containerd/containerd.sock
