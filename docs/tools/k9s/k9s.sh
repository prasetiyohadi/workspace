#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=Linux_x86_64
OS_TYPE_LINUX_ARM=Linux_arm
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
[ "$OS_TYPE" == "linux-gnueabihf" ] && export OS_TYPE=$OS_TYPE_LINUX_ARM
APP_BIN=k9s
APP_URL=https://github.com/derailed/k9s/releases/download
APP_VERSION=0.24.10
APP_PATH=~/bin/$APP_BIN
APP_SRC=${APP_BIN}_v${APP_VERSION}_${OS_TYPE}
APP_PKG=$APP_SRC.tar.gz
APP_URL=$APP_URL/v$APP_VERSION/$APP_PKG

check_version() {
    $APP_BIN version
}

clean() {
    rm -r /tmp/$APP_SRC
}

download() {
    mkdir -p /tmp/$APP_SRC
    wget -O - $APP_URL | tar -C /tmp/$APP_SRC -zxf -
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
    echo "This script will install $APP_BIN using brew."
    command -v brew > /dev/null && brew install derailed/$APP_BIN/$APP_BIN
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
