package viewer

import (
	"github.com/shaoshing/train"
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

	funcMap := template.FuncMap{
		"javascript_tag":            train.JavascriptTag,
		"stylesheet_tag":            train.StylesheetTag,
		"stylesheet_tag_with_param": train.StylesheetTagWithParam,
	}

	tmpl := template.New("main.html").Funcs(funcMap)
	tmpl, templateError := tmpl.ParseFiles(path)
	if templateError != nil {
		log.Fatal(templateError)
	}

	return func(response http.ResponseWriter, request *http.Request) {
		result := new(Result)
		tmpl.Execute(response, result)
	}
}
