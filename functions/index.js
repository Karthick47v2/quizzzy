const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { messaging } = require("firebase-admin");

admin.initializeApp();

// auth trigger (create user db)
exports.newUser = functions.auth.user().onCreate((user) => {
  return admin.firestore().collection("users").doc(user.uid).set({
    userType: null,
    isGenerated: false,
    isWaiting: false,
  });
});

// auth trigger (delete user db)
exports.dltUser = functions.auth.user().onDelete((user) => {
  const doc = admin.firestore().collection("users").doc(user.uid);
  return doc.delete();
});

// firestore trigger (send notification when question get generated)
exports.notifyUser = functions.firestore.document('users/{userID}/{qCol}/0').onCreate(async (snap, context) => {
  // get fcm token
  const user = await admin.firestore().collection("users").doc(context.params.userID).get();
  const token = user.data()['token'];

  await admin.messaging().send({
    notification: {
      title: "Questionnaire has been generated.",
      body: `Check out, "${context.params.qCol}" is added`
    },
    token: token,
  });
});