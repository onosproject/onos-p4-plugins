# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

export GO111MODULE=on

WCMP_APP_MOD ?= github.com/onosproject/wcmp-app@master

ONOS_P4_PLUGIN_VERSION := latest
ONOS_BUILD_VERSION := v1.0
ONOS_PROTOC_VERSION := v1.0.2

BUF_VERSION := 1.0.0

build-tools:=$(shell if [ ! -d "./build/build-tools" ]; then cd build && git clone https://github.com/onosproject/build-tools.git; fi)
include ./build/build-tools/make/onf-common.mk

PHONY:build
build: # @HELP build all libraries
build: build/_output/basic.so.1.0.0

build/_output/basic.so.1.0.0: # @HELP build the basic.so.1.0.0
	cd plugins/basic && go build -o build/_output/basic.so.1.0.0 -buildmode=plugin .


PHONY: p4plugin-docker-basic-1.0.0
p4plugin-docker-basic-1.0.0: # @HELP build basic 1.0.0 plugin Docker image
	./build/bin/build-deps basic ${WCMP_APP_MOD}
	docker build . -f plugins/basic/docker/Dockerfile \
			--build-arg PLUGIN_MAKE_TARGET="basic" \
			--build-arg PLUGIN_MAKE_VERSION="1.0.0" \
			-t onosproject/p4plugin-docker-basic-1.0.0:${ONOS_P4_PLUGIN_VERSION}


images: # @HELP build all Docker images
images: build p4plugin-docker-basic-1.0.0

kind: # @HELP build Docker images and add them to the currently configured kind cluster
kind: images
	@if [ "`kind get clusters`" = '' ]; then echo "no kind cluster found" && exit 1; fi
	kind load docker-image onosproject/p4plugin-docker-basic-1.0.0:${ONOS_P4_PLUGIN_VERSION}