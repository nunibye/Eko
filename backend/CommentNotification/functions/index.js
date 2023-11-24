var admin = require("firebase-admin");
const { applicationDefault } = require("firebase-admin/app");
var functions = require("firebase-functions");

admin.initializeApp({
  credential: applicationDefault()
});

exports.sendActivityNotification = functions.firestore.document('users/{uid}/newActivity/{activityId}')
    .onCreate(async (snapshot, context) => {
        const uid = context.params.uid;
        const path = snapshot.data().path;
        const comment = snapshot.data().content;
        const type = snapshot.data().type;
        console.log("UID: ", uid);
        console.log("Path: ", path);
        console.log("Comment: ", comment);

        // Extra read, idk if we want to change that.
        // Function to read user data based on the author ID
        async function readUserData(uid) {
            const userRef = admin.firestore().collection("users");
            const userDoc = await userRef.doc(uid).get();

            if (userDoc.exists) {
            return userDoc.data();
            } else {
            console.log("User not found with ID: ", uid);
            return null;
            }
        }

        // Get user data based on the author ID
        const userData = await readUserData(snapshot.data().sourceUid);

        if (userData) {
            // Retrieve FCM tokens associated with the user
            const userTokensSnapshot = await admin.firestore().collection("users").doc(snapshot.data().sourceUid).get();
            
            if (userTokensSnapshot.exists) {
                const userTokens = userTokensSnapshot.data().fcmTokens;
                console.log(userTokens);
                // Construct the notification payload
                const payload = {
                  notification: {
                    title: userData.username + ' commented on your post!' || 'New comment!',
                    body: comment || 'Click to see comment',
                  },
                  data: {
                    path: path,
                    type: type,
                  },
                  tokens: userTokens,
                };

                return admin.messaging().sendEachForMulticast(payload);

        
            //     // Send notifications to each device
            //     const sendNotifications = userTokens.map((token) => {
            //       return admin.messaging().send(payload);
            //     });
        
            //     return Promise.all(sendNotifications);
              } else {
                console.log('User tokens not found for UID:', uid);
                return null;
              }
            } else {
                console.log("User data not available.");
                return null;
              }
    });
