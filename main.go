package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type HelloResponse struct {
	Data string `json:"data"`
}

type HelloRequest struct {
	Name string `json:"name"`
}

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/", hello)
	server := &http.Server{
		Addr: ":3000",
	}
	fmt.Printf("Server is ready at %s \n", server.Addr)
	err := server.ListenAndServe()
	if err != nil {
		log.Fatal(err)
	}
}

func hello(writer http.ResponseWriter, req *http.Request) {
	var helloReq HelloRequest
	err := json.NewDecoder(req.Body).Decode(&helloReq)
	if err != nil {
		http.Error(writer, "no data provided", http.StatusBadRequest)
		return
	}

	if helloReq.Name == "" {
		http.Error(writer, "name is empty string", http.StatusBadRequest)
		return
	}

	responseData := fmt.Sprintf("hello %s", helloReq.Name)
	data, err := json.Marshal(&HelloResponse{
		Data: responseData,
	})
	if err != nil {
		fmt.Println(err.Error())
	}
	writer.Header().Add("Content-Type", "application/json")
	writer.WriteHeader(http.StatusOK)
	writer.Write(data)
}
