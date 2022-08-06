const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

const httpsError = new functions.https.HttpsError(
  "unauthenticated",
  "This function must be called by an aunthenticated user"
);

// auth trigger => create user db
exports.newUser = functions.auth.user().onCreate((user) => {
  return db.collection("users").doc(user.uid).set({
    userType: null,
    GeneratorWorking: false,
  });
});

// auth trigger => delete user db
exports.dltUser = functions.auth.user().onDelete((user) => {
  return db.collection("users").doc(user.uid).delete();
});

// firestore trigger => send notification when question get generated
exports.notifyUser = functions.firestore
  .document("users/{userID}/{qCol}/0")
  .onCreate(async (_data, context) => {
    const user = await db
      .collection("users")
      .doc(`users/${context.auth.uid}`)
      .get();

    await db
      .doc(`users/${context.auth.uid}`)
      .set({ isWaiting: false }, { merge: true });

    await admin.messaging().send({
      notification: {
        title: "Questionnaire has been generated.",
        body: `Check out, '${context.params.qCol}' is added`,
      },
      token: user.data()["token"],
    });
  });

// callable func => store info
exports.storeUserInfo = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw httpsError;
  }

  let res = { status: 200 };

  await db
    .doc(`users/${context.auth.uid}`)
    .set(data, { merge: true })
    .catch(() => (res["status"] = 401));

  return res;
});

// callable func => send subscol list to device
exports.sendSubCollectionIDs = functions.https.onCall(
  async (_data, context) => {
    if (!context.auth) {
      throw httpsError;
    }

    let res = { status: 200 };
    await db
      .collection("users")
      .doc(context.auth.uid)
      .listCollections()
      .then((val) => val.map((col) => col.id))
      .then((val) => (res["ids"] = val))
      .catch(() => (res["status"] = 401));
    return res;
  }
);

// callable func => delete questions
exports.dltQuestions = functions.https.onCall((data, context) => {
  if (!context.auth) {
    throw httpsError;
  }

  data.qID.forEach((element) => {
    db.collection("users")
      .doc(context.auth.uid)
      .collection(data.col)
      .doc(element)
      .delete();
  });

  return { status: 200 };
});
