package viewer

import (
	"regexp"
	"strconv"
	"strings"
	"time"
)

func add(x, y int) int {
	return x + y
}

func image(youtube_id, nico_id, title string) string {
	if youtube_id != "" {
		return "<img data-src='http://i3.ytimg.com/vi/" + youtube_id + "/hqdefault.jpg' alt=" + strconv.Quote(title) + " src='/static/images/youtube.png' class='img-thumbnail img-responsive' width='450' height='340' />"
	} else {
		re := regexp.MustCompile("\\D+(\\d+)")
		return "<img data-src='http://tn-skr1.smilevideo.jp/smile?i=" + re.ReplaceAllString(nico_id, "$1") + ".L' alt=" + strconv.Quote(title) + " src='/static/images/nicovideo.png' class='img-thumbnail img-responsive' width='450' height='340' />"
	}
}

func imageUrl(youtube_id string) string {
	if youtube_id != "" {
		return "http://i3.ytimg.com/vi/" + youtube_id + "/hqdefault.jpg"
	} else {
		return "http://vocaloid.anifag.com/static/images/default-share.png"
	}
}

func pageTitle(title string) string {
	return title + " - Vocaloid Ranking"
}

func videoSourceType(youtube_id string) string {
	if youtube_id != "" {
		return "youtube"
	} else {
		return "nicovideo"
	}
}

func formattedDate(date time.Time, spec string) string {
	if spec == "RFC822" {
		return date.Format(time.RFC822)
	} else {
		return date.Format(time.RFC3339)
	}
}

func sortingPath(path, order string) string {
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

func menuActive(path, selected string) string {
	if path == "/" && (selected == "daily" || selected == "total_score") {
		return "active"
	} else {
		var typed bool = false

		ordered, _ := regexp.MatchString("order", path)
		matched, _ := regexp.MatchString(selected, path)
		if selected == "total" {
			typed, _ = regexp.MatchString("/type/total", path)
		} else {
			typed = true
		}
		if typed == true && (matched == true || (ordered == false && selected == "total_score")) {
			return "active"
		} else {
			return ""
		}
	}
}

func embedVideo(youtube_id, nico_id, title string) string {
	if youtube_id != "" {
		return "<iframe class=\"embed-responsive-item\" width=\"853\" height=\"480\" src=\"https://www.youtube.com/embed/" + youtube_id + "\" frameborder=\"0\" allowfullscreen></iframe>"
	} else {
		return "<script type=\"text/javascript\" src=\"http://ext.nicovideo.jp/thumb_watch/" + nico_id + "?w=853&h=480\"></script><noscript><a href=\"http://www.nicovideo.jp/watch/" + nico_id + "\">Niconico " + title + "</a></noscript>"
	}
}

func previousPage(path string) string {
	if path == "/videos" {
		return "<span class=\"newest\">Newer</span>"
	} else {
		slice := strings.SplitAfter(path, "/")
		if len(slice) > 0 {
			page, err := strconv.ParseUint(slice[len(slice)-1], 10, 64)
			if err != nil {
				return "<span class=\"newest\">Newer</span>"
			}

			if page == 1 {
				return "<a class=\"newest\" href=\"/videos\">Newer</a>"
			} else {
				return "<a class=\"newest\" href=\"/videos/page/" + strconv.FormatUint(page-1, 10) + "\">Newer</a>"
			}
		} else {
			return "<span class=\"newest\">Newer</span>"
		}
	}
}

func nextPage(path string) string {
	if path == "/videos" {
		return "<a class=\"older\" href=\"/videos/page/1\">Older</a>"
	} else {
		slice := strings.SplitAfter(path, "/")
		if len(slice) > 0 {
			page, err := strconv.ParseUint(slice[len(slice)-1], 10, 64)
			if err != nil {
				return "<span class=\"older\">Older</span>"
			}

			return "<a class=\"older\" href=\"/videos/page/" + strconv.FormatUint(page+1, 10) + "\">Older</a>"
		} else {
			return "<span class=\"older\">Older</span>"
		}
	}
}
