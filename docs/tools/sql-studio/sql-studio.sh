#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=aarch64-apple-darwin
OS_TYPE_LINUX_AMD64=x86_64-unknown-linux-gnu
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=sql-studio
APP_URL=https://github.com/frectonz/sql-studio/releases/download
APP_VERSION=0.1.17
APP_PATH=~/.local/bin/$APP_BIN
APP_SRC=${APP_BIN}-${OS_TYPE}
APP_PKG=$APP_SRC.tar.xz
APP_URL=$APP_URL/${APP_VERSION}/$APP_PKG

check_version() {
  $APP_BIN --version
}

install_linux() {
  mkdir -p ~/.local/bin
  wget -O - $APP_URL | tar -xJf - -C /tmp $APP_SRC/$APP_BIN
  mv "/tmp/$APP_SRC/$APP_BIN" $APP_PATH
  rm -r "/tmp/$APP_SRC"
}

setup_darwin() {
  echo "This script will install $APP_BIN using brew."
  command -v brew >/dev/null && brew install $APP_BIN
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
