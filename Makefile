.PHONY: $(TASKS)

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

ENV_NAME = env
TASKS = \
	install-ijavascript \
	install-node \
	gis \
	ml \
	nlp \
	notebook \
	quantum