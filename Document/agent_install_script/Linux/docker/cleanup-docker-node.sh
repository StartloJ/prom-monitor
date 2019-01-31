#! /bin/sh

#####################################################################
##### Cleaning up auto deploy node-exporter to docker container #####
#####################################################################

DOCKER_RUN_IMG="$(docker ps -a -q --filter="name=node-exporter")"
docker stop "${DOCKER_RUN_IMG}"
docker rm "${DOCKER_RUN_IMG}"

docker rmi $(docker images --format '{{.Repository}}' | grep 'node-exporter')

#############################
##### Clean up cAdvisor #####
#############################
DOCKER_RUN_IMG="$(docker ps -a -q --filter="name=cadvisor")"
docker stop "${DOCKER_RUN_IMG}"
docker rm "${DOCKER_RUN_IMG}"

docker rmi $(docker images --format '{{.Repository}}' | grep 'cadvisor')

##### show current images on docker ######
##########################################

docker images