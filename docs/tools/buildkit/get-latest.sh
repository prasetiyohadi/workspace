#!/usr/bin/env bash
set -euo pipefail

DEFAULT_URL=https://github.com/moby/buildkit.git
GITHUB_URL=${1:-$DEFAULT_URL}

LATEST=$(git -c 'versionsort.suffix=-' ls-remote --refs --tags --sort='v:refname' "$GITHUB_URL" | tail --lines=1 | cut --delimiter='/' --fields=3)
echo "${LATEST#v}"
