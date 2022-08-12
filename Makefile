# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0


.PHONY: build
test: basic-test middleblock-test

.PHONY: basic
basic-test:
	$(MAKE) -C plugins/basic test

middleblock-test:
	$(MAKE) -C plugins/middleblock test
