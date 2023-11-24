#! /bin/bash
set -e

main() {
    apt-get update
    apt-get install --no-install-recommends -y ruby-full
    cleanup
}
main "$@"