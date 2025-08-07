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
APP_BIN=vcluster
APP_URL=https://github.com/loft-sh/vcluster/releases/latest
APP_VERSION=latest
APP_PATH=~/bin/$APP_BIN

check_version() {
    $APP_BIN --version
}

install() {
    mkdir -p ~/bin
    curl -s -L "$APP_URL" |\
        sed -nE "s|.*\"([^\"]*$APP_BIN-$OS_TYPE)\".*|https://github.com\1|p" |\
        xargs -n 1 curl -L -o $APP_PATH
    chmod +x $APP_PATH
}

setup() {
    echo "This script will install $APP_BIN version $APP_VERSION."
    if [ -s "$APP_PATH" ]; then
        check_version
        read -p "$APP_PATH already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            install
        else
            echo "Installation cancelled."
        fi
    else
        install
    fi
}

main() {
    if [ "$OS_TYPE" == "$OS_TYPE_DARWIN_AMD64" ] || \
        [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ] || \
        [ "$OS_TYPE" == "$OS_TYPE_LINUX_ARM" ]; then
        setup
    fi
}

main
