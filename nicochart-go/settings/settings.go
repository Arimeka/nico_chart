package settings

import (
	"errors"
	"flag"
	"gopkg.in/yaml.v2"
	"io/ioutil"
	"path/filepath"
	"strings"
)

var DEFAULTS = map[string]interface{}{
	"env":     "dev",
	"address": "0.0.0.0",
	"port":    "5000",
	"scheme":  "http",
}

type Settings struct {
	Address string
	Port    string
	NumCPU  int    `yaml:"numcpu"`
	Scheme  string `yaml:"scheme"`
}

var (
	Env     string
	Address string
	Port    string
	Path    string
)

func SetupOptions(options string) {
	if strings.Contains(options, "config") {
		flag.StringVar(&Path, "config", "", "path to config file")
		flag.StringVar(&Path, "c", "", "path to config file (short)")
	}
	if strings.Contains(options, "env") {
		flag.StringVar(&Env, "environment", "development", "environment")
		flag.StringVar(&Env, "e", "development", "environment (short)")
	}
	if strings.Contains(options, "address") {
		flag.StringVar(&Address, "bind", "", "bind address")
		flag.StringVar(&Address, "b", "", "bind address (short)")
		flag.StringVar(&Port, "port", "", "bind port")
		flag.StringVar(&Port, "p", "", "bind port (short)")
	}
}

func Setup() {
	flag.Parse()

	if Env == "" {
		Env = DEFAULTS["env"].(string)
	}
}

func SetDefaults(settings Settings, err error) (Settings, error) {
	if Port != "" {
		settings.Port = Port
	} else {
		if settings.Port == "" {
			settings.Port = DEFAULTS["port"].(string)
		}
	}

	if Address != "" {
		settings.Address = Address
	} else {
		if settings.Address == "" {
			settings.Address = DEFAULTS["address"].(string)
		}
	}

	if settings.Scheme == "" {
		settings.Scheme = DEFAULTS["scheme"].(string)
	}

	return settings, err
}

func BuildFromFile(configPath string) (settings Settings, err error) {
	if configPath == "" {
		return
	}

	path, pathError := filepath.Abs(configPath)
	if pathError != nil {
		err = errors.New("Configuration: " + pathError.Error())
	}

	data, readError := ioutil.ReadFile(path)
	if readError != nil {
		err = errors.New("Configuration: " + readError.Error())
	}

	settingss := make(map[string]Settings)

	if encodeError := yaml.Unmarshal(data, &settingss); encodeError != nil {
		err = errors.New("Configuration: " + encodeError.Error())
	}

	if value, ok := settingss[Env]; ok {
		settings = value
	} else {
		err = errors.New("Not found config for env: " + Env)
	}

	return
}
