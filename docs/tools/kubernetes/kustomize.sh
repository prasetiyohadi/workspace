#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=amd64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=kustomize
APP_PATH=~/bin/$APP_BIN
APP_SRC=install_$APP_BIN.sh
APP_URL=https://raw.githubusercontent.com/kubernetes-sigs/$APP_BIN/master/hack
APP_URL=$APP_URL/$APP_SRC

check_version() {
    $APP_BIN version --short
}

install_linux() {
    cd /tmp && curl -s $APP_URL | bash
    mkdir -p ~/bin
    mv /tmp/$APP_BIN $APP_PATH
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew > /dev/null && brew install $APP_BIN
}

setup_linux() {
    echo "This script will install $APP_BIN."
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
