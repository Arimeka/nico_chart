package viewer

import (
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"nicochart-go/models"
	"nicochart-go/settings"
	"os/exec"
)

func FindVideo() http.HandlerFunc {
	return func(response http.ResponseWriter, request *http.Request) {
		params := mux.Vars(request)
		id := params["id"]

		_, err := models.Get(id)
		if err != nil {
			log.Println(err)
		}

		cmd := exec.Command("../find_video.sh", "-i", id, "-e", settings.Env)
		err = cmd.Start()
		if err != nil {
			log.Println(err)
		}
		log.Println("Waiting for command", "./find_video.sh", "-i", id, "-e", settings.Env, "to finish...")
		err = cmd.Wait()
		if err != nil {
			log.Printf("Command %v %v %v %v finished with error: %v", "./find_video.sh -i", id, "-e", settings.Env, err)
		} else {
			log.Println("Command", "./find_video.sh", "-i", id, "-e", settings.Env, "finished without any errors")
		}

		response.Header().Set("Content-Type", "application/json")

		jsonStr := `{"app": {"notice": {"text": "The task will be processed"}}}`

		response.Write([]byte(jsonStr))
	}
}
