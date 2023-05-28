#! /bin/bash

cd dev-with-containers
echo "Build and publish:"
if [[ ${IMAGE_NAME} == "base" ]]
then
    figlet "ALL"
    make all publish
elif [[ ${IMAGE_NAME} == "notebook" ]]
then
    figlet "MULITPLE"
    make notebook python rust jvm dotnet lambda
elif [[ ${IMAGE_NAME} == "dotnet" ]]
then
    figlet "dotnet & lambda"
    make dotnet lambda
else
    figlet ${IMAGE_NAME}
    make ${IMAGE_NAME}
    docker push "${REGISTRY}/${GITHUB_ACTOR}/${IMAGE_NAME}"
fi