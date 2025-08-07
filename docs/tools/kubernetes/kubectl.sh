#!/usr/bin/env bash
set -eo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=amd64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=kubectl
APP_URL=https://storage.googleapis.com/kubernetes-release/release
APP_PATH=/usr/local/bin/$APP_BIN
APP_STABLE=$(curl -s $APP_URL/stable.txt)
[ -z "$APP_VERSION" ] && export APP_VERSION=$APP_STABLE
APP_URL=$APP_URL/$APP_VERSION/bin/linux/$OS_TYPE/$APP_BIN

check_version() {
    $APP_BIN version --client
}

install_linux() {
    sudo curl -Lo $APP_PATH "$APP_URL"
    sudo chmod +x $APP_PATH
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew > /dev/null && brew install kubernetes-cli
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
