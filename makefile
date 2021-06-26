PROJECT_NAME ?= tnt-web
PROJECT_NAMESPACE ?= oleggr
REGISTRY_IMAGE ?= $(PROJECT_NAMESPACE)/$(PROJECT_NAME)

all:
	@echo "make local	- Run app locally"
	@echo "make build	- Build app image by Dockerfile"
	@echo "make run		- Run app locally by Dockerfile"
	@exit 0

local:
	docker-compose up -d

build:
	docker build -t my-tnt .

run:
	docker run -dp 8080:8080 my-tnt
