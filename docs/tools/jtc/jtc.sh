#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=macos
OS_TYPE_LINUX_AMD64=linux
[ "$OS_TYPE" == "darwin" ] && export OS_TYPE=$OS_TYPE_DARWIN
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=jtc
APP_URL=https://github.com/ldn-softdev/jtc/releases/download
APP_VERSION=1.76
APP_PATH=~/.local/bin/$APP_BIN
APP_SRC=$APP_BIN-$OS_TYPE-64.v$APP_VERSION
APP_URL=$APP_URL/$APP_VERSION/$APP_SRC

install() {
	mkdir -p ~/bin
	wget -O $APP_PATH "$APP_URL"
	chmod +x $APP_PATH
}

setup() {
	echo "This script will install $APP_BIN version $APP_VERSION."
	if [ -s "$APP_PATH" ]; then
		read -p "$APP_PATH already exists. Replace[yn]? " -n 1 -r
		echo
		if [[ "$REPLY" =~ ^[Yy]$ ]]; then
			install
		else
			echo "Installation cancelled."
		fi
	else
		install
	fi
}

main() {
	if [ "$OS_TYPE" == "$OS_TYPE_DARWIN" ] ||
		[ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
		setup
	fi
}

main
