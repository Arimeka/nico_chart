package viewer

import (
	"github.com/gorilla/mux"
	"github.com/shaoshing/train"
	"log"
	"net/http"
	"nicochart-go/models"
	"nicochart-go/settings"
	"path/filepath"
	"regexp"
	"text/template"
	"time"
)

type Result struct {
	Videos       *[]models.Video
	LastUrlQuery string
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
		"add":            add,
		"image":          image,
		"formatted_date": formatted_date,
		"sorting_path":   sorting_path,
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

		result := new(Result)
		result.LastUrlQuery = request.URL.RequestURI()
		videos, err := models.RankList(rank_type, order)
		if err != nil {
			log.Println(err)
		}

		result.Videos = videos
		tmpl.Execute(response, result)
	}
}

func add(x, y int) int {
	return x + y
}

func image(youtube_id, nico_id, title string) string {
	if youtube_id != "" {
		return "<img data-src='http://i3.ytimg.com/vi/" + youtube_id + "/hqdefault.jpg' alt='" + title + "' src='/static/images/youtube.png' class='img-thumbnail img-responsive' width='450' height='340' />"
	} else {
		re := regexp.MustCompile("\\D+(\\d+)")
		return "<img data-src='http://tn-skr1.smilevideo.jp/smile?i=" + re.ReplaceAllString(nico_id, "$1") + ".L' alt='" + title + "' src='/static/images/nicovideo.png' class='img-thumbnail img-responsive' width='450' height='340' />"
	}
}

func formatted_date(date time.Time) string {
	return date.Format(time.RFC822)
}

func sorting_path(path, order string) string {
	if path == "/" {
		return "/type/daily/order/" + order
	} else {
		matched, _ := regexp.MatchString("order", path)
		if matched == true {
			re := regexp.MustCompile("(\\/\\D+\\/order\\/)\\D+")
			return re.ReplaceAllString(path, "$1") + order
		} else {
			return path + "/order/" + order
		}
	}
}
