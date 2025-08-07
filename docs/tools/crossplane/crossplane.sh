#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-gnu
APP_BIN=kubectl-crossplane
APP_URL=https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh
HAS_KUBECTL="$(type "kubectl" &> /dev/null && echo true || echo false)"
if [ ! "$HAS_KUBECTL" == "true" ]; then
    echo "Kubectl must be installed!"
    exit 1
else
    APP_PATH=$(dirname "$(command -v kubectl)")/$APP_BIN
fi
TMPDIR=$(mktemp -d)

check_version() {
    $APP_BIN --version
}

install_darwin() {
    pushd "$TMPDIR"
    curl -sL $APP_URL | sh
    sudo mv $APP_BIN "$APP_PATH"
    popd
    rmdir "$TMPDIR"
}

install_linux() {
    pushd "$TMPDIR"
    curl -sL $APP_URL | sh
    mv $APP_BIN "$APP_PATH"
    popd
    rmdir "$TMPDIR"
}

setup_darwin() {
    echo "This script will install $APP_BIN."
    if [ -s "$APP_PATH" ]; then
        check_version
        read -p "$APP_PATH already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            install_darwin
        else
            echo "Installation cancelled."
        fi
    else
        install_darwin
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
