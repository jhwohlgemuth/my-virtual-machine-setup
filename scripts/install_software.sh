#!/usr/bin/env bash
echo "Updating........................."$(date '+%T')
apt-get update >/dev/null 2>&1

echo "Installing JRE and JDK..........."$(date '+%T')
#apt-get install -y default-jre default-jdk >/dev/null 2>&1
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
add-apt-repository -y ppa:webupd8team/java >/dev/null 2>&1
apt-get update >/dev/null 2>&1
apt-get install -y oracle-java8-installer >/dev/null 2>&1

echo "Installing Pandoc................"$(date '+%T')
apt-get install -y texlive texlive-latex-extra pandoc >/dev/null 2>&1

echo "Installing Atom editor..........."$(date '+%T')
add-apt-repository -y ppa:webupd8team/atom >/dev/null 2>&1
apt-get update >/dev/null 2>&1
apt-get install -y atom >/dev/null 2>&1

echo "Installing Python dependencies..."$(date '+%T')
apt-get install -y libzmq3-dev python-pip python-dev >/dev/null 2>&1
apt-get install -y libblas-dev libatlas-base-dev liblapack-dev gfortran libfreetype6-dev libpng-dev >/dev/null 2>&1
pip install --upgrade pip
pip install --upgrade virtualenv
pip install ipython[notebook] >/dev/null 2>&1

echo "Adding Julia language PPA........"$(date '+%T')
apt-get install -y software-properties-common python-software-properties >/dev/null 2>&1
add-apt-repository -y ppa:staticfloat/juliareleases >/dev/null 2>&1
add-apt-repository -y ppa:staticfloat/julia-deps >/dev/null 2>&1
apt-get update >/dev/null 2>&1
echo "Installing Julia language........"$(date '+%T')
apt-get install -y julia >/dev/null 2>&1
julia -e 'Pkg.add("IJulia")' >/dev/null 2>&1

echo "Installing miscellaneous........."$(date '+%T')
apt-get install -y figlet toilet >/dev/null 2>&1