#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux_x64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=nim
APP_VERSION=1.4.8
APP_ROOT=~/.local/$APP_BIN
APP_SRC=$APP_BIN-$APP_VERSION-$OS_TYPE
APP_PKG=$APP_SRC.tar.xz
APP_URL=https://nim-lang.org/download/$APP_PKG

check_version() {
    $APP_BIN --version
}

clean() {
    rm /tmp/$APP_PKG /tmp/$APP_PKG.sha256 /tmp/$APP_BIN.sum
}

download() {
    wget -O /tmp/$APP_PKG $APP_URL
    wget -O /tmp/$APP_PKG.sha256 $APP_URL.sha256
}

install() {
    echo "$(awk '{print $1}' /tmp/$APP_PKG.sha256) /tmp/$APP_PKG" \
        > /tmp/$APP_BIN.sum
    sha256sum -c /tmp/$APP_BIN.sum
    tar -xf /tmp/$APP_PKG -C /tmp
    mkdir -p ~/.local
    mv /tmp/$APP_BIN-$APP_VERSION $APP_ROOT
    export PATH=$PATH:$APP_ROOT/bin:$HOME/.nimble/bin
}

install_linux() {
    download
    install
    clean
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
