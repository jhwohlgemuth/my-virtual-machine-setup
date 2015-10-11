#!/usr/bin/env bash
apt-get update >/dev/null 2>&1

echo "Installing SciPy stack..........."
apt-get install -y python-numpy >/dev/null 2>&1
echo "----> numpy DONE"
apt-get install -y python-scipy >/dev/null 2>&1
echo "----> scipy DONE"
apt-get install -y python-matplotlib >/dev/null 2>&1
echo "----> matplotlib DONE"
apt-get install -y ipython ipython-notebook python-pandas python-sympy python-nose >/dev/null 2>&1
echo "Installing Cython..."
apt-get install -y cython >/dev/null 2>&1
echo "Installing ReportLab module......"
pip install reportlab >/dev/null 2>&1

echo "Installing Ruby..."
apt-get install -y ruby-full >/dev/null 2>&1

echo "Adding Julia language PPA........"
apt-get install -y software-properties-common python-software-properties >/dev/null 2>&1
add-apt-repository -y ppa:staticfloat/juliareleases >/dev/null 2>&1
add-apt-repository -y ppa:staticfloat/julia-deps >/dev/null 2>&1
apt-get update >/dev/null 2>&1
echo "Installing Julia language........"
apt-get install -y julia >/dev/null 2>&1