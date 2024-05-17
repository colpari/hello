#!/bin/sh

docker-compose -f docker-compose.production.yaml -p helloProd "$@"
