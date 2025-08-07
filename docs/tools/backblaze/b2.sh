#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_APIURL=https://api.github.com/repos/Backblaze/B2_Command_Line_Tool
APP_APIURL=$APP_APIURL/releases/latest
APP_BIN=b2
APP_URL=https://github.com/Backblaze/B2_Command_Line_Tool/releases/download
APP_PATH=~/.local/bin/$APP_BIN
APP_VERSION=$(curl --silent $APP_APIURL | grep '"tag_name"' |
  sed -E 's/.*"v([^"]+)".*/\1/')
APP_SRC=$APP_BIN-$OS_TYPE
APP_URL=$APP_URL/v$APP_VERSION/$APP_SRC

check_version() {
  $APP_BIN version
}

install_linux() {
  curl --create-dirs -L -o $APP_PATH $APP_URL
  chmod +x $APP_PATH
}

setup_darwin() {
  echo "This script will install $APP_BIN using brew."
  command -v brew >/dev/null && brew install $APP_BIN-tools
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
