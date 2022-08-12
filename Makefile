# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0


build-tools:=$(shell if [ ! -d "./build/build-tools" ]; then cd build && git clone https://github.com/onosproject/build-tools.git; fi)
include ./build/build-tools/make/onf-common.mk


.PHONY: build
test: license basic-test middleblock-test

.PHONY: basic
basic-test:
	$(MAKE) -C plugins/basic test

middleblock-test:
	$(MAKE) -C plugins/middleblock test
