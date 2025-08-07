#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=linux_amd64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=azcopy
APP_PATH=~/bin/$APP_BIN
APP_VERSION=10.20.1
APP_URL=https://azcopyvnext.azureedge.net/releases/release-${APP_VERSION}-20230809
APP_SRC=azcopy_${OS_TYPE}_${APP_VERSION}
APP_PKG=$APP_SRC.tar.gz
APP_URL=$APP_URL/$APP_PKG

check_version() {
	$APP_BIN --version
}

clean() {
	rm -rf "/tmp/$APP_SRC" "/tmp/$APP_PKG"
}

download() {
	[ ! -f "/tmp/$APP_PKG" ] && wget -O "/tmp/$APP_PKG" "$APP_URL"
}

install() {
	mkdir -p "/tmp/$APP_SRC"
	tar -xf "/tmp/$APP_PKG" -C /tmp
	mkdir -p ~/.local/bin
	mv "/tmp/$APP_SRC/azcopy" ~/.local/bin/azcopy
}

install_linux() {
	download
	install
	clean
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
