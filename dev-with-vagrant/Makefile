
build: prepare validate
	packer build packer.focal.json

deploy: validate
	packer build packer.deploy.json

prepare:
	dos2unix share/functions.sh

validate:
	packer validate packer.focal.json
	packer validate packer.deploy.json