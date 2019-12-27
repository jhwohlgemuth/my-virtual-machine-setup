@prepare:
    sed -i $'s/\r$//' ./share/functions.sh
    sed -i $'s/\r$//' ./share/setup.sh

@validate:
    packer validate packer.xenial.json

build: prepare
    packer build packer.xenial.json

deploy: prepare
    packer build packer.deploy.json