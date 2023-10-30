var admin = require("firebase-admin");
const { applicationDefault } = require("firebase-admin/app");
var functions = require("firebase-functions");

admin.initializeApp({
  credential: applicationDefault()
});

exports.sendNotification = functions.firestore.document('posts/{docId}').onCreate((snapshot, context) => {
  const docId = context.params.docId; // Get the document ID from the context object

  const payload = {
    notification: {
      title: 'New post from ' + snapshot.data().author || 'New post!',
      body: snapshot.data().title || snapshot.data().body || 'Click to see post'
    },
    data: {
      postId: docId // Pass the ID of the newly created post
    }
  };

  return admin.messaging().sendToTopic('new_post', payload);
});