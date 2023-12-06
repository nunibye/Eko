package GetUserPosts

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"strings"

	"cloud.google.com/go/firestore"
	"google.golang.org/api/iterator"
)

func GetUserPosts(w http.ResponseWriter, r *http.Request) {
	projectID := "untitled-2832f"

	ctx := context.Background()
	client, err := firestore.NewClient(ctx, projectID)
	if err != nil {
		log.Fatalf("Failed to create client: %v", err)
	}
	defer client.Close()

	// Parse the request body
	var requestBody map[string]interface{}
	err = json.NewDecoder(r.Body).Decode(&requestBody)
	if err != nil {
		log.Fatalf("Failed to decode request body: %v", err)
	}

	// Get the uid from the request body
	uid := requestBody["uid"].(string)

	// log.Printf("uid = %s", uid)

	postIter := client.Collection("posts").Where("author", "==", uid).Documents(ctx)

	// slice to store the posts data
	var posts []string

	for {
		postDoc, err := postIter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalf("Failed to iterate: %v", err)
		}

		// add post data to slice
		postPath := postDoc.Ref.Path
		relativePath := strings.TrimPrefix(postPath, "projects/untitled-2832f/databases/(default)/documents/")
		posts = append(posts, relativePath)
		// log.Printf("post: %s", relativePath)

	}

	// encode slice into JSON byte slice
	jsonData, err := json.Marshal(posts)
	if err != nil {
		log.Fatalf("Failed to encode JSON: %v", err)
	}

	// write JSON byte slice to response writer with the content type header
	w.Header().Set("Content-Type", "application/json")
	w.Write(jsonData)
}

// gcloud functions deploy GetUserPosts
