.PHONY: $(TASKS)

copy-git-config:
	@IF EXIST $(GIT_CONFIG) \
		docker cp $(GIT_CONFIG) $(NAME):/root/
	@IF EXIST $(GIT_CONFIG) \
		echo "==> Copied .gitconfig file to ${NAME}"

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

create-env:
	@docker run -dit \
		--init \
		--gpus all \
		--security-opt seccomp=unconfined \
		--name $(ENV_NAME) \
		--hostname $(HOST_NAME) \
		--volume $(HOME_PATH)\dev:/root/dev \
		-p 8000:8000 \
		-p 8080:8080 \
		-p 8111:8111 \
		-p 1337:1337 \
		-p 3449:3449 \
		-p 4669:4669 \
		-p 46692:46692 \
		$(ENV_IMAGE_NAME)
	@echo "==> Created ${NAME} container"

create-notebook:
	@docker run -dit \
		--init \
		--gpus all \
		--restart unless-stopped \
		--name $(NOTEBOOK_NAME) \
		--hostname $(HOST_NAME) \
		--volume $(NOTEBOOK_DIR):/root/dev/notebooks \
		-p 4669:4669 \
		$(NOTEBOOK_IMAGE_NAME)
	@echo "==> Created ${NAME} container"

gis:
	@$(MAKE) TASK=$@ CONTAINER=$(ENV_NAME) --no-print-directory create-conda-env

ml:
	@$(MAKE) TASK=$@ CONTAINER=$(ENV_NAME) --no-print-directory create-conda-env

nlp:
	@$(MAKE) TASK=$@ CONTAINER=$(ENV_NAME) --no-print-directory create-conda-env

quantum:
	@$(MAKE) TASK=$@ CONTAINER=$(ENV_NAME) --no-print-directory create-conda-env

create-conda-env: start
	@docker cp ./dev-with-docker/provision/environment.${TASK}.yml ${CONTAINER}:/root
	@docker exec -it ${CONTAINER} /bin/zsh -c "cd /root && /root/miniconda3/bin/mamba env create -f environment.${TASK}.yml"

env:
	@$(MAKE) NAME=$@ --no-print-directory create-env
	@$(MAKE) NAME=$@ --no-print-directory setup

install-node:
	@docker exec -it \
		$(NAME) \
		/usr/bin/zsh \
		-c "source ~/.zshrc && nvm install node"

install-ijavascript:
	@docker exec -it \
		$(NAME) \
		/usr/bin/zsh \
		-c "cd /root/dev/notebooks && source ~/.zshrc && npm init -y && npm install ijavascript && node_modules/ijavascript/bin/ijsinstall.js --spec-path=full"
	@$(MAKE) NAME=$@ --no-print-directory install-ijavascript

notebook:
	@$(MAKE) NAME=$@ --no-print-directory create-notebook
	@$(MAKE) NAME=$@ --no-print-directory setup

setup: copy-ssh-config copy-git-config install-node

start:
	@docker start $(ENV_NAME)

shell: start
	@docker attach $(ENV_NAME)
#
# Build variables
#
REPO = jhwohlgemuth
HOST_NAME = $(shell hostname)
HOME_PATH = $(shell echo %userprofile%)
SSH_KEY = "${HOME_PATH}\.ssh\id_ed25519"
SSH_CONFIG = "${HOME_PATH}\.ssh\config"
GIT_CONFIG = "${HOME_PATH}\.gitconfig"
NOTEBOOK_DIR = "${HOME_PATH}\dev\notebooks"
ENV_IMAGE_NAME = "${REPO}/${ENV_NAME}"
NOTEBOOK_IMAGE_NAME = "${REPO}/${NOTEBOOK_NAME}"
ENV_NAME = env
NOTEBOOK_NAME = notebook
TASKS = \
	copy-git-config \
	copy-ssh-config \
	create-env \
	create-notebook \
	env \
	install-ijavascript \
	install-node \
	gis \
	ml \
	nlp \
	notebook \
	quantum \
	setup \
	shell \
	start