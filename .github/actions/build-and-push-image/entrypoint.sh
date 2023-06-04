#! /bin/bash

docker login ghcr.io -u ${GITHUB_ACTOR} --password ${ACCESS_TOKEN}
#
# Build and push image
#
cd dev-with-containers
printf "\n\n[INFO] Build and publish:\n"
figlet ${IMAGE_NAME}
make ${IMAGE_NAME}
docker push "${REGISTRY}/${GITHUB_ACTOR}/${IMAGE_NAME}"