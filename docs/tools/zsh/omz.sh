#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_ID=""
[ -f "/etc/os-release" ] && source /etc/os-release && OS_ID=$ID
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-gnu
OS_TYPE_LINUX_ARM=linux-gnueabihf
APP_CONFIG=~/.zshrc
APP_ROOT=~/.oh-my-zsh

# install .zshrc
install_config() {
    pushd "$(dirname "$0")"
    if [ "$OS_TYPE" == "$OS_TYPE_DARWIN" ]; then
        cp zshrc.macos $APP_CONFIG
    elif [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        if [ "$OS_ID" == "debian" ] || [ "$OS_ID" == "ubuntu" ]; then
            cp zshrc.debian $APP_CONFIG
        elif [ "$OS_ID" == "centos" ] || [ "$OS_ID" == "fedora" ]; then
            cp zshrc.redhat $APP_CONFIG
        fi
    elif [ "$OS_TYPE" == "$OS_TYPE_LINUX_ARM" ]; then
        if [ "$OS_ID" == "debian" ] || [ "$OS_ID" == "ubuntu" ]; then
            cp zshrc.raspbian $APP_CONFIG
        fi
    fi
    popd
}

# install oh-my-zsh
install_omz() {
    if [ -d $APP_ROOT ]; then
        (cd $APP_ROOT && git pull)
    else
        git clone https://github.com/robbyrussell/oh-my-zsh.git $APP_ROOT
    fi
}

# install oh-my-zsh custom plugins
install_plugin() {
    if [ -d $APP_ROOT/custom/plugins/zsh-autosuggestions ]; then
        (cd $APP_ROOT/custom/plugins/zsh-autosuggestions && git pull)
    else
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            $APP_ROOT/custom/plugins/zsh-autosuggestions
    fi
    if [ -d $APP_ROOT/custom/plugins/zsh-syntax-highlighting ]; then
        (cd $APP_ROOT/custom/plugins/zsh-syntax-highlighting && git pull)
    else
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            $APP_ROOT/custom/plugins/zsh-syntax-highlighting
    fi
}

# install oh-my-zsh custom themes
install_theme() {
    pushd "$(dirname "$0")"
    cp catalyst.zsh-theme $APP_ROOT/custom/themes/catalyst.zsh-theme
    popd
}

main() {
    install_config
    install_omz
    install_plugin
    install_theme
}
