package OnUserDelete

import (
	"context"
	"log"

	"cloud.google.com/go/firestore"
)

type FirestoreEvent struct {
	OldValue   FirestoreValue `json:"oldValue"`
	Value      FirestoreValue `json:"value"`
	UpdateMask struct {
		FieldPaths []string `json:"fieldPaths"`
	} `json:"updateMask"`
}

type FirestoreValue struct {
	CreateTime string     `json:"createTime"`
	Fields     UserFields `json:"fields"`
	Name       string     `json:"name"`
	UpdateTime string     `json:"updateTime"`
}

type UserFields struct {
	UID         ValueWrapper `json:"uid"`
	ProfileData ProfileData  `json:"profileData"`
}

type ProfileData struct {
	Followers []ValueWrapper `json:"followers"`
	Following []ValueWrapper `json:"following"`
}

type ValueWrapper struct {
	StringValue string `json:"stringValue"`
}

func OnUserDelete(ctx context.Context, e FirestoreEvent) error {
	// Firestore client
	projectID := "untitled-2832f"
	client, err := firestore.NewClient(ctx, projectID)
	if err != nil {
		log.Fatalf("Failed to create client: %v", err)
	}
	defer client.Close()

	// // Log the entire Firestore event data
	// eventData, _ := json.Marshal(e)
	// log.Printf("Event data: %s", eventData)

	// // Load user data into user
	// user := e.OldValue.Fields

	// log.Printf("User data: %v", user)

	// // Get the user's document ID from the 'uid' field
	// userId := user.Uid.StringValue

	// // Get the 'followers' and 'following' arrays from the 'profileData' map
	// followers := user.ProfileData.Followers
	// following := user.ProfileData.Following

	// log.Printf("Followers: %v", followers)
	// log.Printf("Following: %v", following)

	// // For each user that the deleted user is following, remove the deleted user from their followers
	// for _, followedUserId := range following {
	// 	_, err := client.Collection("users").Doc(followedUserId).Update(ctx, []firestore.Update{
	// 		{Path: "profileData.followers", Value: firestore.ArrayRemove(userId)},
	// 	})
	// 	if err != nil {
	// 		log.Printf("Failed to update document: %v", err)
	// 	} else {
	// 		log.Printf("Removed %s from the followers of %s", userId, followedUserId)
	// 	}
	// }

	// // For each follower of the deleted user, remove the deleted user from their following
	// for _, followerUserId := range followers {
	// 	_, err := client.Collection("users").Doc(followerUserId).Update(ctx, []firestore.Update{
	// 		{Path: "profileData.following", Value: firestore.ArrayRemove(userId)},
	// 	})
	// 	if err != nil {
	// 		log.Printf("Failed to update document: %v", err)
	// 	} else {
	// 		log.Printf("Removed %s from the following of %s", userId, followerUserId)
	// 	}
	// }

	return nil
}

// gcloud functions deploy OnUserDelete --runtime go121 --trigger-event "providers/cloud.firestore/eventTypes/document.delete" --trigger-resource "projects/untitled-2832f/databases/(default)/documents/users/{uid}"
