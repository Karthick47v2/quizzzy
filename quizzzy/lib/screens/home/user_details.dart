import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/custom_widgets/custom_text_input.dart';
import 'package:quizzzy/custom_widgets/render_img.dart';
import 'package:quizzzy/screens/home/custom_button_wrapper.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/service/firestore_db.dart';
import 'package:quizzzy/theme/palette.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final nameController = TextEditingController();

  /// Set user type.
  Widget _userTypeButton(String key, String btnTxt, bool isTeacher) {
    return CustomButtonWrapper(
        key: Key(key),
        text: btnTxt,
        onTap: () async {
          if (!await FirestoreService()
              .sendUserType(nameController.text, isTeacher)) {
            customSnackBar("Error", "Internal server error", Palette.error);
          }
          setState(() {
            Get.offAll(() => const HomePage());
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      child: Column(
        children: [
          RenderImage(
              path: 'assets/images/choice.svg',
              expaned: true,
              svgWidth: MediaQuery.of(context).size.width - 100),
          CustomTextInput(
              key: const Key('text-input-name'),
              text: "Name",
              controller: nameController),
          Container(
            width: MediaQuery.of(context).size.width - 100,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            alignment: Alignment.bottomCenter,
            child: Column(children: [
              _userTypeButton('button-teacher', "I'm a Teacher", true),
              _userTypeButton('button-student', "I'm a Student", false)
            ]),
          )
        ],
      ),
    );
  }
}
