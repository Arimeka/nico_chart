package viewer

import (
	"log"
	"net/http"
	"path/filepath"
	"strings"
	"text/template"
	"time"
)

func ServeStatic(h http.Handler) http.HandlerFunc {

	path, err := filepath.Abs("./templates/404.html")
	if err != nil {
		log.Fatal(err)
	}

	tmpl, templateError := template.ParseFiles(path)
	if templateError != nil {
		log.Fatal(templateError)
	}

	return func(response http.ResponseWriter, request *http.Request) {
		if strings.HasSuffix(request.URL.Path, "/") {
			response.WriteHeader(404)
			tmpl.Execute(response, nil)
		} else {
			response.Header().Set("Expires", time.Now().UTC().AddDate(1, 0, 0).Format(time.RFC1123))
			h.ServeHTTP(response, request)
		}
	}
}
