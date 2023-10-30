var admin = require("firebase-admin");
const { applicationDefault } = require("firebase-admin/app");
var functions = require("firebase-functions");

admin.initializeApp({
  credential: applicationDefault()
});

exports.sendNotification = functions.firestore.document('posts/{docId}').onCreate((snapshot, context) => {
const payload = {
notification: {
title: 'New content available',
body: 'Check out the latest update!'
}
};

return admin.messaging().sendToTopic('new_post', payload);
});