#!/usr/bin/env bash
set -euxo pipefail

# OS=${OSTYPE:-'linux-gnu'}
# OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
# OS_TYPE_DARWIN=darwin
# OS_TYPE_LINUX_AMD64=linux-amd64
# [ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
# APP_BIN=node_exporter
# APP_URL=https://github.com/prometheus/node_exporter/releases/download
# APP_VERSION=1.1.2
# APP_PATH=/usr/local/bin/$APP_BIN
# APP_SRC=$APP_BIN-$APP_VERSION.$OS_TYPE
# APP_PKG=$APP_SRC.tar.gz
# APP_HASH=$APP_URL/v$APP_VERSION/sha256sums.txt
# APP_URL=$APP_URL/v$APP_VERSION/$APP_PKG

PREFIX=.
APP_BIN=zellij
APP_HASH=zellij-x86_64-unknown-linux-musl.sha256sum
APP_HASH_URL=https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.sha256sum
APP_PKG=zellij-x86_64-unknown-linux-musl.tar.gz
APP_PKG_URL=https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz
APP_INSTALLED=$(command -v $APP_BIN 2>&1 >/dev/null && echo "1" || echo "0")

download() {
  wget -O $PREFIX/$APP_PKG $APP_PKG_URL
  wget -O $PREFIX/$APP_HASH $APP_HASH_URL
}

extract() {
  tar -xzf $PREFIX/$APP_PKG -C $PREFIX/
}

checksum() {
  sha256sum -c $APP_HASH
}

install() {
  sudo install -D -m 755 $PREFIX/$APP_BIN /usr/local/bin/$APP_BIN
}

cleanup() {
  rm $APP_PKG
  rm $APP_HASH
  rm $APP_BIN
}

if [ $APP_INSTALLED -gt 0 ]; then
  echo "$APP_BIN is already installed"
else
  if [ -f "$PREFIX/$APP_PKG" ] && [ -f "$PREFIX/$APP_HASH" ]; then
    echo "Skipping download. $APP_PKG and $APP_HASH already exist."
  else
    echo "Downloading $APP_PKG and $APP_HASH"
    download
  fi

  if [ -f "$PREFIX/$APP_BIN" ]; then
    echo "Skipping extraction. $APP_BIN already exists."
  else
    echo "Extracting $APP_PKG"
    extract
  fi

  echo "Verifying checksum"
  checksum

  echo "Installing $APP_BIN"
  install
fi

cleanup
