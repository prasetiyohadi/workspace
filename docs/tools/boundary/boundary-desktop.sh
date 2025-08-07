#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_ID=""
[ -f "/etc/os-release" ] && source /etc/os-release && OS_ID=$ID
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux_amd64
OS_TYPE_LINUX_ARM=linux_arm
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
[ "$OS_TYPE" == "linux-gnueabihf" ] && export OS_TYPE=$OS_TYPE_LINUX_ARM
APP_BIN=boundary-desktop
APP_PATH=/usr/bin/$APP_BIN
APP_URL=https://releases.hashicorp.com/$APP_BIN
APP_VERSION=$(curl -sL $APP_URL | grep -E "${APP_BIN}_[.0-9]+<" \
    | sed -E 's/.*_([.0-9]+)<.*/\1/' | head -n 1)
APP_SRC=${APP_BIN}_${APP_VERSION}_${OS_TYPE}
APP_URL=$APP_URL/$APP_VERSION/$APP_SRC

install_linux() {
    if [ "$OS_ID" == "debian" ] || [ "$OS_ID" == "ubuntu" ] \
        || [ "$OS_ID" == "pop" ]; then
        wget -O /tmp/$APP_SRC.deb $APP_URL.deb
        sudo apt-get update
        sudo dpkg -i /tmp/$APP_SRC.deb
        rm -f /tmp/$APP_SRC.deb
    fi
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew > /dev/null && brew install hashicorp-$APP_BIN
}

setup_linux() {
    echo "This script will install $APP_BIN version $APP_VERSION."
    if [ -s "$APP_PATH" ]; then
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
