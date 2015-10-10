#!/usr/bin/env bash
apt-get update

# Install Java (JRE/JDK)
# ----------------------
echo "Installing JRE and JDK..........."$(date '+%T')
#apt-get install -y default-jre default-jdk >/dev/null 2>&1
#echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
#add-apt-repository -y ppa:webupd8team/java >/dev/null 2>&1
#apt-get update >/dev/null 2>&1
#apt-get install -y oracle-java8-installer >/dev/null 2>&1

echo "Installing nvm, node & npm......."$(date '+%T')
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash

echo "Installing Pandoc................"$(date '+%T')
#apt-get install -y texlive texlive-latex-extra pandoc >/dev/null 2>&1

echo "Installing miscellaneous items..."$(date '+%T')
#add-apt-repository -y ppa:avsm/ppa
#apt-get update >/dev/null 2>&1
#apt-get install -y ocaml ocaml-native-compilers camlp4-extra opam >/dev/null 2>&1
apt-get install -y libzmq3-dev python-pip python-dev >/dev/null 2>&1
pip install --upgrade pip
pip install --upgrade virtualenv
pip install ipython[notebook] >/dev/null 2>&1
apt-get install -y figlet toilet >/dev/null 2>&1