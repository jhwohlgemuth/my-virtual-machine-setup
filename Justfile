@prepare:
    sed -i $'s/\r$//' ./dev-with-vagrant/share/functions.sh
    sed -i $'s/\r$//' ./dev-with-vagrant/share/setup.sh

@validate:
    packer validate ./dev-with-vagrant/packer.xenial.json

build: prepare
    packer build ./dev-with-vagrant/packer.xenial.json

test:
    vagrant box add --name test-box ./dev-with-vagrant/box/virtualbox.xenial.8.0.0.box
    mkdir -p test && cd test && vagrant init test-box && vagrant up

clean:
    cd test && vagrant destroy -f
    vagrant box remove test-box
    rm -frd ./dev-with-vagrant/packer_cache
    rm -frd ./dev-with-vagrant/box
    rm -frd ./dev-with-vagrant/test

deploy: prepare
    packer build ./dev-with-vagrant/packer.deploy.json