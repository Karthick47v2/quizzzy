import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/utils_controller.dart';
import 'package:quizzzy/screens/home/custom_button_wrapper.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/custom_widgets/custom_text_input.dart';
import 'package:quizzzy/custom_widgets/quizzzy_logo.dart';
import 'package:quizzzy/service/fs_database.dart';
import 'package:quizzzy/theme/palette.dart';

class UserDetails extends StatefulWidget {
  final TextEditingController nameController;
  const UserDetails({Key? key, required this.nameController}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  Widget _userTypeButton(String btnTxt, bool isTeacher) {
    return CustomButtonWrapper(
        text: btnTxt,
        onTap: () async {
          if (!await FirestoreService()
              .sendUserType(widget.nameController.text, isTeacher)) {
            customSnackBar(
                "Error", "Internal server error", Palette.error);
          }
          Get.find<UtilsController>().setRegistered();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => Column(
              children: [
                const QuizzzyLogo(),
                CustomTextInput(
                    text: "Name", controller: widget.nameController),
                Container(
                  width: double.maxFinite - 20,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                  alignment: Alignment.bottomCenter,
                  child: Column(children: [
                    _userTypeButton("I'm a Teacher", true),
                    _userTypeButton("I'm a Student", false)
                  ]),
                )
              ],
            ));
  }
}
