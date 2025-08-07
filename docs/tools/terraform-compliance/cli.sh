#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=linux-gnu
APP_BIN=terraform-compliance
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

setup_linux() {
    echo "This script will install $APP_BIN using pip."
    if [ ! "$HAS_PIP" == "true" ]; then
        echo "Install pip first!"
    elif [ ! "$HAS_PYENV" == "true" ]; then
        install_as_user
    else
        install
    fi
}

main() {
    if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
