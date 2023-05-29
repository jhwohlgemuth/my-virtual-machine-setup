#! /bin/bash

echo ${GITHUB_TOKEN} | docker login ghcr.io -u ${GITHUB_ACTOR} --password-stdin
#
# Select images to build/push
#
if [[ ${IMAGE_NAME} == "base" ]] ; then
    IMAGES="base notebook python rust jvm dotnet lambda"
elif [[ ${IMAGE_NAME} == "notebook" ]] ; then
    IMAGES="notebook python rust jvm dotnet lambda"
elif [[ ${IMAGE_NAME} == "dotnet" ]] ; then
    IMAGES="dotnet lambda"
else
    IMAGES="${IMAGE_NAME}"
fi
#
# Build and push images
#
cd dev-with-containers
for IMAGE in ${IMAGES} ; do
    printf "\n\n[INFO] Build and publish:\n"
    figlet ${IMAGE}
    make ${IMAGE}
    docker push "${REGISTRY}/${GITHUB_ACTOR}/${IMAGE}"
done