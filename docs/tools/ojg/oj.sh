#!/usr/bin/env bash
set -euo pipefail

# Application details
APP_NAME=oj
HAS_GO="$(type "go" &> /dev/null && echo true || echo false)"

install() {
    go get github.com/ohler55/ojg/cmd/oj
}

main() {
    echo "This script will install $APP_NAME."
    if [ ! "$HAS_GO" == "true" ]; then
        echo "Install go first!"
    else
        install
    fi
}

main
