#!/usr/bin/env bash
apt-get update >/dev/null 2>&1

echo "Adding Julia language PPA........"$(date '+%T')
apt-get install -y software-properties-common python-software-properties >/dev/null 2>&1
add-apt-repository -y ppa:staticfloat/juliareleases >/dev/null 2>&1
add-apt-repository -y ppa:staticfloat/julia-deps >/dev/null 2>&1
apt-get update >/dev/null 2>&1
echo "Installing Julia language........"$(date '+%T')
apt-get install -y julia >/dev/null 2>&1

#julia Pkg.add("IJulia")