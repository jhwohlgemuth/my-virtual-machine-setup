#
# Development tasks
#
.PHONY: lint
lint: check
	@for image in $(IMAGES) ; do \
        hadolint ./Dockerfile.$$image $(IGNORE_RULES) ; \
    done

.PHONY: check
check:
	@shellcheck ./code-server/install_extensions
	@shellcheck ./provision/scripts/install_code_server.sh
	@shellcheck ./provision/scripts/install_conda.sh
	@shellcheck ./provision/scripts/install_dependencies.sh
	@shellcheck ./provision/scripts/install_dotnet.sh
	@shellcheck ./provision/scripts/install_homebrew.sh
	@shellcheck ./provision/scripts/install_ohmyzsh.sh

.PHONY: format
format:
	@dos2unix ./provision/scripts/install_code_server.sh
	@dos2unix ./provision/scripts/install_conda.sh
	@dos2unix ./provision/scripts/install_dependencies.sh
	@dos2unix ./provision/scripts/install_dotnet.sh
	@dos2unix ./provision/scripts/install_homebrew.sh
	@dos2unix ./provision/scripts/install_ohmyzsh.sh
	@dos2unix ./code-server/service/run
	@dos2unix ./code-server/service/finish
	@dos2unix ./code-server/install_extensions
	@dos2unix ./jupyter/service/run
	@dos2unix ./jupyter/service/finish

.PHONY: build-image
build-image:format
	@docker build --no-cache -t ${CONTAINER_REGISTRY}/${REPO}/${TASK} -f ./Dockerfile.${TASK} .

.PHONY: publish
publish:
	@for image in $(IMAGES) ; do \
        docker push ${CONTAINER_REGISTRY}/${REPO}/$$image ; \
    done

.PHONY: all
all:
	@for image in $(IMAGES) ; do \
        $(MAKE) --no-print-directory $$image ; \
    done

.PHONY: base
base:
	@$(MAKE) TASK=$@ --no-print-directory build-image

.PHONY: dotnet
dotnet:
	@$(MAKE) TASK=$@ --no-print-directory build-image

.PHONY: notebook
notebook:
	@$(MAKE) TASK=$@ --no-print-directory build-image

.PHONY: jvm
jvm:
	@$(MAKE) TASK=$@ --no-print-directory build-image

.PHONY: lambda
lambda:
	@$(MAKE) TASK=$@ --no-print-directory build-image

.PHONY: python
python:
	@$(MAKE) TASK=$@ --no-print-directory build-image

.PHONY: rust
rust:
	@$(MAKE) TASK=$@ --no-print-directory build-image

.PHONY: web
web:
	@$(MAKE) TASK=$@ --no-print-directory build-image
#
# Build variables
#
CONTAINER_REGISTRY = ghcr.io
REPO = jhwohlgemuth
IMAGES = \
	base \
	notebook \
	python \
	rust \
	jvm \
	dotnet \
	web \
	lambda
IGNORE_RULES = \
	--ignore DL3003 \
	--ignore DL3006 \
	--ignore DL3007 \
	--ignore DL3008 \
	--ignore DL3013 \
	--ignore DL4006 \
	--ignore SC1091 \
	--ignore SC2038 \
	--ignore SC2086
