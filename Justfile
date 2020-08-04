@prepare:
    sed -i $'s/\r$//' ./dev-box/share/functions.sh
    sed -i $'s/\r$//' ./dev-box/share/setup.sh

@validate:
    packer validate ./dev-box/packer.xenial.json

build: prepare
    packer build ./dev-box/packer.xenial.json

test:
    vagrant box add --name test-box ./dev-box/box/virtualbox.xenial.8.0.0.box
    mkdir -p test && cd test && vagrant init test-box && vagrant up

clean:
    cd test && vagrant destroy -f
    vagrant box remove test-box
    rm -frd ./dev-box/packer_cache
    rm -frd ./dev-box/box
    rm -frd ./dev-box/test

deploy: prepare
    packer build ./dev-box/packer.deploy.json