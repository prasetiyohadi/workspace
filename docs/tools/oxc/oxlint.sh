#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=linux-x64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_APIURL=https://api.github.com/repos/oxc-project/oxc
APP_APIURL=$APP_APIURL/releases/latest
APP_BASEURL=https://github.com/oxc-project/oxc/releases/download
APP_BIN=oxlint
APP_PATH=~/.local/bin/$APP_BIN
APP_VERSION=$(curl --silent $APP_APIURL | grep '"tag_name"' |
	sed -E 's/.*"oxlint_v([^"]+)".*/\1/')
APP_SRC=$APP_BIN-$OS_TYPE
APP_PKG=$APP_SRC.tar.gz
APP_URL=$APP_BASEURL/${APP_BIN}_v$APP_VERSION/$APP_PKG

download() {
	wget -O - "$APP_URL" | tar -C /tmp -zxf -
}

install() {
	mkdir -p ~/.local/bin
	mv "/tmp/$APP_SRC" $APP_PATH
}

install_linux() {
	download
	install
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
