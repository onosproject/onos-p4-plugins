// SPDX-FileCopyrightText: 2022-present Intel Corporation
//
// SPDX-License-Identifier: Apache-2.0

package main

import (
	_ "embed"
	"github.com/onosproject/onos-p4-plugins/plugins/basic/plugin"
	"os"
)

var P4Plugin plugin.P4Plugin

func init() {
	err := P4Plugin.InitPlugin()
	if err != nil {
		os.Exit(1)
	}
}
