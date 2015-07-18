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

	not_found_path, err := filepath.Abs("./templates/404.html")
	if err != nil {
		log.Fatal(err)
	}

	funcMap := template.FuncMap{
		"add":             add,
		"image":           image,
		"formattedDate":   formattedDate,
		"videoSourceType": videoSourceType,
		"previousPage":    previousPage,
		"nextPage":        nextPage}

	tmpl := template.New("archive.html").Funcs(funcMap)
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
		page := params["page"]

		list := new(ArchiveList)
		list.LastUrlQuery = request.URL.RequestURI()
		videos, err := models.ArchiveList(10, page)
		if err != nil {
			log.Println(err)
			response.WriteHeader(404)
			not_found_tmpl.Execute(response, nil)
		} else {
			list.Videos = videos
			if len(*videos) == 0 {
				response.WriteHeader(404)
				not_found_tmpl.Execute(response, nil)
			} else {
				tmpl.Execute(response, list)
			}
		}
	}
}
