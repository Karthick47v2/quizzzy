const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// auth trigger (create user db)
exports.newUser = functions.auth.user().onCreate((user) => {
  return admin.firestore().collection("users").doc(user.uid).set({
    userType: null,
  });
});

// auth trigger (delete user db)
exports.dltUser = functions.auth.user().onDelete((user) => {
  const doc = admin.firestore().collection("users").doc(user.uid);
  return doc.delete();
});

sendReq = async (para) => {
  const res = await fetch(
    "https://mcq-gen-nzbm4e7jxa-ue.a.run.app/get-questions",
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.parse({ context: para }),
    }
  );

  res.json().then((data) => {
    console.log(data);
    return data;
  });
};

// http callable func (generate questions and save on db)
exports.genQuest = functions.https.onRequest((req, res) => {
  //   if (!context.auth) {
  //     throw new functions.https.HttpsError(
  //       "unauthenticated",
  //       "only authenticated users can use this function"
  //     );
  //   }
  // question
  async () => {
    res.send(
      "Hi, my name is karthick and i am 16 years old. I work at Google. My game is GTA."
    );
  };
  //   res.send();
  //   return sendReq(
  //     "Hi, my name is karthick and i am 16 years old. I work at Google. My game is GTA."
  //   );
});
