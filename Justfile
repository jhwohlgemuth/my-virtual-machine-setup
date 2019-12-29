@prepare:
    sed -i $'s/\r$//' ./share/functions.sh
    sed -i $'s/\r$//' ./share/setup.sh

@validate:
    packer validate packer.xenial.json

build: prepare
    packer build packer.xenial.json

test:
    vagrant box add --name test-box box/virtualbox.xenial.8.0.0.box
    mkdir -p test && cd test && vagrant init test-box && vagrant up

clean:
    cd test && vagrant destroy -f
    vagrant box remove test-box
    rm -frd packer_cache
    rm -frd box
    rm -frd test

deploy: prepare
    packer build packer.deploy.json