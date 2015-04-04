package viewer

import (
	"log"
	"net/http"
	"nicochart-go/settings"
	"path/filepath"
	"text/template"
)

type Result struct {
}

func MainPage(config settings.Settings) http.HandlerFunc {

	path, err := filepath.Abs("./templates/main.html")
	if err != nil {
		log.Fatal(err)
	}

	tmpl, templateError := template.ParseFiles(path)
	if templateError != nil {
		log.Fatal(templateError)
	}

	return func(response http.ResponseWriter, request *http.Request) {
		result := new(Result)
		tmpl.Execute(response, result)
	}
}
