package main

import (
	"log"
	"net/http"
	"nicochart-go/settings"
	"nicochart-go/viewer"
	"runtime"
)

const (
	VERSION = "0.1.0"
)

func init() {
	settings.SetupOptions("config address env")
}

func main() {
	settings.Setup()

	config, err := settings.SetDefaults(settings.BuildFromFile(settings.Path))
	if err != nil {
		log.Println(err)
	}

	runtime.GOMAXPROCS(config.NumCPU)

	printBanner(config)

	http.HandleFunc("/", viewer.MainPage(config))

	log.Fatal(http.ListenAndServe(config.Address+":"+config.Port, nil))
}

func printBanner(config settings.Settings) {
	log.Println("NicoChart", VERSION, "("+runtime.Version()+" "+runtime.GOOS+"/"+runtime.GOARCH+")")
	log.Println("- environment:", settings.Env)
	log.Println("- numcpu:     ", config.NumCPU)
	log.Println("listen", config.Address+":"+config.Port)
}
