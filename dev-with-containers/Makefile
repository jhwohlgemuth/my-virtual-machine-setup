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
	@for fn in $(FUNCTIONS) ; do \
        dos2unix $$fn; \
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

.PHONY: gold
gold: format
	@docker build --no-cache -t ${CONTAINER_REGISTRY}/${REPO}/${TASK} -f ./Dockerfile .

.PHONY: dev
dev:
	@$(MAKE) TASK=$@ --no-print-directory build-image

.PHONY: notebook
notebook:
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
	rust \
	web \
	gold
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
	./provision/scripts/dev/configure_locale.sh \
	./provision/scripts/dev/configure_ohmyzsh.sh \
	./provision/scripts/dev/install_apptainer.sh \
	./provision/scripts/dev/install_dependencies.sh \
	./provision/scripts/dev/install_docker.sh \
	./provision/scripts/dev/install_dotnet.sh \
	./provision/scripts/dev/install_homebrew.sh \
	./provision/scripts/dev/install_nix.sh \
	./provision/scripts/dev/install_ohmyzsh.sh \
	./provision/scripts/gold/install_aeneas.sh \
	./provision/scripts/gold/install_coq.sh \
	./provision/scripts/gold/install_creusot.sh \
	./provision/scripts/gold/install_ocaml.sh \
	./provision/scripts/gold/install_provers.sh \
	./provision/scripts/gold/install_verus.sh \
	./provision/scripts/notebook/install_code_server.sh \
	./provision/scripts/notebook/install_extensions.sh \
	./provision/scripts/notebook/install_conda.sh \
	./provision/scripts/notebook/install_dotnet_jupyter_kernel.sh \
	./provision/scripts/notebook/install_elixir.sh \
	./provision/scripts/notebook/install_elixir_jupyter_kernel.sh \
	./provision/scripts/notebook/install_nim.sh \
	./provision/scripts/notebook/install_scala_jupyter_kernel.sh \
	./provision/scripts/install_all_the_things.sh \
	./provision/scripts/install_wasm_runtimes.sh
FUNCTIONS = \
	./provision/functions/cleanup \
	./provision/functions/is_command \
	./provision/functions/is_installed \
	./provision/functions/move_lines \
	./provision/functions/remove_empty_lines \
	./provision/functions/requires
FILES = \
	./config/code-server/service/finish \
	./config/code-server/service/run \
	./config/jupyter/service/finish \
	./config/jupyter/service/run \
	./config/verdaccio/service/finish \
	./config/verdaccio/service/log \
	./config/verdaccio/service/run \
	./config/.utoprc \
	./config/init.ml
