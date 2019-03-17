SNAME ?= tf-jupyterlab
NAME ?= elswork/$(SNAME)
VER ?= `cat VERSION`
VEROCV ?= 
BASE ?= tf-opencv
#BASE ?= tensorflow-diy
BASENAME ?= elswork/$(BASE)
ARCH2 ?= armv7l
GOARCH := $(shell uname -m)
ifeq ($(GOARCH),x86_64)
	GOARCH := amd64
endif
ifeq ($(BASE),tf-opencv)
	NAME := elswork/tf-juplab-ocv
	VEROCV := -3.4.3
endif

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
# Build the container

debug: ## Build the container
	docker build -t $(NAME):$(GOARCH) --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BASEIMAGE=$(BASENAME):$(GOARCH)_$(VER)$(VEROCV) \
	--build-arg VERSION=$(SNAME)_$(GOARCH)_$(VER) .

build: ## Build the container
	docker build --no-cache -t $(NAME):$(GOARCH) --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BASEIMAGE=$(BASENAME):$(GOARCH)_$(VER)$(VEROCV) \
	--build-arg VERSION=$(SNAME)_$(GOARCH)_$(VER) . > ../builds/$(SNAME)_$(GOARCH)_$(VER)_`date +"%Y%m%d_%H%M%S"`.txt
tag: ## Tag the container
	docker tag $(NAME):$(GOARCH) $(NAME):$(GOARCH)_$(VER)
push: ## Push the container
	docker push $(NAME):$(GOARCH)_$(VER)
	docker push $(NAME):$(GOARCH)	
deploy: build tag push
manifest: ## Create an push manifest
	docker manifest create $(NAME):$(VER) $(NAME):$(GOARCH)_$(VER) $(NAME):$(ARCH2)_$(VER)
	docker manifest push --purge $(NAME):$(VER)
	docker manifest create $(NAME):latest $(NAME):$(GOARCH) $(NAME):$(ARCH2)
	docker manifest push --purge $(NAME):latest
start: ## Start the container
	docker run -d -p 8888:8888 -p 0.0.0.0:6006:6006 --restart=unless-stopped $(NAME):$(GOARCH)