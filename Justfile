@prepare:
    sed -i $'s/\r$//' ./share/functions.sh
    sed -i $'s/\r$//' ./share/setup.sh

@validate:
    packer validate packer.xenial.json

build: prepare
    packer build packer.xenial.json

add:
    vagrant box add --name test box/virtualbox.xenial.8.0.0.box

clean:
    rm -frd packer_cache
    rm box/virtualbox.xenial.8.0.0.box
    vagrant box remove test

deploy: prepare
    packer build packer.deploy.json