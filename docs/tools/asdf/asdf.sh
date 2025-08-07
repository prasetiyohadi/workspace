#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_ID=""
[ -f "/etc/os-release" ] && source /etc/os-release && OS_ID=$ID
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-gnu
APP_BIN=asdf
APP_VERSION=0.8.1
APP_URL=https://github.com/asdf-vm/asdf.git
APP_ROOT=~/.$APP_BIN

check_version() {
    $APP_BIN --version
}

install_linux() {
    # install dependencies
    if [ "$OS_ID" == "debian" ] || [ "$OS_ID" == "ubuntu" ] || [ "$OS_ID" == "pop" ]; then
        sudo apt-get update
        sudo apt-get -y install curl dirmngr gawk git gpg
    elif [ "$OS_ID" == "centos" ] || [ "$OS_ID" == "fedora" ]; then
        sudo dnf -y install curl dirmngr gawk git gpg
    fi
    git clone $APP_URL $APP_ROOT --branch v$APP_VERSION
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew > /dev/null && brew install $APP_BIN gpg gawk
}

setup_linux() {
    echo "This script will install $APP_BIN."
    if [ -d "$APP_ROOT" ]; then
        check_version
        read -p "$APP_ROOT already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            rm -rf $APP_ROOT
            install_linux
        else
            echo "Installation cancelled."
        fi
    else
        install_linux
    fi
}

main() {
    if [ "$OS_TYPE" == "$OS_TYPE_DARWIN" ]; then
        setup_darwin
    elif [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
