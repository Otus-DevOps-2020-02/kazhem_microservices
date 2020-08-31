# mongodb_exporter
MONGODB_EXPORTER_DOCKER_IMAGE_NAME?=${USER_NAME}/mongodb-exporter
MONGODB_EXPORTER_VERSION?=v0.11.0


###
# mongodb_exporter
###
mongodb_exporter_clone:
	cd ./monitoring \
	&& (test -d ./mongodb_exporter || git clone https://github.com/percona/mongodb_exporter.git)

mongodb_exporter_docker_build: mongodb_exporter_clone
	cd ./monitoring/mongodb_exporter \
	&& git checkout ${MONGODB_EXPORTER_VERSION} \
	&& make docker DOCKER_IMAGE_NAME=${MONGODB_EXPORTER_DOCKER_IMAGE_NAME} DOCKER_IMAGE_TAG=${MONGODB_EXPORTER_VERSION}

mongodb_exporter_push:
	docker push ${MONGODB_EXPORTER_DOCKER_IMAGE_NAME}:${MONGODB_EXPORTER_VERSION}

###
# Build
###
build_comment:
	cd src/comment && bash ./docker_build.sh

build_post:
	cd src/post-py && bash ./docker_build.sh

build_ui:
	cd src/ui && bash ./docker_build.sh

build_prometheus:
	cd ./monitoring/prometheus && bash docker_build.sh

build: build_post build_comment build_ui build_prometheus mongodb_exporter_docker_build


###
# Push
###
push_comment:
	docker push ${USER_NAME}/comment

push_post:
	docker push ${USER_NAME}/post

push_ui:
	docker push ${USER_NAME}/ui

push_prometheus:
	docker push ${USER_NAME}/prometheus

push: push_comment push_post push_ui push_prometheus mongodb_exporter_push


###
# alertmanager
###
alertmanager_build:
	cd ./monitoring/alertmanager && bash docker_build.sh

alertmanager_push:
	docker push ${USER_NAME}/alertmanager

###
# fluentd
###
fluentd_build:
	cd ./logging/fluentd && bash docker_build.sh

fluentd_push:
	docker push $${USER_NAME}/fluentd

# app down
###
down_app:
	cd docker \
	&& docker-compose down

down_monitoring:
	cd docker \
	&& docker-compose -f docker-compose-monitoring.yml down

down_logging:
	cd docker \
	&& docker-compose -f docker-compose-logging.yml down


###
# run
###
run_app:
	cd docker \
	&& docker-compose up -d

run_monitoring:
	cd docker \
	&& docker-compose -f docker-compose-monitoring.yml up -d

run_logging:
	cd docker \
	&& docker-compose -f docker-compose-logging.yml up -d
