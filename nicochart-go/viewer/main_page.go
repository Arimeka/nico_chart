package viewer

import (
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"nicochart-go/models"
	"path/filepath"
	"text/template"
)

type List struct {
	Videos       *[]models.Video
	LastUrlQuery string
}

func MainPage() http.HandlerFunc {

	path, err := filepath.Abs("./templates/main.html")
	if err != nil {
		log.Fatal(err)
	}

	funcMap := template.FuncMap{
		"add":             add,
		"image":           image,
		"formattedDate":   formattedDate,
		"sortingPath":     sortingPath,
		"videoSourceType": videoSourceType,
		"menuActive":      menuActive,
	}

	tmpl := template.New("main.html").Funcs(funcMap)
	tmpl, templateError := tmpl.ParseFiles(path)
	if templateError != nil {
		log.Fatal(templateError)
	}

	return func(response http.ResponseWriter, request *http.Request) {
		params := mux.Vars(request)
		rank_type := params["rank_type"]
		order := params["order"]

		if rank_type == "" {
			rank_type = "daily"
		}
		if order == "" {
			order = "total_score"
		}

		list := new(List)
		list.LastUrlQuery = request.URL.RequestURI()
		videos, err := models.RankList(rank_type, order)
		if err != nil {
			log.Println(err)
		}

		list.Videos = videos
		tmpl.Execute(response, list)
	}
}
