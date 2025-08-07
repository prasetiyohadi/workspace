#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=Linux-x86_64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=hadolint
APP_URL=https://github.com/hadolint/hadolint/releases/download
APP_VERSION=2.5.0
APP_PATH=~/bin/$APP_BIN
APP_SRC=$APP_BIN-$OS_TYPE
APP_URL=$APP_URL/v$APP_VERSION/$APP_SRC

check_version() {
    $APP_BIN --version
}

download() {
    wget -O /tmp/$APP_SRC $APP_URL
}

install() {
    mkdir -p ~/bin
    mv /tmp/$APP_SRC $APP_PATH
    chmod +x $APP_PATH
}

install_linux() {
    download
    install
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
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
    elif [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
