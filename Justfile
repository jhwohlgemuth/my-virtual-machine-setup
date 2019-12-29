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
    rm -frd packer_cache
    rm -frd test
    rm -frd box
    vagrant box remove test
    cd test && vagrant destroy -f

deploy: prepare
    packer build packer.deploy.json