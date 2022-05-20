const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

const unauthenticatedErrorMsg =
  "This function must be called by an aunthenticated user";

// auth trigger => create user db
exports.newUser = functions.auth.user().onCreate((user) => {
  return db.collection("users").doc(user.uid).set({
    userType: null,
    isGenerated: false,
    isWaiting: false,
  });
});

// auth trigger => delete user db
exports.dltUser = functions.auth.user().onDelete((user) => {
  const doc = db.collection("users").doc(user.uid);
  return doc.delete();
});

// firestore trigger => send notification when question get generated
exports.notifyUser = functions.firestore
  .document("users/{userID}/{qCol}/0")
  .onCreate(async (data, context) => {
    // get fcm token
    const user = await db.collection("users").doc(context.params.userID).get();
    const token = user.data()["token"];

    await admin.messaging().send({
      notification: {
        title: "Questionnaire has been generated.",
        body: `Check out, '${context.params.qCol}' is added`,
      },
      token: token,
    });
  });

// callable func => store info
exports.storeUserInfo = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      unauthenticatedErrorMsg
    );
  }

  const docRef = db.doc(data.docPath);
  let res = { status: 200 };

  await docRef
    .set(
      {
        name: data.name,
        userType: data.type,
      },
      { merge: true }
    )
    .catch((err) => (res["status"] = 401));

  return res;
});

// callable func => send subscol list to device
exports.sendSubCollectionIDs = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      unauthenticatedErrorMsg
    );
  }

  let res = { status: 200 };
  await db
    .doc(data.docPath)
    .listCollections()
    .then((val) => val.map((col) => col.id))
    .then((val) => (res["ids"] = val))
    .catch((res["status"] = 401));
  return res;
});

// callable func => delete subcollection
exports.dltSubCollection = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      unauthenticatedErrorMsg
    );
  }

  db.recursiveDelete(db.collection(data.colPath));
  return { status: 200 };
});
