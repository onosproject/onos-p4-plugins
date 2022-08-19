# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

export GO111MODULE=on


test: # @HELP run go test on projects
test: build


PHONY: build
build: build-middleblock-config

build-middleblock-config: # @HELP build all libraries
build-middleblock-config:
	go build  -o build/_output/middleblock-config.so.1.0.0 -buildmode=plugin .