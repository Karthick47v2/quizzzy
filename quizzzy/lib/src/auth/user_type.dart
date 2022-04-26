import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzzy/src/auth/signup.dart';
import 'package:quizzzy/src/home_page.dart';
import '../../libs/custom_widgets.dart';

class UserType extends StatefulWidget {
  const UserType({Key? key}) : super(key: key);

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: const Color.fromARGB(255, 37, 37, 37),
            body: Builder(
              builder: (context) => Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/Quizzzy.png',
                      width: 229,
                      height: 278,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomTextInput(text: "Name", controller: nameController),
                      CustomNavigatorBtn(
                        text: "I'm a Teacher",
                        bt: 139.0,
                        h: 59.0,
                        w: 197.0,
                        func: () => sendUserType(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                            nameController.text,
                            true),
                      ),
                      CustomNavigatorBtn(
                        text: "I'm a Student",
                        bt: 40.0,
                        h: 59.0,
                        w: 197.0,
                        func: () => sendUserType(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                            nameController.text,
                            false),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}

Future<void> sendUserType(
  BuildContext context,
  Route route,
  String str,
  bool isTeacher,
) async {
  // create (if there isn't) and refer collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User? user = FirebaseAuth.instance.currentUser;

  await user?.updateDisplayName(str);

  users
      .doc(user?.email)
      .set({'name': user, 'isTeacher': isTeacher})
      .then((_) => Navigator.push(context, route))
      .catchError((err) => snackBar(context, err, (Colors.red.shade800)));
}
//////////////////////////////// await user?.delete()