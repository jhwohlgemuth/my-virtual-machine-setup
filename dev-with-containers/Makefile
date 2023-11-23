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
	@for script in $(SCRIPTS) ; do \
        shellcheck $$script; \
    done
	@for fn in $(FUNCTIONS) ; do \
        shellcheck $$fn; \
    done

.PHONY: format
format:
	@for script in $(SCRIPTS) ; do \
        dos2unix $$script; \
    done
	@for file in $(FILES) ; do \
        dos2unix $$file; \
    done

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

.PHONY: dev
dev:
	@$(MAKE) TASK=$@ --no-print-directory build-image

.PHONY: dotnet
dotnet:
	@$(MAKE) TASK=$@ --no-print-directory build-image

.PHONY: elixir
elixir:
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
	dev \
	notebook \
	python \
	jvm \
	rust \
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
SCRIPTS = \
	./code-server/install_extensions.sh \
	./provision/scripts/install_aeneas.sh \
	./provision/scripts/install_apptainer.sh \
	./provision/scripts/install_code_server.sh \
	./provision/scripts/install_conda.sh \
	./provision/scripts/install_coq.sh \
	./provision/scripts/install_dependencies.sh \
	./provision/scripts/install_dotnet.sh \
	./provision/scripts/install_dotnet_jupyter_kernel.sh \
	./provision/scripts/install_homebrew.sh \
	./provision/scripts/install_nix.sh \
	./provision/scripts/install_ohmyzsh.sh \
	./provision/scripts/install_ocaml.sh \
	./provision/scripts/install_provers.sh \
	./provision/scripts/install_ruby.sh \
	./provision/scripts/install_wasm_runtimes.sh
FUNCTIONS = \
	./provision/functions/cleanup \
	./provision/functions/is_command \
	./provision/functions/is_installed \
	./provision/functions/requires
FILES = \
	./code-server/service/finish \
	./code-server/service/run \
	./jupyter/service/finish \
	./jupyter/service/run \
	./verdaccio/service/finish \
	./verdaccio/service/log \
	./verdaccio/service/run \
	./config/.p10k.zsh \
	./config/utoprc
