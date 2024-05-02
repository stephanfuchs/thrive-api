#!/bin/bash
docker-compose --file docker/docker-compose.yml exec core-api bundle exec rails $*
