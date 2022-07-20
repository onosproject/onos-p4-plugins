// SPDX-FileCopyrightText: 2022-present Intel Corporation
//
// SPDX-License-Identifier: Apache-2.0

package plugin

import (
	"github.com/onosproject/onos-lib-go/pkg/logging"
	p4configapi "github.com/p4lang/p4runtime/go/p4/config/v1"
)

var log = logging.GetLogger()

type P4Plugin struct {
}

func (p *P4Plugin) GetPkgInfo() (*p4configapi.PkgInfo, error) {
	log.Debug("Getting package info")

	return nil, nil
}
