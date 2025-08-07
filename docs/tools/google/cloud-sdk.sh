#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-x86_64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=google-cloud-sdk
APP_URL=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads
APP_VERSION=355.0.0
APP_ROOT=~/.local/$APP_BIN
APP_SRC=$APP_BIN-$APP_VERSION-$OS_TYPE
APP_PKG=$APP_SRC.tar.gz
APP_URL=$APP_URL/$APP_PKG

check_version() {
    gcloud version
}

clean() {
    rm -f /tmp/$APP_PKG
}

download() {
    if [ ! -f /tmp/$APP_PKG ];
    then
        wget -O /tmp/$APP_PKG $APP_URL
    fi
}

install() {
    mkdir -p ~/.local
    tar -xf /tmp/$APP_PKG -C ~/.local
    sh $APP_ROOT/install.sh --quiet
    sh $APP_ROOT/bin/gcloud -q components update
}

install_linux() {
    download
    install
    clean
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew > /dev/null && brew install --cask $APP_BIN
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
