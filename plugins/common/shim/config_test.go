package shim

import (
	"os"
	"testing"
	"time"

	"github.com/influxdata/telegraf"
	tgConfig "github.com/influxdata/telegraf/config"
	"github.com/influxdata/telegraf/plugins/inputs"
	"github.com/stretchr/testify/require"
)

func TestLoadConfig(t *testing.T) {
	os.Setenv("SECRET_TOKEN", "xxxxxxxxxx")
	os.Setenv("SECRET_VALUE", `test"\test`)

	inputs.Add("test", func() telegraf.Input {
		return &serviceInput{}
	})

	c := "./testdata/plugin.conf"
	conf, err := LoadConfig(&c)
	require.NoError(t, err)

	inp := conf.Input.(*serviceInput)

	require.Equal(t, "awesome name", inp.ServiceName)
	require.Equal(t, "xxxxxxxxxx", inp.SecretToken)
	require.Equal(t, `test"\test`, inp.SecretValue)
}

func TestDefaultImportedPluginsSelfRegisters(t *testing.T) {
	inputs.Add("test", func() telegraf.Input {
		return &testInput{}
	})

	cfg, err := LoadConfig(nil)
	require.NoError(t, err)
	require.Equal(t, "test", cfg.Input.Description())
}

func TestLoadingSpecialTypes(t *testing.T) {
	inputs.Add("test", func() telegraf.Input {
		return &testDurationInput{}
	})

	c := "./testdata/special.conf"
	conf, err := LoadConfig(&c)
	require.NoError(t, err)

	inp := conf.Input.(*testDurationInput)

	require.EqualValues(t, 3*time.Second, inp.Duration)
	require.EqualValues(t, 3*1000*1000, inp.Size)
}

type testDurationInput struct {
	Duration tgConfig.Duration `toml:"duration"`
	Size     tgConfig.Size     `toml:"size"`
}

func (i *testDurationInput) SampleConfig() string {
	return ""
}

func (i *testDurationInput) Description() string {
	return ""
}
func (i *testDurationInput) Gather(acc telegraf.Accumulator) error {
	return nil
}
