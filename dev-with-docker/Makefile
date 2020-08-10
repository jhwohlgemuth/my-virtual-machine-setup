IMAGE_NAME = dev
CONTAINER_NAME = $(IMAGE_NAME)

build:
	docker build -t $(CONTAINER_NAME) .

create: 
	docker run -it --name $(CONTAINER_NAME) -p 1337:1337 -p 4669:4669 -p 46692:46692 $(IMAGE_NAME)

start:
	docker start --interactive $(CONTAINER_NAME)

stop:
	docker stop $(CONTAINER_NAME)