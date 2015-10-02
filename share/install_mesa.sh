sudo apt-add-repository ppa:xorg-edgers
sudo apt-get update  
sudo apt-get install libdrm-dev

sudo apt-get build-dep mesa

wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key|sudo apt-key add -
sudo apt-get install -y clang-3.6 clang-3.6-doc libclang-common-3.6-dev libclang-3.6-dev libclang1-3.6 libclang1-3.6-dbg libllvm-3.6-ocaml-dev libllvm3.6 libllvm3.6-dbg lldb-3.6 llvm-3.6 llvm-3.6-dev llvm-3.6-doc llvm-3.6-examples llvm-3.6-runtime clang-modernize-3.6 clang-format-3.6 python-clang-3.6 lldb-3.6-dev
sudo apt-get install -y libx11-xcb-dev libx11-xcb1 libxcb-glx0-dev libxcb-dri2-0-dev libxcb-dri3-dev libxshmfence-dev libxcb-sync-dev llvm
