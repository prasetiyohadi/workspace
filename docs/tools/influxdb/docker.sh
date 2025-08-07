#!/usr/bin/env bash
set -euo pipefail
###
### influxdb/docker.sh - manage influxdb container
###
### Usage: docker.sh [OPTIONS] COMMAND
###
### Options:
###   -h        Show this message.
###
### Commands:
###   clean     Clean resources
###   deploy    Deploy resources
###   images    List images
###   influx    Run influx client
###   networks  List networks
###   ps        List containers
###   purge     Remove all resources
###   volumes   List volumes
###
### References:
###   https://hub.docker.com/_/influxdb

help() {
    sed -Ene 's/^### ?//;T;p' "$0"
}

fail() {
    help
    exit 1
}

# Initialize options variables
PREFIX="influxdb"

#clean##
#clean## influxdb/docker.sh - manage influxdb container
#clean##
#clean## Usage: docker.sh clean [OPTIONS] NAME
#clean##
#clean## Options:
#clean##   -h   Show this message.
#clean##   -t   Set resource type, default is container, allowed values: container, image, network, volume.

help_clean() {
    sed -Ene 's/^#clean## ?//;T;p' "$0"
}

fail_clean() {
    help_clean
    exit 1
}

# Clean resources
clean() {
    if [ -z "$name" ]; then
        echo "nothing to clean"
        help_clean
        exit 0
    elif [ "$TYPE" == "container" ]; then
        echo "stopping $name container..."
        docker stop "$name" > /dev/null
        echo "deleting $name container..."
        docker rm "$name" > /dev/null
    elif [ "$TYPE" == "image" ]; then
        echo "deleting $name image..."
        docker rmi "$name" > /dev/null
    elif [ "$TYPE" == "network" ]; then
        echo "deleting $name network..."
        docker network rm "$name" > /dev/null
    elif [ "$TYPE" == "volume" ]; then
        echo "deleting $name volume..."
        docker volume rm "$name" > /dev/null
    else
        echo "no resource with type $TYPE"
    fi
}

#deploy##
#deploy## influxdb/docker.sh - manage influxdb container
#deploy##
#deploy## Usage: docker.sh deploy [OPTIONS] RESOURCE
#deploy##
#deploy## Options:
#deploy##   -h      Show this message.
#deploy##
#deploy## Available resources:
#deploy##   network     Create docker network
#deploy##   influxdb    Create influxdb infrastructure

help_deploy() {
    sed -Ene 's/^#deploy## ?//;T;p' "$0"
}

fail_deploy() {
    help_deploy
    exit 1
}

#influxdb##
#influxdb## influxdb/docker.sh - manage influxdb container
#influxdb##
#influxdb## Usage: docker.sh deploy influxdb [OPTIONS]
#influxdb##
#influxdb## Options:
#influxdb##   -h     Show this message.
#influxdb##   -n     Network name, default is influxdb.

help_influxdb() {
    sed -Ene 's/^#influxdb## ?//;T;p' "$0"
}

fail_influxdb() {
    help_influxdb
    exit 1
}

# influxdb deployment
influxdb() {
    ERR="Deploy the network first!"
    docker network inspect $NETWORK 1>/dev/null 2>&1 || (echo $ERR && exit 1)
    echo "creating influxdb-data volume..."
    docker volume create influxdb-data
    echo "pulling influxdb image..."
    docker image pull influxdb
    echo "creating influxdb container..."
    CWD=$(dirname $0)
    docker container run \
        --name influxdb \
        --rm \
        --detach \
        --network $NETWORK \
        --env INFLUXDB_GRAPHITE_ENABLED=true \
        --publish 2003:2003 \
        --publish 8086:8086 \
        --volume influxdb-data:/var/lib/influxdb \
        --volume $PWD/$CWD/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
        influxdb -config /etc/influxdb/influxdb.conf
}

#influx##
#influx## influxdb/docker.sh - manage influxdb container
#influx##
#influx## Usage: docker.sh influx [OPTIONS]
#influx##
#influx## Options:
#influx##   -h     Show this message.
#influx##   -n     Network name, default is influxdb.

help_influx() {
    sed -Ene 's/^#influx## ?//;T;p' "$0"
}

fail_influx() {
    help_influx
    exit 1
}

# influx client
influx() {
    ERR1="Deploy the network first!"
    docker network inspect $NETWORK 1>/dev/null 2>&1 || (echo $ERR1 && exit 1)
    ERR2="Deploy the influxdb container first!"
    docker container inspect influxdb 1>/dev/null 2>&1 || (echo $ERR2 && exit 1)
    echo "pulling influxdb image..."
    docker image pull influxdb
    echo "creating influx container..."
    docker container run \
        --name influx \
        --rm \
        --network $NETWORK \
        --interactive \
        --tty \
        influxdb influx -host influxdb
}

#network##
#network## influxdb/docker.sh - manage influxdb container
#network##
#network## Usage: docker.sh deploy network [OPTIONS]
#network##
#network## Options:
#network##   -h     Show this message.
#network##   -n     Network name, default is influxdb.

help_network() {
    sed -Ene 's/^#network## ?//;T;p' "$0"
}

fail_network() {
    help_network
    exit 1
}

# Create network
network() {
    echo "creating $NETWORK network..."
    docker network create $NETWORK
}

# Purge deployment
purge() {
    read -p "All resources will be deleted. Continue[yn]? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "deleting $PREFIX network..."
        docker network rm "$PREFIX" > /dev/null
    fi
}

OPTIND=1
while getopts ":h?" opt; do
    case ${opt} in
        h) help && exit 0;;
        :) echo "Error: option -${OPTARG} requires an argument." && fail;;
        \?) echo "Error: option -${OPTARG} does not exist." && fail;;
    esac
done
shift $((OPTIND-1))
[[ $# -ge 1 ]] && export CMD="$1" || export CMD=""
case $CMD in
    "clean")
        OPTIND=2
        TYPE=container
        while getopts ":t:h?" opt; do
            case ${opt} in
                h) help_clean && exit 0;;
                t) TYPE=$OPTARG;;
                :) echo "Error: option -${OPTARG} requires an argument." && fail_clean;;
                \?) echo "Error: option -${OPTARG} does not exist." && fail_clean;;
            esac
        done
        shift $((OPTIND-1))
        [[ $# -ge 1 ]] && export name="$1" || export name=""
        clean;;
    "deploy")
        OPTIND=2
        while getopts ":h?" opt; do
            case ${opt} in
                h) help_deploy && exit 0;;
                :) echo "Error: option -${OPTARG} requires an argument." && fail_deploy;;
                \?) echo "Error: option -${OPTARG} does not exist." && fail_deploy;;
            esac
        done
        shift $((OPTIND-1))
        [[ $# -ge 1 ]] && export CMD="$1" || export CMD=""
        case $CMD in
            "influxdb")
                OPTIND=2
                NETWORK=$PREFIX
                while getopts ":n:h?" opt; do
                    case ${opt} in
                        h) help_influxdb && exit 0;;
                        n) NETWORK=$OPTARG;;
                        :) echo "Error: option -${OPTARG} requires an argument." && fail_influxdb;;
                        \?) echo "Error: option -${OPTARG} does not exist." && fail_influxdb;;
                    esac
                done
                shift $((OPTIND-1))
                influxdb;;
            "network")
                OPTIND=2
                NETWORK=$PREFIX
                while getopts ":n:h?" opt; do
                    case ${opt} in
                        h) help_network && exit 0;;
                        n) NETWORK=$OPTARG;;
                        :) echo "Error: option -${OPTARG} requires an argument." && fail_network;;
                        \?) echo "Error: option -${OPTARG} does not exist." && fail_network;;
                    esac
                done
                shift $((OPTIND-1))
                network;;
            *) echo "nothing to deploy" && help_deploy && exit 0;;
        esac;;
    "images") docker images;;
    "influx")
        OPTIND=2
        NETWORK=$PREFIX
        while getopts ":n:h?" opt; do
            case ${opt} in
                h) help_influx && exit 0;;
                n) NETWORK=$OPTARG;;
                :) echo "Error: option -${OPTARG} requires an argument." && fail_influx;;
                \?) echo "Error: option -${OPTARG} does not exist." && fail_influx;;
            esac
        done
        shift $((OPTIND-1))
        influx;;
    "networks") docker network ls;;
    "ps") docker ps -a;;
    "purge") purge;;
    "volumes") docker volume ls;;
    *) help && exit 0;;
esac
