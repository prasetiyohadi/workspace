#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_ID=""
[ -f "/etc/os-release" ] && source /etc/os-release && OS_ID=$ID
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-gnu
APP_BIN=pyenv
APP_ROOT=~/.pyenv

check_version() {
    $APP_BIN --version
}

install_linux() {
    if [ "$OS_ID" == "debian" ] || [ "$OS_ID" == "ubuntu" ] || [ "$OS_ID" == "pop" ]; then
        sudo apt-get update
        sudo apt-get install --no-install-recommends --no-install-suggests \
            -y build-essential libssl-dev zlib1g-dev libbz2-dev \
            libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
            libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev \
            python3-openssl git
    elif [ "$OS_ID" == "fedora" ]; then
        sudo dnf install make gcc zlib-devel bzip2 bzip2-devel \
            readline-devel sqlite sqlite-devel openssl-devel tk-devel \
            libffi-devel xz-devel

    elif [ "$OS_ID" == "centos" ]; then
        sudo yum install @development zlib-devel bzip2 bzip2-devel \
            readline-devel sqlite sqlite-devel openssl-devel xz xz-devel \
            libffi-devel findutils
    fi
    curl https://pyenv.run | bash
    exec "$SHELL"
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew > /dev/null && brew install $APP_BIN readline xz
}

setup_linux() {
    echo "This script will install $APP_BIN."
    if [ -d "$APP_ROOT" ]; then
        check_version
        read -p "$APP_ROOT already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            rm -fr $APP_ROOT
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
