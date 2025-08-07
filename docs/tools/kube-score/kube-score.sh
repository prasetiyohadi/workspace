#!/usr/bin/env bash
set -euo pipefail

# Application details
APP_NAME=score
HAS_KREW="$(type "kubectl-krew" &> /dev/null && echo true || echo false)"

install() {
    kubectl-krew install score
}

main() {
    echo "This script will install $APP_NAME."
    if [ ! "$HAS_KREW" == "true" ]; then
        echo "Install krew first!"
    else
        install
    fi
}

main
