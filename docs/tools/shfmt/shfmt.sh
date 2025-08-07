#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=macos
OS_TYPE_LINUX_AMD64=linux_amd64
[ "$OS_TYPE" == "darwin" ] && export OS_TYPE=$OS_TYPE_DARWIN
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=shfmt
APP_URL=https://github.com/mvdan/sh/releases/download
APP_VERSION=3.3.1
APP_PATH=~/bin/$APP_BIN
APP_SRC=${APP_BIN}_v${APP_VERSION}_${OS_TYPE}
APP_URL=$APP_URL/v$APP_VERSION/$APP_SRC

check_version() {
    $APP_BIN --version
}

install() {
    mkdir -p ~/bin
    wget -O $APP_PATH $APP_URL
    chmod +x $APP_PATH
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew >/dev/null && brew install $APP_BIN
}

setup_linux() {
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
    if [ "$OS_TYPE" == "$OS_TYPE_DARWIN" ]; then
        setup_darwin
    elif [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
