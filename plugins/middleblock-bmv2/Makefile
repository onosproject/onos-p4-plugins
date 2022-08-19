# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

export GO111MODULE=on


test: # @HELP run go test on projects
test: build


PHONY: build
build: build-middleblock-bmv2

build-middleblock-config: # @HELP build all libraries
build-middleblock-bmv2:
	go build  -o build/_output/middleblock-bmv2.so.1.0.0 -buildmode=plugin .