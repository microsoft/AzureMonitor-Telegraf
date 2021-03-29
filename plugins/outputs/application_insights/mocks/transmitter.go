// Code generated by mockery v1.0.0. DO NOT EDIT.
package mocks

import appinsights "github.com/Microsoft/ApplicationInsights-Go/appinsights"

import mock "github.com/stretchr/testify/mock"

// Transmitter is an autogenerated mock type for the Transmitter type
type Transmitter struct {
	mock.Mock
}

// Close provides a mock function with given fields:
func (_m *Transmitter) Close() <-chan struct{} {
	ret := _m.Called()

	var r0 <-chan struct{}
	if rf, ok := ret.Get(0).(func() <-chan struct{}); ok {
		r0 = rf()
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).(<-chan struct{})
		}
	}

	return r0
}

// Track provides a mock function with given fields: _a0
func (_m *Transmitter) Track(_a0 appinsights.Telemetry) {
	_m.Called(_a0)
}
