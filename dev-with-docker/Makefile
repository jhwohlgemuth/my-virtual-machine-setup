IMAGE_NAME = dev
CONTAINER_NAME = $(IMAGE_NAME)

init: build
	@docker run -dit --name $(CONTAINER_NAME) -p 1337:1337 -p 4669:4669 -p 46692:46692 $(IMAGE_NAME)
	@docker ps --latest

build:
	@docker build -t $(CONTAINER_NAME) .

shell:
	@docker exec -it $(CONTAINER_NAME) zsh

start:
	docker start --interactive $(CONTAINER_NAME)

stop:
	docker stop $(CONTAINER_NAME)