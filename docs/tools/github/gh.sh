#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=`echo ${OS} | tr -d "[:digit:]"`

if [ "${OS_TYPE}" == "linux-gnu" ]; then
    if [ -f /etc/debian_version ]; then
        sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
        sudo apt-add-repository https://cli.github.com/packages
        sudo apt-get update
        sudo apt-get install --assume-yes gh
    elif [ -f /etc/redhat-release ]; then
        sudo dnf config-manager --add-repo \
            https://cli.github.com/packages/rpm/gh-cli.repo
        sudo dnf install --assumeyes gh
    fi
elif [ "${OS_TYPE}" == "darwin" ]; then
    which brew > /dev/null && brew install gh
fi
