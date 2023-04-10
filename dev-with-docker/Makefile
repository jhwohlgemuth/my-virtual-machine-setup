#
# Development tasks
#
.PHONY: lint
lint: check
	@hadolint ./Dockerfile.base $(IGNORE_RULES)
	@hadolint ./Dockerfile $(IGNORE_RULES)
	@hadolint ./Dockerfile.notebook $(IGNORE_RULES)

.PHONY: check
check:
	@shellcheck ./provision/scripts/install_conda.sh
	@shellcheck ./provision/scripts/install_dependencies.sh
	@shellcheck ./provision/scripts/install_dotnet.sh
	@shellcheck ./provision/scripts/install_homebrew.sh
	@shellcheck ./provision/scripts/install_ohmyzsh.sh

.PHONY: format
format:
	@dos2unix ./provision/scripts/install_conda.sh
	@dos2unix ./provision/scripts/install_dependencies.sh
	@dos2unix ./provision/scripts/install_dotnet.sh
	@dos2unix ./provision/scripts/install_homebrew.sh
	@dos2unix ./provision/scripts/install_ohmyzsh.sh

.PHONY: build-image
build-image:format
	@docker build --no-cache -t ${CONTAINER_REGISTRY}/${REPO}/${TASK} -f ./Dockerfile.${TASK} .

.PHONY: base
base:
	@$(MAKE) TASK=$@ --no-print-directory build-image

.PHONY: jupyter
jupyter:
	@$(MAKE) TASK=$@ --no-print-directory build-image

.PHONY: python
python:
	@$(MAKE) TASK=$@ --no-print-directory build-image

.PHONY: rust
rust:
	@$(MAKE) TASK=$@ --no-print-directory build-image

#
# Build variables
#
CONTAINER_REGISTRY = ghcr.io
REPO = jhwohlgemuth
IGNORE_RULES = \
	--ignore DL3003 \
	--ignore DL3006 \
	--ignore DL3008 \
	--ignore DL3013 \
	--ignore DL4006 \
	--ignore SC1091 \
	--ignore SC2038 \
	--ignore SC2086
