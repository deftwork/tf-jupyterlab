NAME ?= elswork/tf-jupyterlab


start:
	docker run -d -p 8888:8888 -p 0.0.0.0:6006:6006 --restart=unless-stopped $(NAME):latest
build:
	docker build --no-cache -t $(NAME):latest --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg VERSION=latest-`cat VERSION` . > ../builds/tf-juplab_`date +"%Y%m%d_%H%M%S"`.txt
tag:
	docker tag $(NAME):latest $(NAME):latest-`cat VERSION`
push:
	docker push $(NAME):latest-`cat VERSION`
	docker push $(NAME):latest	
deploy: build tag push

start-arm:
	docker run -d -p 8888:8888 -p 0.0.0.0:6006:6006 --restart=unless-stopped $(NAME):arm32v7
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
