# SPDX-FileCopyrightText: 2022-present Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0

FROM onosproject/golang-build:v1.0 as pluginbuild

ENV GO111MODULE=on
ARG PLUGIN_MAKE_TARGET
ARG PLUGIN_MAKE_VERSION

COPY build/_input/${PLUGIN_MAKE_TARGET} /build

WORKDIR /build

RUN GOFLAGS=-mod=vendor go build -o ${PLUGIN_MAKE_TARGET}.so.${PLUGIN_MAKE_VERSION} \
    -buildmode=plugin github.com/onosproject/onos-p4-plugins/plugins/${PLUGIN_MAKE_TARGET}

FROM alpine:3.12
ARG PLUGIN_MAKE_TARGET
ARG PLUGIN_MAKE_VERSION
COPY --from=pluginbuild /build/${PLUGIN_MAKE_TARGET}.so.${PLUGIN_MAKE_VERSION} /
