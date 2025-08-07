#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
APP_VERSION=3.0.79
OS_TYPE_DARWIN="macosx-$APP_VERSION-amd64"
OS_TYPE_LINUX_AMD64="linux-$APP_VERSION-amd64"
[ "$OS_TYPE" == "darwin" ] && export OS_TYPE=$OS_TYPE_DARWIN
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=aliyun
APP_PATH=~/bin/$APP_BIN
APP_SRC="$APP_BIN-cli-$OS_TYPE"
APP_PKG="$APP_SRC.tgz"
APP_URL="https://aliyuncli.alicdn.com/$APP_PKG"

check_version() {
    $APP_BIN version
}

clean() {
    rm -f "/tmp/$APP_PKG"
}

download() {
    wget -O "/tmp/$APP_PKG" "$APP_URL"
}

install() {
    mkdir -p ~/bin
    tar -xf "/tmp/$APP_PKG" -C ~/bin
}

install_linux() {
    download
    install
    clean
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew > /dev/null && brew install $APP_BIN-cli
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
    elif [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
