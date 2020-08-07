#!/usr/bin/env bash
SCRIPT_FOLDER=.${ORG_NAME:-jhwohlgemuth}
mkdir -p ~/"${SCRIPT_FOLDER}"

#Make setup.sh executable
chmod +x setup.sh

if [[ -e functions.sh ]]; then
    mv functions.sh ~/"${SCRIPT_FOLDER}"
fi

if [[ -e setup.sh ]]; then
    mv setup.sh ~/"${SCRIPT_FOLDER}"
fi
