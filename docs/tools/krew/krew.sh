#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-amd64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=krew
APP_URL=https://github.com/kubernetes-sigs/krew/releases/latest/download
APP_PATH=~/.$APP_BIN/bin/kubectl-$APP_BIN
APP_PKG=$APP_BIN.tar.gz
APP_URL=$APP_URL/$APP_PKG
HAS_GIT="$(type "git" &> /dev/null && echo true || echo false)"

check_version() {
    kubectl-$APP_BIN version
}

install_linux() {
    if [ "$HAS_GIT" == "true" ]; then
        set -x; cd "$(mktemp -d)"
        OS=$(uname | tr '[:upper:]' '[:lower:]')
        ARCH=$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')
        curl -fsSLO $APP_URL
        tar zxvf $APP_BIN.tar.gz
        APP_SRC=./$APP_BIN-${OS}_${ARCH}
        $APP_SRC install krew

        # update PATH
        KREW_ROOT=$HOME
        PATH=$KREW_ROOT/.$APP_BIN/bin:$PATH
        kubectl-krew update
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
    elif [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ] || \
        [ "$OS_TYPE" == "$OS_TYPE_LINUX_ARM" ]; then
        setup_linux
    fi
}

main
