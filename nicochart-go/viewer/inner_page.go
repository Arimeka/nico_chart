package viewer

import (
	"github.com/gorilla/mux"
	"github.com/shaoshing/train"
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

	funcMap := template.FuncMap{
		"javascript_tag":            train.JavascriptTag,
		"stylesheet_tag":            train.StylesheetTag,
		"stylesheet_tag_with_param": train.StylesheetTagWithParam,
		"formattedDate":             formattedDate,
		"embedVideo":                embedVideo,
	}

	tmpl := template.New("inner.html").Funcs(funcMap)
	tmpl, templateError := tmpl.ParseFiles(path)
	if templateError != nil {
		log.Fatal(templateError)
	}

	return func(response http.ResponseWriter, request *http.Request) {
		params := mux.Vars(request)
		id := params["id"]

		video, err := models.Get(id)
		if err != nil {
			log.Println(err)
		}

		tmpl.Execute(response, video)
	}
}
