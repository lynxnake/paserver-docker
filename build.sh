#!/bin/bash

docker build . --build-arg password=securepass \
    --tag=radstudio/paserver:tinycore `#\
    --tag=radstudio/paserver:athens \
    --tag=radstudio/paserver:12.0 \
    --tag=radstudio/paserver:latest`
