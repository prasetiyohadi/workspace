#!/usr/bin/env bash
set -euo pipefail

# Fix error `xdg-open` not found when login using `--sso` flag
sudo ln -s $(which wslview) /usr/local/bin/xdg-open
