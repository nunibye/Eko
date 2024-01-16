package OnUserDelete

import (
	"context"
	"log"
	"time"

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
	CreateTime time.Time              `json:"createTime"`
	Fields     map[string]interface{} `json:"fields"`
	Name       string                 `json:"name"`
	UpdateTime time.Time              `json:"updateTime"`
}

func OnUserDelete(ctx context.Context, e FirestoreEvent) error {
	// Firestore client
	projectID := "untitled-2832f"
	client, err := firestore.NewClient(ctx, projectID)
	if err != nil {
		log.Fatalf("Failed to create client: %v", err)
	}
	defer client.Close()

	// Load eleted user data
	fields := e.OldValue.Fields

	// save uid
	uid := fields["uid"].(map[string]interface{})["stringValue"].(string)

	// save followers and following into lists

	profileData := fields["profileData"].(map[string]interface{})["mapValue"].(map[string]interface{})["fields"].(map[string]interface{})

	var followers, following []string

	if followersRaw, ok := profileData["followers"].(map[string]interface{})["arrayValue"].(map[string]interface{})["values"].([]interface{}); ok {
		for _, followerRaw := range followersRaw {
			follower := followerRaw.(map[string]interface{})["stringValue"].(string)
			followers = append(followers, follower)
		}
	}

	if followingRaw, ok := profileData["following"].(map[string]interface{})["arrayValue"].(map[string]interface{})["values"].([]interface{}); ok {
		for _, followingRaw := range followingRaw {
			follows := followingRaw.(map[string]interface{})["stringValue"].(string)
			following = append(following, follows)
		}
	}

	// For each user that the deleted user is following, remove the deleted user from their followers
	for _, followedUserId := range following {
		client.Collection("users").Doc(followedUserId).Update(ctx, []firestore.Update{
			{Path: "profileData.followers", Value: firestore.ArrayRemove(uid)},
		})
	}

	// For each follower of the deleted user, remove the deleted user from their following
	for _, followerUserId := range followers {
		client.Collection("users").Doc(followerUserId).Update(ctx, []firestore.Update{
			{Path: "profileData.following", Value: firestore.ArrayRemove(uid)},
		})
	}

	return nil
}
