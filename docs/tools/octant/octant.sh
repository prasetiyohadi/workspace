#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=Linux-64bit
OS_TYPE_LINUX_ARM=Linux-arm
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
[ "$OS_TYPE" == "linux-gnueabihf" ] && export OS_TYPE=$OS_TYPE_LINUX_ARM
APP_BIN=octant
APP_URL=https://github.com/vmware-tanzu/octant/releases/download
APP_VERSION=0.21.0
APP_PATH=~/bin/$APP_BIN
APP_SRC=${APP_BIN}_${APP_VERSION}_${OS_TYPE}
APP_PKG=$APP_SRC.tar.gz
APP_URL=$APP_URL/v$APP_VERSION/$APP_PKG

check_version() {
    $APP_BIN version
}

clean() {
    rm -r /tmp/$APP_SRC
}

download() {
    curl -L $APP_URL | tar -zx -C /tmp
}

install() {
    mkdir -p ~/bin
    mv /tmp/$APP_SRC/$APP_BIN ~/bin
}

install_linux() {
    download
    install
    clean
}

setup_darwin() {
    echo "This script will install $APP_BIN version $APP_VERSION using brew."
    command -v brew > /dev/null && brew install $APP_BIN
}

setup_linux() {
    echo "This script will install $APP_BIN version $APP_VERSION."
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
    if [ "$OS_TYPE" == "$OS_TYPE_DARWIN" ]; then
        setup_darwin
    elif [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ] || \
        [ "$OS_TYPE" == "$OS_TYPE_LINUX_ARM" ]; then
        setup_linux
    fi
}

main
