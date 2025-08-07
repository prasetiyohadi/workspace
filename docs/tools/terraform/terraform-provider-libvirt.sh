#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_ID=""
[ -f "/etc/os-release" ] && source /etc/os-release && OS_ID=$ID
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-gnu
APP_BIN=terraform-provider-libvirt
APP_VERSION=0.6.3
APP_URL=https://github.com/dmacvicar/terraform-provider-libvirt.git
HAS_GO="$(type "go" &> /dev/null && echo true || echo false)"
HAS_GO="$(type "terraform" &> /dev/null && echo true || echo false)"

install() {
    DIR=$(mktemp -d) && pushd "$DIR"
    git clone -b v$APP_VERSION $APP_URL
    cd $APP_BIN
    make
    make install
    popd
}

install_linux() {
    if [ "$OS_ID" == "debian" ] || [ "$OS_ID" == "ubuntu" ]; then
        sudo apt-get update
        sudo apt-get install -y genisoimage libvirt-dev
        install
    fi
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew > /dev/null && brew install $APP_BIN
}

setup_linux() {
    echo "This script will install $APP_NAME."
    if [ ! "$HAS_GO" == "true" ]; then
        echo "Install go first!"
    elif [ ! "$HAS_TERRAFORM" == "true" ]; then
        echo "Install terraform first!"
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
