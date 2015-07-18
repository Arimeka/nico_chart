package viewer

import (
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"nicochart-go/models"
	"path/filepath"
	"text/template"
)

func InnerPage() http.HandlerFunc {

	path, err := filepath.Abs("./templates/inner.html")
	if err != nil {
		log.Fatal(err)
	}

	not_found_path, err := filepath.Abs("./templates/404.html")
	if err != nil {
		log.Fatal(err)
	}

	funcMap := template.FuncMap{
		"formattedDate": formattedDate,
		"embedVideo":    embedVideo,
		"imageUrl":      imageUrl,
		"pageTitle":     pageTitle,
	}

	tmpl := template.New("inner.html").Funcs(funcMap)
	tmpl, templateError := tmpl.ParseFiles(path)
	if templateError != nil {
		log.Fatal(templateError)
	}

	not_found_tmpl, templateError := template.ParseFiles(not_found_path)
	if templateError != nil {
		log.Fatal(templateError)
	}

	return func(response http.ResponseWriter, request *http.Request) {
		params := mux.Vars(request)
		id := params["id"]

		video, err := models.Get(id)
		if err != nil {
			log.Println(err)
			response.WriteHeader(404)
			not_found_tmpl.Execute(response, nil)
		} else {
			tmpl.Execute(response, video)
		}
	}
}
