#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=linux-x86-64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_APIURL=https://api.github.com/repos/localsend/localsend
APP_APIURL=$APP_APIURL/releases/latest
APP_BASEURL=https://github.com/localsend/localsend/releases/download
APP_BIN=localsend_app
APP_NAME=LocalSend
APP_PATH=/usr/bin/$APP_BIN
APP_VERSION=$(curl --silent $APP_APIURL | grep '"tag_name"' |
	sed -E 's/.*"v([^"]+)".*/\1/')
APP_SRC=${APP_NAME}-${APP_VERSION}-${OS_TYPE}
APP_PKG=$APP_SRC.deb
APP_URL=$APP_BASEURL/v$APP_VERSION/$APP_PKG

install_linux() {
	mkdir -p ~/.local/bin
	wget -P /tmp "$APP_URL"
	sudo apt install "/tmp/$APP_PKG"
}

setup_linux() {
	echo "This script will install $APP_BIN version $APP_VERSION."
	if [ -s "$APP_PATH" ]; then
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
	if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
		setup_linux
	fi
}

main
