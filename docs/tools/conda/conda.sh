#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=Linux-x86_64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=conda
APP_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-$OS_TYPE.sh

clean() {
    rm /tmp/$APP_BIN-installer.sh
}

download() {
    curl -o /tmp/$APP_BIN-installer.sh $APP_URL
}

install() {
    CWD=$(dirname "$0")
    sha256sum -c "$CWD/$APP_BIN.sum"
    bash /tmp/$APP_BIN-installer.sh
}

install_linux() {
    download
    install
    clean
}

setup_linux() {
    install_linux
}

main() {
    if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
