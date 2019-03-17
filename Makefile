SNAME ?= tf-jupyterlab
NAME ?= elswork/$(SNAME)
VER ?= `cat VERSION`
VEROCV ?=
OCV ?=  
BASE ?= tf-opencv
#BASE ?= tensorflow-diy
BASENAME ?= elswork/$(BASE)
ARCH2 ?= armv7l
GOARCH := $(shell uname -m)
ifeq ($(GOARCH),x86_64)
	GOARCH := amd64
endif
ifeq ($(BASE),tf-opencv)
	#NAME := elswork/tf-juplab-ocv
	VEROCV := -3.4.3
	OCV := _ocv
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
	--build-arg VERSION=$(SNAME)_$(GOARCH)_$(VER)$(OCV)$(VEROCV) .

build: ## Build the container
	docker build --no-cache -t $(NAME):$(GOARCH)$(OCV) --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BASEIMAGE=$(BASENAME):$(GOARCH)_$(VER)$(VEROCV) \
	--build-arg VERSION=$(SNAME)_$(GOARCH)_$(VER)$(OCV)$(VEROCV) . > ../builds/$(SNAME)_$(GOARCH)_$(VER)$(OCV)$(VEROCV)_`date +"%Y%m%d_%H%M%S"`.txt
tag: ## Tag the container
	docker tag $(NAME):$(GOARCH)$(OCV) $(NAME):$(GOARCH)_$(VER)$(OCV)$(VEROCV)
push: ## Push the container
	docker push $(NAME):$(GOARCH)_$(VER)$(OCV)$(VEROCV)
	docker push $(NAME):$(GOARCH)$(OCV)	
deploy: build tag push
manifest: ## Create an push manifest
	docker manifest create $(NAME):$(VER)$(OCV) $(NAME):$(GOARCH)_$(VER)$(OCV)$(VEROCV) $(NAME):$(ARCH2)_$(VER)$(OCV)$(VEROCV)
	docker manifest push --purge $(NAME):$(VER)$(OCV)
	docker manifest create $(NAME):latest$(OCV) $(NAME):$(GOARCH)$(OCV) $(NAME):$(ARCH2)$(OCV)
	docker manifest push --purge $(NAME):latest$(OCV)
start: ## Start the container
	docker run -d -p 8888:8888 -p 0.0.0.0:6006:6006 --restart=unless-stopped $(NAME):$(GOARCH)$(OCV)