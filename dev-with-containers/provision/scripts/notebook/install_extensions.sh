#! /bin/bash
set -e

requires \
    code-server \
    curl \
    jq
main() {
    #
    # Download Extensions listing
    #
    EXTENSIONS_JSON="${CODE_SERVER_CONFIG_DIR}"/Extensions.json
    curl -o "${EXTENSIONS_JSON}" https://raw.githubusercontent.com/jhwohlgemuth/purple/main/artifacts/Extensions.json
    #
    # Install Code Server extensions
    #
    if [ -z "$1" ]
    then
        ARGS=notebook
    else
        ARGS=("$@")
    fi
    for ARG in "${ARGS[@]}"; do
        echo "Installing extensions for ${ARG} VS Code instance"
        EXTENSIONS="$(jq -r ".${ARG}[]" "${EXTENSIONS_JSON}")"
        for EXTENSION in ${EXTENSIONS}; do
            code-server --extensions-dir "${CODE_SERVER_CONFIG_DIR}/extensions" --install-extension "${EXTENSION}" --force
        done
    done
}
main "$@"
