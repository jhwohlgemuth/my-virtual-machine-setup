HOST_NAME = $(shell hostname)
HOME_PATH = $(shell echo %userprofile%)
SSH_KEY = "${HOME_PATH}\.ssh\id_ed25519"
SSH_CONFIG = "${HOME_PATH}\.ssh\config"
GIT_CONFIG = "${HOME_PATH}\.gitconfig"
BASE_IMAGE_NAME = jhwohlgemuth/base
IMAGE_NAME = jhwohlgemuth/env
CONTAINER_NAME = dev

.PHONY: setup lint clean create copy-ssh-config copy-git-config install-node shell start stop server build local build-image build-base-image

setup: create copy-ssh-config copy-git-config install-node

create:
	@docker run -dit --name $(CONTAINER_NAME) --hostname $(HOST_NAME) -p 8000:8000 -p 8080:8080 -p 8111:8111 -p 1337:1337 -p 3449:3449 -p 4669:4669 -p 46692:46692 $(IMAGE_NAME)
	@echo "==> Created ${CONTAINER_NAME} container"

copy-ssh-config:
	@docker exec -it dev /bin/bash -c "mkdir -p /root/.ssh"
	@IF EXIST $(SSH_KEY) \
		docker cp $(SSH_KEY) dev:/root/.ssh/
	@IF EXIST $(SSH_KEY) \
		docker exec -it dev /bin/bash -c "chmod 600 /root/.ssh/id_ed25519"
	@IF EXIST $(SSH_KEY) \
		echo "==> Copied SSH key to ${CONTAINER_NAME}"
	@IF EXIST $(SSH_CONFIG) \
		docker cp $(SSH_CONFIG) dev:/root/.ssh/
	@IF EXIST $(SSH_CONFIG) \
		echo "==> Copied SSH configuration to ${CONTAINER_NAME}"

copy-git-config:
	@IF EXIST $(GIT_CONFIG) \
		docker cp $(GIT_CONFIG) dev:/root/
	@IF EXIST $(GIT_CONFIG) \
		echo "==> Copied .gitconfig file to ${CONTAINER_NAME}"

install-node:
	@docker exec -it dev /usr/bin/zsh -c "source ~/.zshrc && nvm install node && npm install ijavascript --global && ijsinstall"

shell:
	@docker exec -it $(CONTAINER_NAME) zsh

start:
	docker start --interactive $(CONTAINER_NAME)

server:
	@echo "==> Starting server"

stop:
	docker stop $(CONTAINER_NAME)

#
# Remaining tasks used for local testing and development
#
TEST_NAME = test
build-base-image:
	@docker build --no-cache -t $(BASE_IMAGE_NAME) -f ./dev-with-docker/Dockerfile.base .

build-image: build-base-image
	@docker build --no-cache -t $(TEST_NAME) -f ./dev-with-docker/Dockerfile .

local: build-image
	@docker run -dit --name $(TEST_NAME) --hostname $(HOST_NAME) -p 4669:4669 $(TEST_NAME)

test-shell:
	@docker exec -it $(TEST_NAME) zsh

lint:
	@hadolint ./dev-with-docker/Dockerfile --no-fail
	@hadolint ./dev-with-docker/Dockerfile.base

clean:
	@docker stop $(TEST_NAME)
	@docker rm $(TEST_NAME)
	@docker rmi $(TEST_NAME)