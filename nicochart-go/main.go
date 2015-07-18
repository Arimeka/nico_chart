package main

import (
	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"nicochart-go/settings"
	"nicochart-go/viewer"
	"os"
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
		log.Fatal(err)
	}

	runtime.GOMAXPROCS(config.NumCPU)

	printBanner(config)

	fs := http.FileServer(http.Dir("../public"))

	// Mandatory root-based resources
	serveSingle("/favicon.png", "./static/favicon.png")
	serveSingle("/favicon.ico", "./static/favicon.ico")
	serveSingle("/robots.txt", "./static/robots.txt")

	router := mux.NewRouter()
	router.HandleFunc("/", viewer.MainPage()).Methods("GET")

	router.HandleFunc("/video/{id:[0-9]+}", viewer.InnerPage()).Methods("GET")
	router.HandleFunc("/video/{id:[0-9]+}", viewer.FindVideo()).Methods("POST")

	router.HandleFunc("/videos", viewer.ArchivePage()).Methods("GET")
	router.HandleFunc("/videos/page/{page:([1-9]|[1-9][0-9]+)}", viewer.ArchivePage()).Methods("GET")

	router.HandleFunc("/type/{rank_type:(daily|weekly|monthly|total)}", viewer.MainPage()).Methods("GET")
	router.HandleFunc("/type/{rank_type:[a-z]+}/order/{order:(total_score|views_count|comments_count|mylist_count)}", viewer.MainPage()).Methods("GET")

	router.PathPrefix("/static/").Handler(viewer.ServeStatic(http.StripPrefix("/static/", fs))).Methods("GET")
	router.NotFoundHandler = http.HandlerFunc(viewer.NotFoundPage())

	http.Handle("/", handlers.LoggingHandler(os.Stdout, router))

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
