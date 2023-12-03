#! /bin/bash
set -e

requires \
    locales
main() {
    #
    # Configure locale
    #
    echo "C.utf8 UTF-8" > /etc/locale.gen
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
    update-locale LANG="${LANG:-'en_US.UTF-8'}"
}
main "$@"