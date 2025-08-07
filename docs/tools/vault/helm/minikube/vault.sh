#!/usr/bin/env bash
set -euo pipefail

# Application details
APP_NAME=vault
APP_NAMESPACE=vault
APP_RELEASE=vault
APP_REPO=hashicorp
APP_REPO_URL=https://helm.releases.hashicorp.com
HAS_HELM="$(type "helm" &> /dev/null && echo true || echo false)"
HELM_CMD="helm --repository-cache .cache --repository-config .config"
HELM_SUBCMD=install

# Check existing installation
check() {
    $HELM_CMD list -n $APP_NAMESPACE -f $APP_RELEASE -q
}

# Add repository if needed
add_repo() {
    $HELM_CMD repo add $APP_REPO $APP_REPO_URL
    $HELM_CMD repo update
}

# Install Helm Chart
install() {
    pushd "$(dirname "$0")" &> /dev/null
    add_repo
    # Installation command for the application
    $HELM_CMD $HELM_SUBCMD -n $APP_NAMESPACE $APP_RELEASE $APP_REPO/$APP_NAME -f vault-values.yml
    popd &> /dev/null
}

# Main function
main() {
    echo "This script will install $APP_RELEASE in $APP_NAMESPACE namespace using Helm Chart."
    if [ ! "$HAS_HELM" == "true" ]; then
        echo "Helm must be installed!"
    else
        if [ ! "$(check)" == "" ]; then
            read -p "$APP_RELEASE already installed in $APP_NAMESPACE namespace. Upgrade[yn]? " -n 1 -r
            echo
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                HELM_SUBCMD=upgrade install
            else
                echo "Installation cancelled."
            fi
        else
            install
        fi
    fi
}

main
