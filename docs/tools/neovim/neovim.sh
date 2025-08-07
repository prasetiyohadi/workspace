#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_ID=""
[ -f "/etc/os-release" ] && source /etc/os-release && OS_ID=$ID
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux-gnu
OS_TYPE_LINUX_ARM=linux-gnueabihf
APP_BIN=neovim
VIM_PLUG_LOCATION=${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim
VIM_PLUG_URL=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

configure() {
    # install neovim configuration file
    CWD=$(dirname "$0")
    mkdir -p ~/.config/nvim
    cp "$CWD/init.vim" ~/.config/nvim/init.vim
    cp "$CWD/local_bundles.vim" ~/.config/nvim/local_bundles.vim
    cp "$CWD/local_init.vim" ~/.config/nvim/local_init.vim

    # setup python virtual environment
    python3 -m venv ~/.config/nvim/env
    ~/.config/nvim/env/bin/pip install -U pip
    ~/.config/nvim/env/bin/pip install neovim-remote pynvim ranger-fm

    # install plugins
    nvim +PlugInstall +qall
}

install_vim_plug() {
    # install vim-plug
    # https://github.com/junegunn/vim-plug
    sh -c "curl -fLo $VIM_PLUG_LOCATION --create-dirs $VIM_PLUG_URL"
}

install_darwin() {
    # install neovim using brew
    command -v brew > /dev/null && brew install $APP_BIN
    install_vim_plug
}

install_linux() {
    if [ "$OS_ID" == "debian" ] || [ "$OS_ID" == "ubuntu" ]; then
        # remove vim
        sudo apt-get purge -y vim-tiny vim-runtime vim-common
        # install neovim
        sudo apt-get update
        sudo apt-get install -y $APP_BIN
    elif [ "$OS_ID" == "centos" ] || [ "$OS_ID" == "fedora" ]; then
        # install neovim
        sudo dnf install --assumeyes $APP_BIN
        sudo alternatives --install /usr/bin/vim vim /usr/bin/nvim 900
    fi
    install_vim_plug
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    if [[ -d $HOME/.config/nvim ]]; then
        read -p "$HOME/.config/nvim already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            mv "$HOME/.config/nvim" "$HOME/.config/nvim.old"
            install_darwin
        else
            echo "Installation cancelled."
        fi
    else
        install_darwin
    fi
    configure
}

setup_linux() {
    echo "This script will install $APP_BIN."
    if [[ -d $HOME/.config/nvim ]]; then
        read -p "$HOME/.config/nvim already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            mv "$HOME/.config/nvim" "$HOME/.config/nvim.old"
            install_linux
        else
            echo "Installation cancelled."
        fi
    else
        install_linux
    fi
    configure
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
