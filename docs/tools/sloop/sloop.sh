#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux_amd64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_APIURL=https://api.github.com/repos/salesforce/sloop
APP_APIURL=$APP_APIURL/releases/latest
APP_BASEURL=https://github.com/salesforce/sloop/releases/download
APP_BIN=sloop
APP_PATH=~/bin/$APP_BIN
APP_VERSION=$(curl --silent $APP_APIURL | grep '"tag_name"' \
    | sed -E 's/.*"v([^"]+)".*/\1/')
APP_SRC=${APP_BIN}_${APP_VERSION}_${OS_TYPE}
APP_PKG=$APP_SRC.tar.gz
APP_URL=$APP_BASEURL/v$APP_VERSION/$APP_PKG
HAS_APP="$(type "$APP_BIN" &> /dev/null && echo true || echo false)"

download() {
    wget -O - $APP_URL | tar -C /tmp $APP_BIN -zxf -
}

install() {
    mkdir -p ~/bin
    mv /tmp/$APP_BIN ~/bin
}

install_linux() {
    download
    install
}

setup_linux() {
    echo "This script will install $APP_BIN version $APP_VERSION."
    if [ "$HAS_APP" == "true" ]; then
        APP_PATH=$(command -v $APP_BIN)
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
    if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
