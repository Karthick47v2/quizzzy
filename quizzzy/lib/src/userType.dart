// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzzy/src/service/fs_database.dart';

import '../libs/custom_widgets.dart';

// ignore: must_be_immutable
class UserType extends StatefulWidget {
  bool firstTime;

  UserType({Key? key, required this.firstTime}) : super(key: key);

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return QuizzzyTemplate(
      body: Builder(
          builder: (context) => Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/Quizzzy.png',
                      ),
                    ),
                  ),
                  QuizzzyTextInput(text: "Name", controller: nameController),
                  Container(
                    width: double.maxFinite - 20,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    alignment: Alignment.bottomCenter,
                    child: Column(children: [
                      SizedBox(
                        width: double.maxFinite - 20,
                        child: QuizzzyNavigatorBtn(
                          text: "I'm a Teacher",
                          onTap: () {
                            sendUserType(context, nameController.text, true);
                            setState(() {
                              // user will stuck at user type assign if network is slow, so
                              // bypassing fireabse response (only needed for first time use)
                              widget.firstTime = false;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite - 20,
                        child: QuizzzyNavigatorBtn(
                            text: "I'm a Student",
                            onTap: () {
                              sendUserType(context, nameController.text, false);
                              setState(() {
                                widget.firstTime = false;
                              });
                            }),
                      ),
                    ]),
                  )
                ],
              )),
    );
  }

  Future sendUserType(
    BuildContext context,
    String str,
    bool isTeacher,
  ) async {
    // explicitly initialize inorder to reload
    User? user = FirebaseAuth.instance.currentUser;

    await user!.reload();
    await user.updateDisplayName(str);
    await user.reload();
    user = FirebaseAuth.instance.currentUser;

    await fs.users.doc(user?.uid).set({
      ////////////////TODO: USE CLOUD FUNCTIONS
      'name': user?.displayName,
      'userType': isTeacher ? 'Teacher' : 'Student'
    }, SetOptions(merge: true)).catchError(
        (err) => snackBar(context, err.toString(), (Colors.red.shade800)));
  }
}
