#!/usr/bin/env bash
set -euo pipefail

# Application details
APP_BIN=ansible
HAS_PIP="$(type "pip" &> /dev/null && echo true || echo false)"
HAS_PYENV="$(type "pyenv" &> /dev/null && echo true || echo false)"

install() {
    pip install -U pip wheel
    pip install $APP_BIN paramiko
}

install_as_user() {
    pip install -U --user pip wheel
    pip install --user $APP_BIN paramiko
}

main() {
    echo "This script will install $APP_BIN."
    if [ ! "$HAS_PIP" == "true" ]; then
        echo "Install pip first!"
    elif [ ! "$HAS_PYENV" == "true" ]; then
        install_as_user
    else
        install
    fi
}

main
