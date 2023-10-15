package GetUserPosts

import (
	"context"
	"encoding/json"
	"log"
	"net/http"

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

	uid := r.URL.Query().Get("uid") // https://?uid={UID}

	postIter := client.Collection("posts").Where("author", "==", uid).Documents(ctx)

	// slice to store the posts data
	var posts []map[string]interface{}

	for {
		postDoc, err := postIter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalf("Failed to iterate: %v", err)
		}

		postData := postDoc.Data()

		// add post data to slice
		posts = append(posts, postData)

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
