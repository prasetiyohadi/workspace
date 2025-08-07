#!/usr/bin/env bash
set -euo pipefail
###
### jenkins/docker.sh - manage jenkins container
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
###   networks  List networks
###   ps        List containers
###   purge     Remove all resources
###   volumes   List volumes

help() {
    sed -Ene 's/^### ?//;T;p' "$0"
}

fail() {
    help
    exit 1
}

# Initialize options variables
PREFIX="jenkins"

#clean##
#clean## jenkins/docker.sh - manage jenkins container
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
#deploy## jenkins/docker.sh - manage jenkins container
#deploy##
#deploy## Usage: docker.sh deploy [OPTIONS] RESOURCE
#deploy##
#deploy## Options:
#deploy##   -h      Show this message.
#deploy##
#deploy## Available resources:
#deploy##   jenkins Create jenkins containers and volumes
#deploy##   network Create jenkins docker network

help_deploy() {
    sed -Ene 's/^#deploy## ?//;T;p' "$0"
}

fail_deploy() {
    help_deploy
    exit 1
}

# jenkins deployment
# https://www.jenkins.io/doc/book/installing/
jenkins() {
    ERR="Deploy the network first!"
    docker network inspect $PREFIX 1>/dev/null 2>&1 || (echo $ERR && exit 1)
    echo "creating jenkins-docker-certs volume..."
    docker volume create jenkins-docker-certs
    echo "creating jenkins-data volume..."
    docker volume create jenkins-data
    echo "pulling docker:dind image..."
    docker image pull docker:dind
    echo "creating jenkins-docker container..."
    docker container run \
        --name jenkins-docker \
        --rm \
        --detach \
        --privileged \
        --network jenkins \
        --network-alias docker \
        --env DOCKER_TLS_CERTDIR=/certs \
        --volume jenkins-docker-certs:/certs/client \
        --volume jenkins-data:/var/jenkins_home \
        --publish 2376:2376 \
        docker:dind
    echo "pulling jenkinsci/blueocean image..."
    docker image pull jenkinsci/blueocean
    echo "creating jenkins-blueocean container..."
    docker container run \
        --name jenkins-blueocean \
        --rm \
        --detach \
        --network jenkins \
        --env DOCKER_HOST=tcp://docker:2376 \
        --env DOCKER_CERT_PATH=/certs/client \
        --env DOCKER_TLS_VERIFY=1 \
        --publish 8080:8080 \
        --publish 50000:50000 \
        --volume jenkins-data:/var/jenkins_home \
        --volume jenkins-docker-certs:/certs/client:ro \
        jenkinsci/blueocean
    echo "Open jenkins page on http://localhost:8080/ and input the following password:"
    docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
}

blueocean() {
    ERR1="Deploy the network first!"
    docker network inspect $PREFIX 1>/dev/null 2>&1 || (echo $ERR1 && exit 1)
    ERR2="Deploy jenkins first!"
    docker inspect jenkins-docker 1>/dev/null 2>&1 || (echo $ERR2 && exit 1)
    ERR3="Container jenkins-blueocean already exists!"
    docker inspect jenkins-blueocean 1>/dev/null 2>&1 && (echo $ERR3 && exit 1)
    echo "creating jenkins-blueocean container..."
    docker container run \
        --name jenkins-blueocean \
        --rm \
        --detach \
        --network jenkins \
        --env DOCKER_HOST=tcp://docker:2376 \
        --env DOCKER_CERT_PATH=/certs/client \
        --env DOCKER_TLS_VERIFY=1 \
        --publish 8080:8080 \
        --publish 50000:50000 \
        --volume jenkins-data:/var/jenkins_home \
        --volume jenkins-docker-certs:/certs/client:ro \
        jenkinsci/blueocean
}

# Create network
network() {
  docker network create $PREFIX
}

# Purge deployment
purge() {
    read -p "All resources will be deleted. Continue[yn]? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "stopping jenkins-docker container..."
        docker stop "jenkins-docker" > /dev/null
        echo "stopping jenkins-blueocean container..."
        docker stop "jenkins-blueocean" > /dev/null
        echo "deleting jenkins-docker container..."
        docker rm "jenkins-docker" > /dev/null
        echo "deleting jenkins-blueocean container..."
        docker rm "jenkins-blueocean" > /dev/null
        echo "deleting docker:dind image..."
        docker rmi "docker:dind" > /dev/null
        echo "deleting jenkinsci/blueocean image..."
        docker rmi "jenkinsci/blueocean" > /dev/null
        echo "deleting $PREFIX network..."
        docker network rm "$PREFIX" > /dev/null
        echo "deleting jenkins-docker-certs volume..."
        docker volume rm "jenkins-docker-certs" > /dev/null
        echo "deleting jenkins-data volume..."
        docker volume rm "jenkins-data" > /dev/null
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
            "blueocean") blueocean;;
            "jenkins") jenkins;;
            "network") network;;
            *) echo "nothing to deploy" && help_deploy && exit 0;;
        esac;;
    "images") docker images;;
    "networks") docker network ls;;
    "ps") docker ps -a;;
    "purge") purge;;
    "volumes") docker volume ls;;
    *) help && exit 0;;
esac
