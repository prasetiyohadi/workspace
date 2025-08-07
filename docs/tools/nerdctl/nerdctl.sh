#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=linux-amd64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=nerdctl
APP_URL=https://github.com/containerd/nerdctl/releases/download
APP_VERSION=1.0.0
APP_PATH=~/.local/bin/$APP_BIN
APP_SRC=${APP_BIN}-full-${APP_VERSION}-${OS_TYPE}
APP_PKG=$APP_SRC.tar.gz
APP_URL=$APP_URL/v$APP_VERSION/$APP_PKG

check_version() {
	$APP_BIN version
}

clean() {
	rm /tmp/$APP_PKG
}

install() {
	# Remove docker (if you have it)
	# # remove Docker
	sudo apt autoremove docker-ce docker-ce-cli containerd.io
	# # remove the Docker Ubuntu repository
	sudo rm /usr/share/keyrings/docker-archive-keyring.gpg /etc/apt/sources.list.d/docker.list
	# Install containerd
	sudo apt install containerd
	# Install nerdctl binary
	# export PATH="${PATH}:~/.local/bin"
	mkdir -p ~/.local/bin
	wget -O /tmp/$APP_PKG $APP_URL
	tar -C ~/.local/bin -xzf /tmp/$APP_PKG --strip-components 1 bin/nerdctl
	# Install the CNI Plugin
	# export CNI_PATH=~/.local/libexec/cni
	mkdir -p ~/.local/libexec
	tar -C ~/.local/libexec -xzf /tmp/$APP_PKG libexec/cni
	# Make a symlink
	ln -s $APP_PATH ~/.local/bin/docker
	# Buildkit
	tar -C ~/.local/bin/ -xzf /tmp/$APP_PKG --strip-components 1 bin/buildkitd bin/buildctl
	# Copy startup scripts
	CWD=$(dirname "$0")
	cp "$CWD/start-containerd.sh" "$CWD/start-buildkitd.sh" ~/.local/bin
}

setuid() {
	# SETUID bit tells nerdctl which user to use
	sudo chown root $APP_PATH
	sudo chmod +s $APP_PATH
}

install_linux() {
	install
	setuid
	clean
}

setup_linux() {
	echo "This script will install $APP_BIN version $APP_VERSION."
	if [ -s "$APP_PATH" ]; then
		check_version
		read -p "$APP_PATH already exists. Replace[yn]? " -n 1 -r
		echo
		if [[ "$REPLY" =~ ^[Yy]$ ]]; then
			install_linux
			rm -r ~/.local/libexec/cni
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
