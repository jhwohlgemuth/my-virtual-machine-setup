.PHONY: $(TASKS)
#
# Development tasks
#
lint: check
	@hadolint ./Dockerfile.base $(IGNORE_RULES)
	@hadolint ./Dockerfile $(IGNORE_RULES)
	@hadolint ./Dockerfile.notebook $(IGNORE_RULES)

check:
	@shellcheck ./provision/install_conda.sh
	@shellcheck ./provision/install_dependencies.sh
	@shellcheck ./provision/install_dotnet.sh
	@shellcheck ./provision/install_homebrew.sh
	@shellcheck ./provision/install_ohmyzsh.sh

format:
	@dos2unix ./provision/install_conda.sh
	@dos2unix ./provision/install_dependencies.sh
	@dos2unix ./provision/install_dotnet.sh
	@dos2unix ./provision/install_homebrew.sh
	@dos2unix ./provision/install_ohmyzsh.sh

build-all: base-image env-image build-notebook

base-image:
	@docker build --no-cache -t $(BASE_IMAGE_NAME) -f ./Dockerfile.base .

env-image:
	@docker build --no-cache -t $(ENV_IMAGE_NAME) -f ./Dockerfile .

build-notebook:
	@docker build --no-cache -t $(NOTEBOOK_IMAGE_NAME) -f ./Dockerfile.notebook .
#
# Build variables
#
REPO = jhwohlgemuth
BASE_IMAGE_NAME = "${REPO}/base"
ENV_IMAGE_NAME = "${REPO}/${ENV_NAME}"
NOTEBOOK_IMAGE_NAME = "${REPO}/${NOTEBOOK_NAME}"
ENV_NAME = env
NOTEBOOK_NAME = notebook
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
	build-all \
	build-notebook \
	base-image \
	env-image \
	lint \
	check \
	format
