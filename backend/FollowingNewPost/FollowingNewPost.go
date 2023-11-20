package FollowingNewPost

import (
	"context"
	"log"

	"cloud.google.com/go/firestore"
	"google.golang.org/api/iterator"
)

type Post struct {
	author string `firestore:"author,omitempty"`
	time   string `firestore:"time,omitempty"`
}

func FollowingNewPost(ctx context.Context, m firestore.DocumentSnapshot) error {
	projectID := "untitled-2832f"

	// load new post data into post
	var post Post
	m.DataTo(&post)

	client, err := firestore.NewClient(ctx, projectID)
	if err != nil {
		log.Fatalf("Failed to create client: %v", err)
	}
	defer client.Close()

	// if post by me for testing
	if post.author == "bdeewAqwXHYQPIjSbwDLmpPKhV83" {

		// go through users who follow the author
		iter := client.Collection("users").Where("following", "array-contains", post.author).Documents(ctx)
		for {
			doc, err := iter.Next()
			if err == iterator.Done {
				break
			}
			if err != nil {
				log.Fatalf("Failed to iterate: %v", err)
			}

			// add to newActivity
			client.Collection("users").Doc(doc.Ref.ID).Collection("newActivity").Add(ctx, map[string]interface{}{"content": m.Ref.ID, "path": m.Ref.Path, "time": post.time, "type": "post"})
		}
	}

	return nil
}
