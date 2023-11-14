#! /bin/sh
#
# CVC5
#
cd /usr/bin
wget https://github.com/cvc5/cvc5/releases/download/cvc5-1.0.8/cvc5-Linux -O cvc5
chmod u+x cvc5
cd /root
#
# Install eprover
#
mkdir -p /eprover && cd /eprover
git clone https://github.com/eprover/eprover.git
cd eprover && ./configure && make -j8 && make install
mv PROVER/* /usr/bin
cd /root && rm -frd /eprover
#
# Install Vampire
#
mkdir -p /vampire && cd /vampire
wget https://github.com/vprover/vampire/releases/download/snakeForV4.7%2B/vampire-snake-static4starexec.zip
unzip vampire-snake-static4starexec.zip
mv bin/* /usr/bin/
cd /root && rm -frd /vampire
#
# Install Z3
#
mkdir -p /z3 && cd /z3
git clone https://github.com/Z3Prover/z3
cd z3 && python scripts/mk_make.py && cd build && make -j8 && make install
cd /root && rm -frd /z3