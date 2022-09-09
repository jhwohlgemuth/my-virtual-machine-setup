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
	@$(MAKE) NAME=$@ --no-print-directory install-ijavascript

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

notebook:
	@$(MAKE) NAME=$@ --no-print-directory create-notebook
	@$(MAKE) NAME=$@ --no-print-directory setup

setup: copy-ssh-config copy-git-config install-node

shell:
	@docker start $(ENV_NAME)
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
DATA_SCIENCE_PACKAGES = \
	chainer \
	drawdata \
	gdown \
	keras \
	matplotlib \
	numpy \
	pandas \
	polars \
	seaborn \
	tensorflow \
	torch \
	torchaudio \
	torchvision \
	transformers
NLP_PACKAGES = \
	en_core_web_sm \
	en_core_web_trf \
	gensim \
	ludwig \
	nltk \
	polyglot \
	spacy \
	textblob
TASKS = \
	copy-git-config \
	copy-ssh-config \
	create-env \
	create-notebook \
	env \
	install-ijavascript \
	install-node \
	notebook \
	setup \
	shell