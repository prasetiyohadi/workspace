#!/usr/bin/env bash
set -euo pipefail

sudo echo -n
sudo "$(which buildkitd)" &
