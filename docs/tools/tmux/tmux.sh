#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-gnu
OS_TYPE_LINUX_ARM=linux-gnueabihf
APP_BIN=tmux
APP_CONFIG=tmux.conf
APP_CONFIG_PATH=~/.$APP_CONFIG
HAS_APP="$(type $APP_BIN &> /dev/null && echo true || echo false)"
HAS_BREW="$(type "brew" &> /dev/null && echo true || echo false)"
HAS_GIT="$(type "git" &> /dev/null && echo true || echo false)"
TPM_PATH=~/.tmux/plugins/tpm

# install tmux configuration
install_config() {
    CWD=$(dirname "$0")
    cp "$CWD/$APP_CONFIG" $APP_CONFIG_PATH
}

# setup tmux configuration
setup_config() {
    if [ -f "$APP_CONFIG_PATH" ]; then
        read -p "$APP_CONFIG_PATH already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            rm $APP_CONFIG_PATH
            install_config
        else
            echo "Tmux configuration installation cancelled."
        fi
    else
        install_config
    fi
}

# install tmux plugins manager
install_tpm() {
    if [ ! "$HAS_GIT" == "true" ]; then
        echo "Git must be installed! Run command below manually after installing git."
        echo "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
    else
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}

# setup tmux plugins manager
setup_tpm() {
    if [ -d "$TPM_PATH" ]; then
        read -p "$TPM_PATH already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            rm -r $TPM_PATH
            install_tpm
        else
            echo "Tmux plugins manager installation cancelled."
        fi
    else
        install_tpm
    fi
}

# install tmux and powerline
install_linux() {
    if [ -f /etc/debian_version ]; then
        sudo apt-get update
        sudo apt-get install -y powerline $APP_BIN
    elif [ -f /etc/redhat-release ]; then
        sudo dnf install --assumeyes python3-pip $APP_BIN
        sudo pip3 install powerline-status
    fi
}

# installation for linux
setup_linux() {
    echo "This script will install $APP_BIN."
    if [ "$HAS_APP" == "true" ]; then
        read -p "$APP_BIN already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            install_linux
        else
            echo "$APP_BIN installation cancelled."
        fi
    else
        install_linux
    fi
}

# installation for macos
setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    if [ ! "$HAS_BREW" == "true" ]; then
        echo "Homebrew must be installed! Run command below manually after installing homebrew."
        echo "brew install python $APP_BIN"
        echo "pip3 install powerline-status psutil"
    else
        brew install python $APP_BIN
        pip3 install powerline-status psutil
    fi
}

# main function
main() {
    if [ "$OS_TYPE" == "$OS_TYPE_DARWIN" ]; then
        setup_darwin
    elif [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ] || \
        [ "$OS_TYPE" == "$OS_TYPE_LINUX_ARM" ]; then
        setup_linux
    fi
    setup_config
    setup_tpm
}

main
