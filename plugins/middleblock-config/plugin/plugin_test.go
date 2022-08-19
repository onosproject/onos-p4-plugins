// SPDX-FileCopyrightText: 2022-present Intel Corporation
//
// SPDX-License-Identifier: Apache-2.0

package plugin

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestP4Plugin_GetP4Info(t *testing.T) {
	plugin := P4Plugin{}
	err := plugin.InitPlugin()
	assert.NoError(t, err)
	p4Info, err := plugin.GetP4Info()
	assert.NoError(t, err)
	assert.Equal(t, "middleblock-config", p4Info.PkgInfo.Name)
	assert.Equal(t, "1.0.0", p4Info.PkgInfo.Version)
	_, err = plugin.GetP4DeviceConfig()
	assert.NoError(t, err)

}
