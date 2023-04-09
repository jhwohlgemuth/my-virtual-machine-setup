.PHONY: $(TASKS)
#
# Development tasks
#
lint: check
	@hadolint ./Dockerfile.base $(IGNORE_RULES)
	@hadolint ./Dockerfile $(IGNORE_RULES)
	@hadolint ./Dockerfile.notebook $(IGNORE_RULES)

check:
	@shellcheck ./provision/scripts/install_conda.sh
	@shellcheck ./provision/scripts/install_dependencies.sh
	@shellcheck ./provision/scripts/install_dotnet.sh
	@shellcheck ./provision/scripts/install_homebrew.sh
	@shellcheck ./provision/scripts/install_ohmyzsh.sh

format:
	@dos2unix ./provision/scripts/install_conda.sh
	@dos2unix ./provision/scripts/install_dependencies.sh
	@dos2unix ./provision/scripts/install_dotnet.sh
	@dos2unix ./provision/scripts/install_homebrew.sh
	@dos2unix ./provision/scripts/install_ohmyzsh.sh

base: format
	@$(MAKE) TASK=$@ --no-print-directory build-image

jupyter: format
	@$(MAKE) TASK=$@ --no-print-directory build-image

build-image:
	@docker build --no-cache -t ${CONTAINER_REGISTRY}/${REPO}/${TASK} -f ./Dockerfile.${TASK} .
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
TASKS = \
	base \
	lint \
	check \
	format
