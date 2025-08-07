#!/usr/bin/env bash
set -euo pipefail

HAS_HELM=$(type "helm" &> /dev/null && echo true || echo false)

main() {
    if [ ! "$HAS_HELM" == "true" ]; then
        echo "Helm is not found in PATH."
    else
        echo "This script will install helm plugins."
        # TODO change this to loop
        helm plugin install "https://github.com/databus23/helm-diff"
        helm plugin install "https://github.com/aslafy-z/helm-git"
        helm plugin install "https://github.com/jkroepke/helm-secrets"
    fi
}

main
