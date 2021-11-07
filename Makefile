TASKS = \
	build-all \
	build-base \
	build-env \
	build-notebook \
	copy-git-config \
	copy-ssh-config \
	create-env \
	create-notebook \
	install-ijavascript \
	install-node \
	lint \
	server \
	setup \
	shell \
	start \
	test \
	test-shell \
	tunnel

.PHONY: $(TASKS)

lint:
	@hadolint ./dev-with-docker/Dockerfile.base $(IGNORE_RULES)
	@hadolint ./dev-with-docker/Dockerfile $(IGNORE_RULES)
	@hadolint ./dev-with-docker/Dockerfile.notebook $(IGNORE_RULES)

setup: copy-ssh-config copy-git-config install-node

env:
	@$(MAKE) --no-print-directory create-env NAME=$@
	@$(MAKE) --no-print-directory setup NAME=$@

notebook:
	@$(MAKE) --no-print-directory create-notebook NAME=$@
	@$(MAKE) --no-print-directory setup NAME=$@
	@$(MAKE) --no-print-directory install-ijavascript NAME=$@

create-env:
	@docker run -dit --name $(ENV_NAME) --hostname $(HOST_NAME) -v $(HOME_PATH)\dev:/root/dev -p 8000:8000 -p 8080:8080 -p 8111:8111 -p 1337:1337 -p 3449:3449 -p 4669:4669 -p 46692:46692 $(ENV_IMAGE)
	@echo "==> Created ${NAME} container"

create-notebook:
	@docker run -dit --restart unless-stopped --name $(NOTEBOOK_NAME) --hostname $(HOST_NAME) -v $(HOME_PATH)\dev\notebooks:/root/dev/notebooks -p 4669:4669 $(NOTEBOOK_IMAGE)
	@echo "==> Created ${NAME} container"

copy-ssh-config:
	@docker exec -it $(NAME) /bin/bash -c "mkdir -p /root/.ssh"
	@IF EXIST $(SSH_KEY) \
		docker cp $(SSH_KEY) $(NAME):/root/.ssh/
	@IF EXIST $(SSH_KEY) \
		docker exec -it $(NAME) /bin/bash -c "chmod 600 /root/.ssh/id_ed25519"
	@IF EXIST $(SSH_KEY) \
		echo "==> Copied SSH key to ${NAME}"
	@IF EXIST $(SSH_CONFIG) \
		docker cp $(SSH_CONFIG) $(NAME):/root/.ssh/
	@IF EXIST $(SSH_CONFIG) \
		echo "==> Copied SSH configuration to ${NAME}"

copy-git-config:
	@IF EXIST $(GIT_CONFIG) \
		docker cp $(GIT_CONFIG) $(NAME):/root/
	@IF EXIST $(GIT_CONFIG) \
		echo "==> Copied .gitconfig file to ${NAME}"

install-node:
	@docker exec -it $(NAME) /usr/bin/zsh -c "source ~/.zshrc && nvm install node"

install-ijavascript:
	@docker exec -it $(NAME) /usr/bin/zsh -c "export NODE_OPTIONS=--max-old-space-size=8192 && cd /root/dev/notebooks && source ~/.zshrc && npm init -y && npm install ijavascript && node_modules/ijavascript/bin/ijsinstall.js --spec-path=full"

data-science:
	@docker exect -it $(NAME) /usr/bin/zsh -c "pip install numpy pandas keras matplotlib"

shell:
	@docker exec -it $(ENV_NAME) zsh

start:
	docker start --interactive $(ENV_NAME)

#
# Development tasks
#
build-all: build-base build-env build-notebook

build-base:
	@docker build --no-cache -t $(BASE_IMAGE) -f ./dev-with-docker/Dockerfile.base .

build-env:
	@docker build --no-cache -t $(ENV_IMAGE) -f ./dev-with-docker/Dockerfile .

build-notebook:
	@docker build --no-cache -t $(NOTEBOOK_IMAGE) -f ./dev-with-docker/Dockerfile.notebook .

test:
	@docker run -dit --name $(TEST_NAME) --hostname $(HOST_NAME) -p 4669:4669 $(ENV_IMAGE)

test-shell:
	@docker exec -it $(TEST_NAME) zsh

#
# Build variables
#
args = $(foreach a,$($(subst -,_,$1)_args),$(if $(value $a),$a="$($a)"))
HOST_NAME = $(shell hostname)
HOME_PATH = $(shell echo %userprofile%)
SSH_KEY = "${HOME_PATH}\.ssh\id_ed25519"
SSH_CONFIG = "${HOME_PATH}\.ssh\config"
GIT_CONFIG = "${HOME_PATH}\.gitconfig"
NOTEBOOK_DIR = "${HOME_PATH}\dev\notebooks"
BASE_IMAGE = jhwohlgemuth/base
ENV_IMAGE = jhwohlgemuth/env
NOTEBOOK_IMAGE = jhwohlgemuth/notebook
TEST_NAME = test
ENV_NAME = env
NOTEBOOK_NAME = notebook
JUPYTER_HOST = veda
JUPYTER_PORT = 4669
IGNORE_RULES = --ignore DL3006 --ignore DL3008 --ignore DL3013 --ignore DL4006