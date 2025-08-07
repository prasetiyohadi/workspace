#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-amd64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_APIURL=https://api.github.com/repos/argoproj/argo-cd
APP_APIURL=$APP_APIURL/releases/latest
APP_BASEURL=https://github.com/argoproj/argo-cd/releases/download
APP_BIN=argocd
APP_PATH=~/bin/$APP_BIN
APP_SRC=$APP_BIN-$OS_TYPE
APP_VERSION=$(curl --silent $APP_APIURL | grep '"tag_name"' \
    | sed -E 's/.*"([^"]+)".*/\1/')
APP_URL=$APP_BASEURL/$APP_VERSION/$APP_SRC

check_version() {
    $APP_BIN version --client
}

install_linux() {
    mkdir -p ~/bin
    curl -Lo "$APP_PATH" "$APP_URL"
    chmod +x "$APP_PATH"
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
