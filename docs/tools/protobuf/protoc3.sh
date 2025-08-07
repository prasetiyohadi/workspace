#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-x86_64
[ "$OS_TYPE" == "darwin" ] && export OS_TYPE=$OS_TYPE_DARWIN
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=protoc
APP_URL=https://github.com/protocolbuffers/protobuf/releases/download
APP_VERSION=3.17.3
APP_ROOT=/usr/local/include/google
APP_SRC=$APP_BIN-$APP_VERSION-$OS_TYPE
APP_PKG=$APP_SRC.zip
APP_URL=$APP_URL/v$APP_VERSION/$APP_PKG

check_version() {
    $APP_BIN --version
}

install_linux() {
    cd "$(mktemp -d)"
    curl -fsSLO $APP_URL
    unzip $APP_PKG -d $APP_SRC
    sudo mv $APP_SRC/bin/* /usr/local/bin/
    sudo mv $APP_SRC/include/* /usr/local/include/
    sudo chown "$USER" /usr/local/bin/$APP_BIN
    sudo chown -R "$USER" /usr/local/include/google
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew > /dev/null && brew install $APP_BIN
}

setup_linux() {
    echo "This script will install $APP_BIN version $APP_VERSION."
    if [ -d "$APP_ROOT" ]; then
        check_version
        read -p "$APP_ROOT already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            sudo rm -fr $APP_ROOT
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
