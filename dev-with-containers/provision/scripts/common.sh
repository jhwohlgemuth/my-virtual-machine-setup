#! /bin/bash
set -e

requires() {
    for ARG in "${ARGS[@]}"; do
        if type "${ARG}" >/dev/null 2>&1; then
            pass
        else
            echo "==> [ERROR] ${ARG} not found"
            exit 1
        fi
    done
}