#!/bin/sh -l

cd dev-with-containers
make format
echo "docker push ${REGISTRY}/${GITHUB_ACTOR}/${IMAGE_NAME}"