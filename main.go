package main

import (
	"fmt"
	"log"
	"net/http"
)

// helloHandler handles requests to the root URL ("/") and responds with "Hello, World!"
func helloHandler(w http.ResponseWriter, r *http.Request) {
	// Set the Content-Type header to text/plain
	w.Header().Set("Content-Type", "text/plain")

	// Write "Hello, World!" to the response
	_, err := w.Write([]byte("Hello, World!"))
	if err != nil {
		http.Error(w, "Unable to write response", http.StatusInternalServerError)
		return
	}
}

func main() {
	// Register the helloHandler function for the root URL path "/"
	http.HandleFunc("/", helloHandler)

	// Define the server address and port
	addr := ":8080"
	fmt.Printf("Starting server at http://localhost%s/\n", addr)

	// Start the HTTP server
	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
