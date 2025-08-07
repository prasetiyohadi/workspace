#!/usr/bin/env bash
set -euo pipefail

# Application details
APP_NAME=minio
HAS_MC="$(type "mc" &> /dev/null && echo true || echo false)"
MC_CMD=mc

config() {
    pushd "$(dirname "$0")" &> /dev/null
    if [ ! -f .env ]; then
        echo "The environment file does not exist!"
    else
         . .env && $MC_CMD config host add ${MINIO_ALIAS} ${MINIO_HOST} ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY}
    fi
    popd &> /dev/null
}

main() {
    echo "This script will setup new $APP_NAME host configuration."
    if [ ! "$HAS_MC" == "true" ]; then
        echo "Minio client must be installed!"
    else
        config
    fi
}

main
