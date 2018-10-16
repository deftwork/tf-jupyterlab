NAME ?= elswork/tf-jupyterlab


build:
	docker build --no-cache -t $(NAME):amd64 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg VERSION=amd64-`cat VERSION` . > ../builds/tf-juplab_`date +"%Y%m%d_%H%M%S"`.txt
tag:
	docker tag $(NAME):amd64 $(NAME):amd64-`cat VERSION`
push:
	docker push $(NAME):amd64-`cat VERSION`
	docker push $(NAME):amd64	
deploy: build tag push
manifest:
	docker manifest create $(NAME):`cat VERSION` $(NAME):amd64-`cat VERSION` \
	$(NAME):arm32v7-`cat VERSION`
	docker manifest push --purge $(NAME):`cat VERSION`
	docker manifest create $(NAME):latest $(NAME):amd64 $(NAME):arm32v7
	docker manifest push --purge $(NAME):latest
start:
	docker run -d -p 8888:8888 -p 0.0.0.0:6006:6006 --restart=unless-stopped $(NAME):amd64

build-arm:
	docker build --no-cache -t $(NAME):arm32v7 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg VERSION=arm32v7-`cat VERSION` . > ../builds/tf-juplab-arm_`date +"%Y%m%d_%H%M%S"`.txt
tag-arm:
	docker tag $(NAME):arm32v7 $(NAME):arm32v7-`cat VERSION`
push-arm:
	docker push $(NAME):arm32v7-`cat VERSION`
	docker push $(NAME):arm32v7	
deploy-arm: build-arm tag-arm push-arm
start-arm:
	docker run -d -p 8888:8888 -p 0.0.0.0:6006:6006 --restart=unless-stopped $(NAME):arm32v7
