#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN_AMD64=darwin-amd64
OS_TYPE_LINUX_AMD64=linux-amd64
OS_TYPE_LINUX_ARM=linux-arm64
[ "$OS_TYPE" == "darwin" ] && export OS_TYPE=$OS_TYPE_DARWIN_AMD64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
[ "$OS_TYPE" == "linux-gnueabihf" ] && export OS_TYPE=$OS_TYPE_LINUX_ARM
APP_BIN=infracost
APP_URL=https://github.com/infracost/infracost/releases/download
APP_VERSION=0.10.3
APP_PATH=~/bin/$APP_BIN
APP_SRC=${APP_BIN}-${OS_TYPE}
APP_PKG=$APP_SRC.tar.gz
APP_URL=$APP_URL/v$APP_VERSION/$APP_PKG

check_version() {
    $APP_BIN version
}

clean() {
    rm /tmp/$APP_PKG /tmp/$APP_PKG.sha256 /tmp/$APP_PKG.sum
}

download() {
    wget -O /tmp/$APP_PKG $APP_URL
    wget -O /tmp/$APP_PKG.sha256 $APP_URL.sha256
    echo "$(awk '{print $1}' /tmp/$APP_PKG.sha256)" /tmp/$APP_PKG >/tmp/$APP_PKG.sum
    sha256sum -c /tmp/$APP_PKG.sum
}

install() {
    mkdir -p ~/bin
    tar -C ~/bin --transform="s/-$OS_TYPE//g" -zxf /tmp/$APP_PKG $APP_SRC
}

install_linux() {
    download
    install
    clean
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew >/dev/null && brew install infracost
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
    if [ "$OS_TYPE" == "$OS_TYPE_DARWIN_AMD64" ]; then
        setup_darwin
    elif [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ] ||
        [ "$OS_TYPE" == "$OS_TYPE_LINUX_ARM" ]; then
        setup_linux
    fi
}

main
