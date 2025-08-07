#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_ID=""
[ -f "/etc/os-release" ] && source /etc/os-release && OS_ID=$ID
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-gnu
APP_BIN=vim
APP_CONFIG=~/.vimrc
APP_ROOT=~/.vim

check_version() {
    $APP_BIN --version
}

install_config() {
    if [ -f "$APP_CONFIG" ]; then
        # install .vimrc
        pushd "$(dirname "$0")"
        cp vimrc $APP_CONFIG
        popd
    else
        echo "$APP_CONFIG file already exists!"
    fi
}

install_plugin() {
    if [ -d "$APP_ROOT" ]; then
        # install vim packages
        mkdir -p $APP_ROOT/pack/plugins/start
        git clone https://github.com/Shougo/deoplete.nvim \
        $APP_ROOT/pack/plugins/start/deoplete
        git clone https://github.com/scrooloose/nerdtree.git \
        $APP_ROOT/pack/plugins/start/nerdtree
        git clone https://github.com/roxma/nvim-yarp \
        $APP_ROOT/pack/plugins/start/nvim-yarp
        git clone https://github.com/vim-airline/vim-airline \
        $APP_ROOT/pack/plugins/start/vim-airline
        git clone https://github.com/vim-airline/vim-airline-themes \
        $APP_ROOT/pack/plugins/start/vim-airline-themes
        git clone https://github.com/tpope/vim-fugitive.git \
        $APP_ROOT/pack/plugins/start/vim-fugitive
        git clone https://github.com/airblade/vim-gitgutter.git \
        $APP_ROOT/pack/plugins/start/vim-gitgutter
        git clone https://github.com/fatih/vim-go.git \
        $APP_ROOT/pack/plugins/start/vim-go
        git clone https://github.com/roxma/vim-hug-neovim-rpc \
        $APP_ROOT/pack/plugins/start/vim-hug-neovim-rpc
        git clone https://github.com/tpope/vim-sensible.git \
        $APP_ROOT/pack/plugins/start/vim-sensible
        git clone https://github.com/jmcantrell/vim-virtualenv.git \
        $APP_ROOT/pack/plugins/start/vim-virtualenv
    else
        echo "$APP_ROOT directory already exists!"
    fi
}

install_darwin() {
    command -v brew > /dev/null && brew install $APP_BIN
    install_config
    install_plugin
}

install_linux() {
    if [ "$OS_ID" == "debian" ] || [ "$OS_ID" == "ubuntu" ]; then
        sudo apt-get update
        sudo apt-get install -y python3-neovim python3-pynvim vim-nox
    fi
    install_config
    install_plugin
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    if [ -f "$APP_CONFIG" ] || [ -d "$APP_ROOT" ]; then
        check_version
        read -p "$APP_CONFIG or $APP_ROOT already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            rm -fr $APP_ROOT
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
    if [ -f "$APP_CONFIG" ] || [ -d "$APP_ROOT" ]; then
        check_version
        read -p "$APP_CONFIG or $APP_ROOT already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            rm -fr $APP_ROOT
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
