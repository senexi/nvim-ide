
ARCH=amd64

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build_base: ## Build the container
	cd base && bash build.sh
build_devops: ## Build the container
	cd devops && bash build.sh

build: build_base build_devops
	echo "build all"
publish_base:
	cd base && bash publish.sh
publish_devops:
	cd devops && bash publish.sh

publish: publish_base publish_devops
	echo "publish all"
