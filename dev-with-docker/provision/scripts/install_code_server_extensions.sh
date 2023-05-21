#! /bin/bash
#
# Install Code Server extensions
#
TYPE=${NOTEBOOK_ENVIRONMENT:-notebook}
EXTENSIONS="$(jq -r ".${TYPE}[]" ./Extensions.json)"
for EXTENSION in ${EXTENSIONS}; do
    code-server --extensions-dir "${CODE_SERVER_CONFIG_DIR}/extensions" --install-extension "${EXTENSION}"
done