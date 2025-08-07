#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_ID=""
[ -f "/etc/os-release" ] && source /etc/os-release && OS_ID=$ID
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=linux-gnu
APP_BIN=postgresql
APP_PATH=/usr/bin/$APP_BIN

check_version() {
    $APP_BIN --version
}

install_linux() {
    if [ "$OS_ID" == "debian" ] || [ "$OS_ID" == "ubuntu" ]; then
        sudo apt-get update
        sudo apt-get install -y $APP_BIN $APP_BIN-client
    fi
}

setup_linux() {
    echo "This script will install $APP_BIN."
    if [ -s "$APP_PATH" ]; then
        check_version
        read -p "$APP_PATH already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            install_linux
        else
            echo "Installation cancelled."
        fi
    else
        install_linux
    fi
}

main() {
    if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
