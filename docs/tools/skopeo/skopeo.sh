#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_ID=""
[ -f "/etc/os-release" ] && source /etc/os-release && OS_ID=$ID
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-gnu
APP_BIN=skopeo
APP_PATH=/usr/bin/$APP_BIN
DEB_URL=https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable

check_version() {
    $APP_BIN --version
}

install_linux() {
    if [ "$OS_ID" == "debian" ] || [ "$OS_ID" == "ubuntu" ] || [ "$OS_ID" == "pop" ]; then
        echo "deb ${DEB_URL}/xUbuntu_${VERSION_ID}/ /" | sudo tee \
            /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
        curl -L ${DEB_URL}/xUbuntu_${VERSION_ID}/Release.key | \
            sudo apt-key add -
        sudo apt-get update
        sudo apt-get -y upgrade
        sudo apt-get -y install $APP_BIN
    elif [ "$OS_ID" == "centos" ] || [ "$OS_ID" == "fedora" ]; then
        sudo dnf -y install $APP_BIN
    fi
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
