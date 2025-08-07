#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=x86_64-linux
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_APIURL=https://api.github.com/repos/AmrDeveloper/GQL
APP_APIURL=$APP_APIURL/releases/latest
APP_BASEURL=https://github.com/AmrDeveloper/GQL/releases/download
APP_BIN=gql
APP_PATH=~/.local/bin/$APP_BIN
APP_VERSION=$(curl --silent $APP_APIURL | grep '"tag_name"' |
	sed -E 's/.*"([^"]+)".*/\1/')
APP_SRC=${APP_BIN}-${OS_TYPE}
APP_PKG=$APP_SRC.gz
APP_URL=$APP_BASEURL/$APP_VERSION/$APP_PKG

check_version() {
	$APP_BIN --version
}

install_linux() {
    curl -L "$APP_URL" | gunzip -c - > $APP_PATH
    chmod +x $APP_PATH
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
	if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
		setup_linux
	fi
}

main
