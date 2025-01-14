#!/bin/bash

if [ "$1" = '' ]; then
    echo "RAD Server Docker paserver Run Script";
    echo "Required arguments: PAServer password";
    echo "ex: run-production.sh securepass";
else
    docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
    --env PA_SERVER_PASSWORD=$1 -p 64211:64211 -p 8082:8082 \
    --detach --interactive radstudio/paserver:latest
fi
