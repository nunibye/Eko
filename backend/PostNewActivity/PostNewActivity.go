package PostNewActivity

import (
	"context"
	"fmt"
	"log"
	"strings"
	"time"

	"cloud.google.com/go/firestore"
)

type Post struct {
	Author struct {
		StringValue string `json:"stringValue"`
	} `json:"author"`
	Time struct {
		StringValue string `json:"stringValue"`
	} `json:"time"`
	Title struct {
		StringValue string `json:"stringValue"`
	} `json:"title"`
	Body struct {
		StringValue string `json:"stringValue"`
	} `json:"body"`
	Tags struct {
		ArrayValue struct {
			Values []struct {
				StringValue string `json:"stringValue"`
			} `json:"values"`
		} `json:"arrayValue"`
	} `json:"tags"`
}

type FirestoreEvent struct {
	OldValue   FirestoreValue `json:"oldValue"`
	Value      FirestoreValue `json:"value"`
	UpdateMask struct {
		FieldPaths []string `json:"fieldPaths"`
	} `json:"updateMask"`
}

type FirestoreValue struct {
	CreateTime time.Time `json:"createTime"`
	Fields     Post      `json:"fields"`
	Name       string    `json:"name"`
	UpdateTime time.Time `json:"updateTime"`
}

func PostNewActivity(ctx context.Context, e FirestoreEvent) error {
	projectID := "untitled-2832f"

	// load new post data into post
	post := e.Value.Fields

	// firestore client
	client, err := firestore.NewClient(ctx, projectID)
	if err != nil {
		log.Fatalf("Failed to create client: %v", err)
	}
	defer client.Close()

	// Get the author's document
	authorDoc, err := client.Collection("users").Doc(post.Author.StringValue).Get(ctx)
	if err != nil {
		log.Fatalf("Failed to get author document: %v", err)
	}

	// Get the author's username
	username, ok := authorDoc.Data()["username"].(string)
	if !ok {
		log.Fatalf("Failed to convert username to string")
	}

	// Get the author's uid
	uid, ok := authorDoc.Data()["uid"].(string)
	if !ok {
		log.Fatalf("Failed to convert uid to string")
	}

	// split the path to just get the document id
	path := e.Value.Name
	splitPath := strings.Split(path, "/")
	lastPart := splitPath[len(splitPath)-1]

	// format content
	var content string
	if post.Title.StringValue != "" {
		content = post.Title.StringValue
	} else if post.Body.StringValue != "" {
		content = post.Body.StringValue
	} else {
		content = fmt.Sprintf("New post from %s", username)
	}

	// Check if the post is public
	isPublic := false
	for _, tag := range post.Tags.ArrayValue.Values {
		if tag.StringValue == "public" {
			isPublic = true
			break
		}
	}

	if isPublic { // if public send to each follower
		// Get the author's profileData
		profileData, ok := authorDoc.Data()["profileData"].(map[string]interface{})
		if !ok {
			log.Fatalf("Failed to convert profileData to map")
		}

		// Get the author's followers
		followers, ok := profileData["followers"].([]interface{})
		if !ok {
			log.Fatalf("Failed to convert followers to array")
		}
		// For each follower, add the new activity
		for _, follower := range followers {
			followerID, ok := follower.(string)
			if !ok {
				log.Printf("Failed to convert follower ID to string")
				continue
			}
			_, _, err = client.Collection("users").Doc(followerID).Collection("newActivity").Add(ctx, map[string]interface{}{
				"content":   content,
				"path":      lastPart,
				"sourceUid": uid,
				"time":      post.Time.StringValue,
				"type":      "post",
			})
			if err != nil {
				log.Fatalf("Failed to add activity: %v", err)
			}
		}
	} else { // if not public send to people in the groups it is tagged with
		// For each tag
		for _, value := range post.Tags.ArrayValue.Values {
			groupID := value.StringValue

			// Get the group's document
			groupDoc, err := client.Collection("groups").Doc(groupID).Get(ctx)
			if err != nil {
				log.Printf("Failed to get group document: %v", err)
				continue
			}

			// Get the group's members
			members, ok := groupDoc.Data()["members"].([]interface{})
			if !ok {
				log.Fatalf("Failed to convert members to array")
			}

			// For each member, add the new activity
			for _, member := range members {
				memberID, ok := member.(string)
				if !ok {
					log.Printf("Failed to convert member ID to string")
					continue
				}

				// Exclude the author of the post
				if memberID == post.Author.StringValue {
					continue
				}

				_, _, err = client.Collection("users").Doc(memberID).Collection("newActivity").Add(ctx, map[string]interface{}{
					"content":   content,
					"path":      lastPart,
					"sourceUid": uid,
					"time":      post.Time.StringValue,
					"type":      "post",
				})
				if err != nil {
					log.Fatalf("Failed to add activity: %v", err)
				}
			}
		}
	}

	return nil
}

// gcloud functions deploy PostNewActivity --runtime go121 --trigger-event "providers/cloud.firestore/eventTypes/document.create" --trigger-resource "projects/untitled-2832f/databases/(default)/documents/posts/{docId}"
