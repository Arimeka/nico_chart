package main

import (
	"github.com/gorilla/mux"
	"github.com/shaoshing/train"
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

	fs := http.FileServer(http.Dir("static"))

	// Mandatory root-based resources
	serveSingle("/favicon.png", "./static/favicon.png")
	serveSingle("/favicon.ico", "./static/favicon.ico")
	serveSingle("/robots.txt", "./static/robots.txt")

	router := mux.NewRouter()
	router.HandleFunc("/", viewer.MainPage(config))
	router.HandleFunc("/type/{rank_type:[a-z]+}", viewer.MainPage(config))
	router.HandleFunc("/type/{rank_type:[a-z]+}/order/{order:[a-z_]+}", viewer.MainPage(config))
	router.PathPrefix("/static/").Handler(viewer.ServeStatic(http.StripPrefix("/static/", fs)))
	router.NotFoundHandler = http.HandlerFunc(viewer.NotFoundPage())

	http.Handle("/", router)

	train.ConfigureHttpHandler(nil)
	log.Fatal(http.ListenAndServe(config.Address+":"+config.Port, nil))
}

func printBanner(config settings.Settings) {
	log.Println("NicoChart", VERSION, "("+runtime.Version()+" "+runtime.GOOS+"/"+runtime.GOARCH+")")
	log.Println("- environment:", settings.Env)
	log.Println("- numcpu:     ", config.NumCPU)
	log.Println("listen", config.Address+":"+config.Port)
}

func serveSingle(pattern string, filename string) {
	http.HandleFunc(pattern, func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, filename)
	})
}
