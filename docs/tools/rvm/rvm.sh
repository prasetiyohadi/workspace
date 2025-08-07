#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=linux-gnu
APP_BIN=rvm
APP_GPG1=409B6B1796C275462A1703113804BB82D39DC0E3
APP_GPG2=7D2BAF1CF37B13E2069D6956105BD0E739499BDB
APP_URL=https://get.rvm.io
APP_ROOT=~/.$APP_BIN

check_version() {
    $APP_BIN --version
}

install_linux() {
    gpg2 --recv-keys $APP_GPG1 $APP_GPG2
    curl -sSL $APP_URL | bash -s stable
}

setup_linux() {
    echo "This script will install $APP_BIN."
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
    if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
