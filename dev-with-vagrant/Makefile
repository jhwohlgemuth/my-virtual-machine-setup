validate:
	packer validate packer.focal.json
	packer validate packer.deploy.json

build: validate
	packer build packer.focal.json

deploy: validate
	packer build packer.deploy.json

prepare:
	sed -i $'s/\r$//' share/functions.sh
	sed -i $'s/\r$//' scripts/setup.sh