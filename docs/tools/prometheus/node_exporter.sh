#!/usr/bin/env bash
set -euxo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-amd64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=node_exporter
APP_URL=https://github.com/prometheus/node_exporter/releases/download
APP_VERSION=1.1.2
APP_PATH=/usr/local/bin/$APP_BIN
APP_SRC=$APP_BIN-$APP_VERSION.$OS_TYPE
APP_PKG=$APP_SRC.tar.gz
APP_SHA256=$APP_URL/v$APP_VERSION/sha256sums.txt
APP_URL=$APP_URL/v$APP_VERSION/$APP_PKG

check_version() {
    $APP_BIN version
}

clean() {
    rm -fr /tmp/$APP_SRC/$APP_BIN /tmp/$APP_BIN.sum /tmp/sha256sums.txt \
        /tmp/$APP_PKG
}

download() {
    wget -O /tmp/$APP_PKG $APP_URL
    wget -O /tmp/sha256sums.txt $APP_SHA256
}

install() {
    echo "$(grep $OS_TYPE /tmp/sha256sums.txt \
        | awk '{print $1}') /tmp/$APP_PKG" > /tmp/$APP_BIN.sum
    sha256sum -c /tmp/$APP_BIN.sum
    tar -xf /tmp/$APP_PKG -C /tmp
    sudo cp /tmp/$APP_SRC/$APP_BIN /usr/local/bin
}

install_linux() {
    download
    install
    clean
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
