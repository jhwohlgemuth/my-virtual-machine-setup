.PHONY: $(TASKS)

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
	install-node