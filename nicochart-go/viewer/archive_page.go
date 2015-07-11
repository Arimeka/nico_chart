package viewer

import (
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"nicochart-go/models"
	"path/filepath"
	"text/template"
)

type ArchiveList struct {
	Videos       *[]models.Video
	LastUrlQuery string
}

func ArchivePage() http.HandlerFunc {

	path, err := filepath.Abs("./templates/archive.html")
	if err != nil {
		log.Fatal(err)
	}

	funcMap := template.FuncMap{
		"add":             add,
		"image":           image,
		"formattedDate":   formattedDate,
		"videoSourceType": videoSourceType,
		"previousPage":    previousPage,
		"nextPage":        nextPage,
	}

	tmpl := template.New("archive.html").Funcs(funcMap)
	tmpl, templateError := tmpl.ParseFiles(path)
	if templateError != nil {
		log.Fatal(templateError)
	}

	return func(response http.ResponseWriter, request *http.Request) {
		params := mux.Vars(request)
		page := params["page"]

		list := new(ArchiveList)
		list.LastUrlQuery = request.URL.RequestURI()
		videos, err := models.ArchiveList(10, page)
		if err != nil {
			log.Println(err)
		}

		list.Videos = videos
		tmpl.Execute(response, list)
	}
}
