#!/usr/bin/env bash
set -euo pipefail

# Application details
APP_NAMESPACE=vault
HAS_KUBECTL="$(type "kubectl" &> /dev/null && echo true || echo false)"

# Check existing namespace
check() {
    kubectl get namespace $APP_NAMESPACE &> /dev/null
}

# Get current Kubernetes context
context() {
    kubectl config current-context
}

# Create the namespace
create() {
    kubectl create namespace $APP_NAMESPACE
}

# Main function
main() {
    echo "This script will create $APP_NAMESPACE namespace Kubernetes context $(context)."
    if [ ! "$HAS_KUBECTL" == "true" ]; then
        echo "Kubectl must be installed!"
    else
        if check; then
            echo "$APP_NAMESPACE is already created."
        else
            read -p "$APP_NAMESPACE namespace will be created in Kubernetes context $(context). Continue[yn]? " -n 1 -r
            echo
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                create
            else
                echo "Task cancelled."
            fi
        fi
    fi
}

main
