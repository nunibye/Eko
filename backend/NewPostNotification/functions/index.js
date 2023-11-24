var admin = require("firebase-admin");
const { applicationDefault } = require("firebase-admin/app");
var functions = require("firebase-functions");

admin.initializeApp({
  credential: applicationDefault()
});

exports.sendNotification = functions.firestore.document('posts/{docId}').onCreate(async (snapshot, context) => {
  const docId = context.params.docId; // Get the document ID from the context object

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
  const userData = await readUserData(snapshot.data().author);

  if (userData) {
    const payload = {
      notification: {
        title: 'New post from ' + userData.username || 'New post!',
        body: snapshot.data().title || snapshot.data().body || 'Click to see post',
      },
      data: {
        postId: docId // Pass the ID of the newly created post
      }
    };

    return admin.messaging().sendToTopic('new_post', payload);
  } else {
    console.log("User data not available.");
    return null;
  }
});