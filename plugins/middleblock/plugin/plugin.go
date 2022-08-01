// SPDX-FileCopyrightText: 2022-present Intel Corporation
//
// SPDX-License-Identifier: Apache-2.0

package plugin

import (
	_ "embed"
	"github.com/golang/protobuf/proto"
	"github.com/onosproject/onos-lib-go/pkg/errors"
	"github.com/onosproject/onos-lib-go/pkg/logging"
	p4configapi "github.com/p4lang/p4runtime/go/p4/config/v1"
)

var log = logging.GetLogger()

//go:embed artifacts/p4info.txt
var p4InfoBytes []byte

////go:embed artifacts/middleblock_bmv2.json
var p4DeviceConfig []byte

type P4Plugin struct {
	p4Info         *p4configapi.P4Info
	p4DeviceConfig []byte
}

// InitPlugin initialize P4 plugin using P4Info and P4 device config
func (p *P4Plugin) InitPlugin() error {
	p4Info := &p4configapi.P4Info{}
	if err := proto.UnmarshalText(string(p4InfoBytes), p4Info); err != nil {
		return errors.NewInvalid("failed to decode P4Info Protobuf message", err)
	}
	p.p4Info = p4Info
	p.p4DeviceConfig = p4DeviceConfig
	return nil
}

// GetP4Info returns P4 info
func (p *P4Plugin) GetP4Info() (*p4configapi.P4Info, error) {
	return p.p4Info, nil
}

// GetPkgInfo returns P4 Pkg info
func (p *P4Plugin) GetPkgInfo() (*p4configapi.PkgInfo, error) {
	if p.p4Info != nil {
		log.Debug("Getting package info")
		return p.p4Info.PkgInfo, nil

	}
	return nil, errors.NewNotFound("Package info is not initialized")
}

// GetP4DeviceConfig returns P4 device config
func (p *P4Plugin) GetP4DeviceConfig() ([]byte, error) {
	log.Debug("Getting P4 Device config")
	return p.p4DeviceConfig, nil
}
