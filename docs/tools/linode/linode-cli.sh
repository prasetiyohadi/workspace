#!/usr/bin/env bash
set -euo pipefail

# Application details
APP_BIN=linode-cli
HAS_PIP="$(type "pip" &> /dev/null && echo true || echo false)"
HAS_PYENV="$(type "pyenv" &> /dev/null && echo true || echo false)"

install() {
    pip install -U pip
    pip install $APP_BIN
}

install_as_user() {
    pip install -U --user pip
    pip install --user $APP_BIN
}

main() {
    echo "This script will install $APP_BIN using pip."
    if [ ! "$HAS_PIP" == "true" ]; then
        echo "Install pip first!"
    elif [ ! "$HAS_PYENV" == "true" ]; then
        install_as_user
    else
        install
    fi
}

main
