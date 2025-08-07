#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=linux-gnu

install() {
    echo "deb http://ftp.debian.org/debian $(lsb_release -sc)-backports main" \
        | sudo tee /etc/apt/sources.list.d/backports.list
    sudo apt update
}

setup() {
    if [ -f /etc/debian_version ]; then
        install
    fi
}

main() {
    echo "This script will install debian $(lsb_release -sc) backports repositories."
    if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        if [ -s "/etc/apt/sources.list.d/backports.list" ]; then
            read -p "/etc/apt/sources.list.d/backports.list already exists. Replace[yn]? " -n 1 -r
            echo
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                setup
            else
                echo "Installation cancelled."
            fi
        else
            setup
        fi
    fi
}

main
