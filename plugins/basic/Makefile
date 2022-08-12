# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

export GO111MODULE=on

build-tools:=$(shell if [ ! -d "./build/build-tools" ]; then cd build && git clone https://github.com/onosproject/build-tools.git; fi)
include ./build/build-tools/make/onf-common.mk


test: # @HELP run go test on projects
test: build linters license


PHONY: build
build: build-basic

build-basic: # @HELP build all libraries
build-basic:
	go build  -o build/_output/basic.so.1.0.0 -buildmode=plugin .