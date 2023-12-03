#! /bin/bash
set -e

requires \
    locales
main() {
    #
    # Configure locale
    #
    local DEFAULT=en_US.UTF-8
    echo "C.utf8 UTF-8" > /etc/locale.gen
    echo "${DEFAULT} UTF-8" >> /etc/locale.gen
    echo "LANG=${DEFAULT}" > /etc/locale.conf
    locale-gen
    update-locale LANG="${LANG:-DEFAULT}"
}
main "$@"