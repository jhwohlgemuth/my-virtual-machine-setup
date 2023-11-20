#! /bin/sh
set -e

requires() {
    if type $1 >/dev/null 2>&1; then
        pass
    else
        echo "==> [ERROR] $1 not found"
        exit 1
    fi
}