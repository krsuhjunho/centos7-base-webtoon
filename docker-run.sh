#!/bin/bash

#VAR
DOCKER_CONTAINER_NAME="centos7-base-webtoon"
CONTAINER_HOST_NAME="centos7-base-webtoon"
SSH_PORT=22444
HTTP_PORT=8011
BASE_IMAGE_NAME="ghcr.io/krsuhjunho/centos7-base-webtoon"
SERVER_IP=$(curl -s ifconfig.me)
HTTP_BASE="http://"
TODAY=$(date "+%Y-%m-%d")
TIME_ZONE="Asia/Tokyo"
COMMIT_COMMENT="$2"
BUILD_OPTION="$1"

DOCKER_IMAGE_BUILD()
{
	docker build -t ${BASE_IMAGE_NAME} .
}



DOCKER_IMAGE_PUSH()
{
	docker push ${BASE_IMAGE_NAME}
}

GIT_COMMIT_PUSH()
{
	git add -u
	git commit -a -m "${TODAY} ${COMMIT_COMMENT}"
	git config credential.helper store
	git push origin main
}

DOCKER_CONTAINER_REMOVE()
{
	docker rm -f ${DOCKER_CONTAINER_NAME}
}

DOCKER_CONTAINER_CREATE()
{
	docker run -tid --privileged=true \
	-h "${CONTAINER_HOST_NAME}" \
	--name="${DOCKER_CONTAINER_NAME}" \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
	-v /etc/localtime:/etc/localtime:ro \
	-v /webtoon/www/html:/var/www/html/ \
	--restart=always \
	-e TZ=${TIME_ZONE} \
	-p ${HTTP_PORT}:80 \
	${BASE_IMAGE_NAME}

}

DOCKER_CONTAINER_BASH()
{
	docker exec -it ${DOCKER_CONTAINER_NAME} /bin/bash 
}

DOCKER_VOLUME_CREATE()
{
	docker volume create webtoon
}


MAIN()
{

	if [ "$BUILD_OPTION" == "--build" ]; then
		DOCKER_IMAGE_BUILD		
		DOCKER_IMAGE_PUSH
		GIT_COMMIT_PUSH
		DOCKER_VOLUME_CREATE
	fi
	
	DOCKER_CONTAINER_REMOVE	
	DOCKER_CONTAINER_CREATE
}

MAIN
