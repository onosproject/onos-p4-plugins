# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

export GO111MODULE=on

WCMP_APP_MOD ?= github.com/onosproject/wcmp-app@master

ONOS_P4_PLUGIN_VERSION := latest
ONOS_BUILD_VERSION := v1.0
ONOS_PROTOC_VERSION := v1.0.2

BASIC_PLUGIN_IMAGE_NAME := p4plugin-docker-basic-1.0.0
BASIC_PLUGIN_TAG_NAME := p4plugin-basic-1.0.0

MIDDLEBLOCK_PLUGIN_IMAGE_NAME := p4plugin-docker-middleblock-1.0.0
BASIC_PLUGIN_TAG_NAME := p4plugin-middleblock-1.0.0

BUF_VERSION := 1.0.0

build-tools:=$(shell if [ ! -d "./build/build-tools" ]; then cd build && git clone https://github.com/onosproject/build-tools.git; fi)
include ./build/build-tools/make/onf-common.mk

mod-update: # @HELP Download the dependencies to the vendor folder
	go mod tidy
	go mod vendor

test: # @HELP run go test on projects
test: mod-update deps build linters license
	go test ./pkg/...

jenkins-test:  # @HELP run the unit tests and source code validation producing a junit style report for Jenkins
jenkins-test: build deps license linters jenkins-tools
	TEST_PACKAGES=`go list github.com/onosproject/onos-p4-plugins/...` ./build/build-tools/build/jenkins/make-unit

PHONY:build
build: # @HELP build all libraries
build: build/_output/basic.so.1.0.0 build/_output/middleblock.so.1.0.0

build/_output/basic.so.1.0.0: # @HELP build the basic.so.1.0.0
	cd plugins/basic && go build -o build/_output/basic.so.1.0.0 -buildmode=plugin .


build/_output/middleblock.so.1.0.0: # @HELP build the middleblock.so.1.0.0
	cd plugins/middleblock && go build -o build/_output/middleblock.so.1.0.0 -buildmode=plugin .


PHONY: p4plugin-docker-basic-1.0.0
p4plugin-docker-basic-1.0.0: # @HELP build basic 1.0.0 plugin Docker image
	./build/bin/build-deps basic ${WCMP_APP_MOD}
	docker build . -f plugins/basic/docker/Dockerfile \
			--build-arg PLUGIN_MAKE_TARGET="basic" \
			--build-arg PLUGIN_MAKE_VERSION="1.0.0" \
			-t onosproject/p4plugin-docker-basic-1.0.0:${ONOS_P4_PLUGIN_VERSION}


PHONY: p4plugin-docker-middleblock-1.0.0
p4plugin-docker-middleblock-1.0.0: # @HELP build basic 1.0.0 plugin Docker image
	./build/bin/build-deps middleblock ${WCMP_APP_MOD}
	docker build . -f plugins/middleblock/docker/Dockerfile \
			--build-arg PLUGIN_MAKE_TARGET="middleblock" \
			--build-arg PLUGIN_MAKE_VERSION="1.0.0" \
			-t onosproject/p4plugin-docker-middleblock-1.0.0:${ONOS_P4_PLUGIN_VERSION}


images: # @HELP build all Docker images
images: build p4plugin-docker-basic-1.0.0 p4plugin-docker-middleblock-1.0.0

kind: # @HELP build Docker images and add them to the currently configured kind cluster
kind: images
	@if [ "`kind get clusters`" = '' ]; then echo "no kind cluster found" && exit 1; fi
	kind load docker-image onosproject/${BASIC_PLUGIN_IMAGE_NAME}:${ONOS_P4_PLUGIN_VERSION}
	kind load docker-image onosproject/${MIDDLEBLOCK_PLUGIN_IMAGE_NAME}:${ONOS_P4_PLUGIN_VERSION}

docker-push-latest: docker-login
	docker push onosproject/p4plugin-docker-basic-1.0.0:latest
	docker push onosproject/p4plugin-docker-middleblock-1.0.0:latest


publish: # @HELP publish version on github and dockerhub
	if ! grep dev plugins/basic/VERSION; then ./build/build-tools/publish-version ${BASIC_PLUGIN_TAG_NAME}/${VERSION} onosproject/${BASIC_PLUGIN_IMAGE_NAME}; fi

jenkins-publish: images docker-push-latest # @HELP Jenkins calls this to publish artifacts
	VERSIONFILE=plugins/basic/VERSION ./build/build-tools/release-merge-commit

clean:: # @HELP remove all the build artifacts
	rm -rf ./build/_output ./vendor ./cmd/onos-p4-plugins/onos-p4-plugins
	rm -fr plugins/*/vendor
	rm -rf ./build/_input
	go clean -testcache github.com/onosproject/onos-p4-plugins/...