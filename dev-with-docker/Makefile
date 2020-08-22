HOST_NAME = $(shell hostname)
IMAGE_NAME = jhwohlgemuth/env
CONTAINER_NAME = dev

.PHONY: setup create copy-ssh-key copy-git-config install-node shell start stop build

setup: create copy-ssh-key copy-git-config install-node

create:
	@docker run -dit --name $(CONTAINER_NAME) --hostname $(HOST_NAME) -p 8000:8000 -p 8080:8080 -p 8111:8111 -p 1337:1337 -p 4669:4669 -p 46692:46692 $(IMAGE_NAME)
	@echo "==> Created ${CONTAINER_NAME} container"

copy-ssh-key:
	@docker exec -it dev /bin/bash -c "mkdir -p /root/.ssh"
	@docker cp "${HOME}\.ssh\id_rsa" dev:/root/.ssh/
	@docker exec -it dev /bin/bash -c "chmod 600 /root/.ssh/id_rsa"
	@echo "==> Copied SSH key to ${CONTAINER_NAME}"

copy-git-config:
	@docker cp "${HOME}\.gitconfig" dev:/root/
	@echo "==> Copied .gitconfig file to ${CONTAINER_NAME}"

install-node:
	@docker exec -it dev /usr/bin/zsh -c "source ~/.zshrc && nvm install node"

shell:
	@docker exec -it $(CONTAINER_NAME) zsh

start:
	docker start --interactive $(CONTAINER_NAME)

stop:
	docker stop $(CONTAINER_NAME)

build:
	@docker build -t $(CONTAINER_NAME) .