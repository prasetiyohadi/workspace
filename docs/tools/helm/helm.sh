#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin-amd64
OS_TYPE_LINUX_AMD64=linux-amd64
OS_TYPE_LINUX_ARM=linux-arm
[ "$OS_TYPE" == "darwin" ] && export OS_TYPE=$OS_TYPE_DARWIN
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
[ "$OS_TYPE" == "linux-gnueabihf" ] && export OS_TYPE=$OS_TYPE_LINUX_ARM
APP_BIN=helm
APP_VERSION=""
APP_PATH=~/bin/$APP_BIN
DESIRED_VERSION=${DESIRED_VERSION:-}
HAS_CURL=$(type "curl" &> /dev/null && echo true || echo false)
HAS_WGET=$(type "wget" &> /dev/null && echo true || echo false)

check_desired_version() {
    if [ "$DESIRED_VERSION" == "" ]; then
        # Get tag from release URL
        local latest_release_url="https://github.com/helm/helm/releases"
        if [ "${HAS_CURL}" == "true" ]; then
            APP_VERSION=$(curl -Ls $latest_release_url | grep 'href="/helm/helm/releases/tag/v3.[0-9]*.[0-9]*\"' | grep -v no-underline | head -n 1 | cut -d '"' -f 2 | awk '{n=split($NF,a,"/");print a[n]}' | awk 'a !~ $0{print}; {a=$0}')
        elif [ "${HAS_WGET}" == "true" ]; then
            APP_VERSION=$(wget $latest_release_url -O - 2>&1 | grep 'href="/helm/helm/releases/tag/v3.[0-9]*.[0-9]*\"' | grep -v no-underline | head -n 1 | cut -d '"' -f 2 | awk '{n=split($NF,a,"/");print a[n]}' | awk 'a !~ $0{print}; {a=$0}')
        fi
    else
        APP_VERSION=$DESIRED_VERSION
    fi
}

check_desired_version

APP_SRC=$APP_BIN-$APP_VERSION-$OS_TYPE
APP_PKG=$APP_SRC.tar.gz
APP_URL=https://get.helm.sh/$APP_PKG

# initialize a helm chart repository
# https://helm.sh/docs/intro/quickstart/
add_repo() {
    $APP_BIN repo add stable https://charts.helm.sh/stable
    $APP_BIN repo add bitnami https://charts.bitnami.com/bitnami
    $APP_BIN repo add gitlab https://charts.gitlab.io
    $APP_BIN repo add hashicorp https://helm.releases.hashicorp.com
    $APP_BIN repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    $APP_BIN repo add jetstack https://charts.jetstack.io
    $APP_BIN repo add prometheus-community https://prometheus-community.github.io/helm-charts
    $APP_BIN repo add datadog https://helm.datadoghq.com
    $APP_BIN repo add rook-release https://charts.rook.io/release
    $APP_BIN repo add kedacore https://kedacore.github.io/charts
    $APP_BIN repo update
}

check_version() {
    $APP_BIN version
}

# install helm
# https://helm.sh/docs/intro/install/
clean() {
    rm -rf "/tmp/$APP_SRC" "/tmp/$APP_PKG"
}

download() {
    wget -O "/tmp/$APP_PKG" "$APP_URL"
}

install() {
    mkdir -p "/tmp/$APP_SRC" ~/bin
    tar -xf "/tmp/$APP_PKG" -C "/tmp/$APP_SRC"
    mv "/tmp/$APP_SRC/$OS_TYPE/$APP_BIN" ~/bin
}

linux_install() {
    download
    install
    clean
    add_repo
}

setup_linux() {
    echo "This script will install $APP_BIN version $APP_VERSION."
    if [ -s "$APP_PATH" ]; then
        check_version
        read -p "$APP_PATH already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            linux_install
        else
            echo "Installation cancelled."
        fi
    else
        linux_install
    fi
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew > /dev/null && brew install $APP_BIN
    add_repo
}

main() {
    if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ] \
        || [ "$OS_TYPE" == "$OS_TYPE_LINUX_ARM" ]; then
        setup_linux
    elif [ "$OS_TYPE" == "$OS_TYPE_DARWIN" ]; then
        setup_darwin
    fi
}

main
