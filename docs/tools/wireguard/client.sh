#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_ID=""
[ -f "/etc/os-release" ] && source /etc/os-release && OS_ID=$ID
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=linux-gnu
APP_BIN=wireguard
APP_ROOT=/etc/wireguard
APT_SOURCE_FILE=/etc/apt/sources.list.d/backports.list

install_linux() {
    echo "This script will install debian $(lsb_release -sc) backports repositories."
    if [ "$OS_ID" == "debian" ] || [ "$OS_ID" == "ubuntu" ]; then
        if [ ! -f "$APT_SOURCE_FILE" ]; then
            echo \
            "deb http://ftp.debian.org/debian $(lsb_release -sc)-backports main" \
            | sudo tee $APT_SOURCE_FILE
        fi
        sudo apt update
        sudo apt install --assume-yes wireguard
        wg genkey | sudo tee $APP_ROOT/privatekey \
        | wg pubkey | sudo tee $APP_ROOT/publickey
        sudo touch $APP_ROOT/wg0.conf
        sudo chmod 600 $APP_ROOT/{privatekey,wg0.conf}
    fi
}

setup_linux() {
    echo "This script will install $APP_BIN."
    if [ -d "$APP_ROOT" ]; then
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
    if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
