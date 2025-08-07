#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux_amd64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_VERSION=1.6.0
APPS=(cfssl cfssl-bundle cfssl-certinfo cfssl-newkey cfssl-scan cfssljson mkbundle multirootca)

check_version() {
    cfssl version
}

install_linux() {
    APP_BIN="$1"
    APP_SRC=${APP_BIN}_${APP_VERSION}_${OS_TYPE}
    APP_URL=$APP_URL/v$APP_VERSION/$APP_SRC
    curl -Lso "$HOME/bin/$APP_BIN" "$APP_URL"
    chmod +x "$HOME/bin/$APP_BIN"
}

setup_darwin() {
    echo "This script will install cfssl version $APP_VERSION using brew."
    command -v brew > /dev/null && brew install cfssl
}

setup_linux() {
    APPS_BIN=("$@")
    mkdir -p ~/bin
    for APP_BIN in "${APPS_BIN[@]}"; do
        APP_PATH=~/bin/$APP_BIN
        APP_URL=https://github.com/cloudflare/cfssl/releases/download
        echo "This script will install $APP_BIN version $APP_VERSION."
        if [ -s "$APP_PATH" ]; then
            check_version
            read -p "$APP_PATH already exists. Replace[yn]? " -n 1 -r
            echo
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                install_linux "$APP_BIN"
            else
                echo "Installation cancelled."
            fi
        else
            install_linux "$APP_BIN"
        fi
    done
}

main() {
    if [ "$OS_TYPE" == "$OS_TYPE_DARWIN" ]; then
        setup_darwin
    elif [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux "${APPS[@]}"
    fi
}

main
