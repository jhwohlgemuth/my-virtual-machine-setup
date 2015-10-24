#!/usr/bin/env bash
#This line makes the script work on POSIX systems even if edited on Windows
sed -i 's/\r//' fun.sh
#Source install functions
. ./fun.sh

update
install_desktop
install_java8
#install_pandoc
install_atom
#install_python
#install_julia
#install_redis
#install_couchdb
#install_mongodb
#install_jenkins