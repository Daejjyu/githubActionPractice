#!/bin/bash
  
DOCKER_APP_NAME=react-nginx-frontend
docker-compose -p ${DOCKER_APP_NAME}-proxy -f docker-compose.proxy.yml up -d
docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml up -d