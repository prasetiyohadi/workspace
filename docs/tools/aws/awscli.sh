#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-x86_64
OS_TYPE_LINUX_ARM=linux-aarch64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
[ "$OS_TYPE" == "linux-gnueabihf" ] && export OS_TYPE=$OS_TYPE_LINUX_ARM
APP_BIN=awscli
APP_SRC=$APP_BIN-exe-$OS_TYPE
APP_PATH=/usr/local/bin/aws
APP_PKG=$APP_SRC.zip
APP_URL=https://awscli.amazonaws.com/$APP_PKG

check_version() {
    aws --version
}

clean() {
    rm -rf /tmp/aws /tmp/awscliv2.sig /tmp/awscliv2.zip
}

download() {
    curl $APP_URL.sig -o /tmp/awscliv2.sig
    curl $APP_URL -o /tmp/awscliv2.zip
}

install() {
    CWD=$(dirname "$0")
    gpg --import "$CWD/$APP_BIN.pub"
    gpg --verify /tmp/awscliv2.sig /tmp/awscliv2.zip
    unzip -d /tmp /tmp/awscliv2.zip
    sudo /tmp/aws/install
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
    elif [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ] || \
        [ "$OS_TYPE" == "$OS_TYPE_LINUX_ARM" ]; then
        setup_linux
    fi
}

main
