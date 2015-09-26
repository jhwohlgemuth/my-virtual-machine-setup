#!/usr/bin/env bash
sudo apt-get update >/dev/null 2>&1

# Install Java (JRE/JDK)
echo "Installing JRE and JDK..."
sudo apt-get install -y default-jre >/dev/null 2>&1
sudo apt-get install -y default-jdk >/dev/null 2>&1

# Install Python 2.7
echo "Installing Python 2.7 and Python dev dependencies..."
sudo apt-get install -y python2.7 >/dev/null 2>&1
sudo apt-get install -y python-dev >/dev/null 2>&1

# Install Python modules: pip, scipy stack, cython,
echo "Installing pip..."
sudo apt-get install -y python-pip >/dev/null 2>&1
echo "Installing SciPy stack..."
sudo apt-get install -y python-numpy >/dev/null 2>&1
echo "----> numpy DONE"
sudo apt-get install -y python-scipy >/dev/null 2>&1
echo "----> scipy DONE"
sudo apt-get install -y python-matplotlib >/dev/null 2>&1
echo "----> matplotlib DONE"
sudo apt-get install -y ipython ipython-notebook python-pandas python-sympy python-nose >/dev/null 2>&1
echo "Installing Cython..."
sudo apt-get install -y cython >/dev/null 2>&1
echo "Installing ReportLab module..."
sudo pip install reportlab >/dev/null 2>&1

# Install Ruby
echo "Installing Ruby..."
sudo apt-get install -y ruby-full >/dev/null 2>&1

# Install Julia
echo "Adding Julia language repository..."
sudo apt-get install -y software-properties-common python-software-properties >/dev/null 2>&1
sudo add-apt-repository -y ppa:staticfloat/juliareleases >/dev/null 2>&1
sudo add-apt-repository -y ppa:staticfloat/julia-deps >/dev/null 2>&1
sudo apt-get update >/dev/null 2>&1
echo "Installing Julia language..."
sudo apt-get install -y julia >/dev/null 2>&1

# Install Node and npm
echo "Preparing to install node.js and npm..."
curl -sL https://deb.nodesource.com/setup | sudo bash - >/dev/null 2>&1
echo "Installing node.js and npm..."
sudo apt-get install -y nodejs >/dev/null 2>&1