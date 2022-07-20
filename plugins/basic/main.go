// SPDX-FileCopyrightText: 2022-present Intel Corporation
//
// SPDX-License-Identifier: Apache-2.0

package main

import (
	_ "embed"
	"github.com/onosproject/onos-p4-plugins/plugins/basic/plugin"
)

var P4Plugin plugin.P4Plugin

func init() {
	_ = P4Plugin.InitPlugin()
}
