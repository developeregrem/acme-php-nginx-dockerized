#!/bin/bash

cd /opt/acme-php-nginx-dockerized
/usr/local/bin/docker-compose pull

/usr/local/bin/docker-compose build --force-rm --pull
/usr/local/bin/docker-compose stop
/usr/local/bin/docker-compose up --force-recreate -d
docker image prune -f