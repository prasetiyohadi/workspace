#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=mac64
OS_TYPE_LINUX_AMD64=linux-x86_64
OS_TYPE_LINUX_ARM=linux-armv7l
[ "$OS_TYPE" == "darwin" ] && export OS_TYPE=$OS_TYPE_DARWIN
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
[ "$OS_TYPE" == "linux-gnueabihf" ] && export OS_TYPE=$OS_TYPE_LINUX_ARM
APP_BIN=julia
APP_MAJOR_VERSION=1.6
APP_VERSION=1.6.1
APP_SRC=$APP_BIN-$APP_VERSION-$OS_TYPE
APP_URL=https://julialang-s3.julialang.org/bin
[ "$OS_TYPE" == "$OS_TYPE_DARWIN" ] \
    && export APP_PKG=$APP_SRC.dmg APP_URL=$APP_URL/mac/x64
[ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ] \
    && export APP_PKG=$APP_SRC.tar.gz APP_URL=$APP_URL/linux/x64
[ "$OS_TYPE" == "$OS_TYPE_LINUX_ARM" ] \
    && export APP_PKG=$APP_SRC.tar.gz APP_URL=$APP_URL/linux/armv7l
APP_URL=$APP_URL/$APP_MAJOR_VERSION/$APP_PKG
APP_ROOT=~/.local/julia

check_version() {
    $APP_BIN --version
}

install_linux() {
    mkdir -p ~/.local
    wget -O - $APP_URL | tar -C ~/.local -zxf -
    mv ~/.local/$APP_BIN-$APP_VERSION ~/.local/$APP_BIN
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew > /dev/null && brew install $APP_BIN
}

setup_linux() {
    echo "This script will install $APP_BIN version $APP_VERSION."
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
    if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ] \
        || [ "$OS_TYPE" == "$OS_TYPE_LINUX_ARM" ]; then
        setup_linux
    elif [ "$OS_TYPE" == "$OS_TYPE_DARWIN" ]; then
        setup_darwin
    fi
}

main
