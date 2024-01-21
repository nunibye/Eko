const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const firestore = admin.firestore();

exports.deleteData = functions.runWith({ enforceAppCheck: true, }).https.onCall(async (data, context) => {
    const path = data.path;
    const ref = firestore.doc(path);
    await firestore.recursiveDelete(ref);
});
