package main

import (
	"net/http"
	"os"

	"github.com/jbowens/codenamesgreen/gameapi"
)

func main() {
	wordLists, err := gameapi.DefaultWordlists()
	if err != nil {
		panic(err)
	}

	h := gameapi.Handler(wordLists)
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	err = http.ListenAndServe(":"+port, h)
	panic(err)
}
