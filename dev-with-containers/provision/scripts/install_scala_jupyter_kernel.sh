#! /bin/bash
set -e

requires \
    cs \
    java \
    scala
main() {
    #
    # Install Scala kernel
    #
    local SCALA_VERSION="${1:-"2.13"}"
    local ALMOND_VERSION="${ALMOND_VERSION:-"0.11.1"}"
    cs launch --fork "almond:${ALMOND_VERSION}" --scala "${SCALA_VERSION}" -- --install
}
main "$@"