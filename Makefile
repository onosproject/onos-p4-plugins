# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

export GO111MODULE=on

build-tools:=$(shell if [ ! -d "./build/build-tools" ]; then cd build && git clone https://github.com/onosproject/build-tools.git; fi)
include ./build/build-tools/make/onf-common.mk

mod-update: # @HELP Download the dependencies to the vendor folder
	go mod tidy
	go mod vendor

test: # @HELP run go test on projects
test: mod-update deps build linters license


PHONY: build
build: build-basic build-middleblock

build-basic: # @HELP build all libraries
build-basic:
	cd plugins/basic && go build  -o build/_output/basic.so.1.0.0 -buildmode=plugin .

build-middleblock:
	cd plugins/middleblock && go build  -o build/_output/middleblock.so.1.0.0 -buildmode=plugin .


clean:: # @HELP remove all the build artifacts
	rm -rf ./build/_output ./vendor ./cmd/onos-p4-plugins/onos-p4-plugins
	rm -fr plugins/*/vendor
	rm -rf ./build/_input
	go clean -testcache github.com/onosproject/onos-p4-plugins/...
