# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

export GO111MODULE=on


test: # @HELP run go test on projects
test: build


PHONY: build
build: build-middleblock

build-middleblock: # @HELP build all libraries
build-middleblock:
	go build  -o build/_output/middleblock.so.1.0.0 -buildmode=plugin .