#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-gnu
APP_BIN=steampipe
APP_URL=https://raw.githubusercontent.com/turbot/steampipe/main/install.sh
APP_PATH=/usr/local/bin/$APP_BIN

check_version() {
    $APP_BIN -v
}

install_linux() {
    sudo /bin/sh -c "$(curl -fsSL $APP_URL)"
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    if [ $(command -v brew > /dev/null) ]; then
        brew tap turbot/tap
        brew install $APP_BIN
    fi
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
