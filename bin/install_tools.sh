#!/usr/bin/env bash
sudo apt-get update >/dev/null 2>&1
# Install Python 2.7
printf "Installing Python 2.7 and Python dev dependencies..."
sudo apt-get install -y python2.7 >/dev/null 2>&1
sudo apt-get install -y python-dev >/dev/null 2>&1

# Install Python modules: pip, scipy stack, cython,
printf "Installing pip..."
sudo apt-get install -y python-pip >/dev/null 2>&1
printf "Installing SciPy stack..."
sudo apt-get install -y python-numpy >/dev/null 2>&1
printf "----> numpy DONE"
sudo apt-get install -y python-scipy >/dev/null 2>&1
printf "----> scipy DONE"
sudo apt-get install -y python-matplotlib >/dev/null 2>&1
printf "----> matplotlib DONE"
sudo apt-get install -y ipython ipython-notebook python-pandas python-sympy python-nose >/dev/null 2>&1
printf "Installing Cython..."
sudo apt-get install -y cython >/dev/null 2>&1
printf "Installing ReportLab module..."
sudo pip install reportlab >/dev/null 2>&1

# Install Ruby
printf "Installing Ruby..."
sudo apt-get install -y ruby-full >/dev/null 2>&1

# Install Julia
printf "Adding Julia language repository..."
sudo apt-get install -y software-properties-common python-software-properties >/dev/null 2>&1
sudo add-apt-repository -y ppa:staticfloat/juliareleases >/dev/null 2>&1
sudo add-apt-repository -y ppa:staticfloat/julia-deps >/dev/null 2>&1
sudo apt-get update >/dev/null 2>&1
printf "Installing Julia language..."
sudo apt-get install -y julia >/dev/null 2>&1

# Install Node and npm
printf "Preparing to install node.js and npm..."
curl -sL https://deb.nodesource.com/setup | sudo bash - >/dev/null 2>&1
printf "Installing node.js and npm..."
sudo apt-get install -y nodejs >/dev/null 2>&1

# Install Git
printf "Installing Git..."
sudo apt-get install -y git >/dev/null 2>&1

# Install Google Chrome
printf "Installing Google Chrome..."
sudo apt-get install -y libxss1 libappindicator1 libindicator7 >/dev/null 2>&1
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install -f
sudo dpkg -i google-chrome*.deb

# Install Atom Editor
printf "Installing Atom editor..."
mkdir ~/git
cd ~/git
git clone https://github.com/atom/atom
cd ~/git/atom
git fetch -p
git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
script/build
sudo script/grunt install