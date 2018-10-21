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

if [[ -e profiles.clj ]]; then
    mv profiles.clj ~/"${SCRIPT_FOLDER}"
fi

if type atom >/dev/null 2>&1; then
    mkdir -p ~/.atom
    mv snippets.cson ~/.atom
else
    mv snippets.cson ~/"${SCRIPT_FOLDER}"
fi
