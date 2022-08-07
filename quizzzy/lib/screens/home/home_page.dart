import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/user_type_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_loading.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/custom_widgets/custom_text_input.dart';
import 'package:quizzzy/custom_widgets/render_img.dart';
import 'package:quizzzy/screens/home/custom_button_wrapper.dart';
import 'package:quizzzy/screens/home/home.dart';
import 'package:quizzzy/service/firestore_db.dart';
import 'package:quizzzy/theme/palette.dart';

/// Renders [HomePage] screen
///
/// If first time render user details form, or else show menu. Navigates to appropiate screens
/// repective to [CustomButton] click.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> userFuture;
  final nameController = TextEditingController();

  /// Set user type.
  Widget _userTypeButton(String btnTxt, bool isTeacher) {
    return CustomButtonWrapper(
        text: btnTxt,
        onTap: () async {
          if (!await FirestoreService()
              .sendUserType(nameController.text, isTeacher)) {
            customSnackBar("Error", "Internal server error", Palette.error);
          }
          setState(() {
            userFuture = FirestoreService().getUserType();
          });
        });
  }

  /// Get user type from [Firestore].
  @override
  initState() {
    super.initState();
    userFuture = FirestoreService().getUserType();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTemplate(
        body: FutureBuilder(
      future: userFuture,
      builder: (context, snapshot) {
        Widget ret = Container();
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == "None") {
            ret = Builder(
                builder: (_) => Column(
                      children: [
                        RenderImage(
                            path: 'assets/images/choice.svg',
                            expaned: true,
                            svgWidth: MediaQuery.of(context).size.width - 100),
                        CustomTextInput(
                            text: "Name", controller: nameController),
                        Container(
                          width: double.maxFinite - 20,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 0),
                          alignment: Alignment.bottomCenter,
                          child: Column(children: [
                            _userTypeButton("I'm a Teacher", true),
                            _userTypeButton("I'm a Student", false)
                          ]),
                        )
                      ],
                    ));
          } else {
            Future.delayed(Duration.zero, () {
              Get.find<UserTypeController>()
                  .setUserType(snapshot.data as String);
            });
            ret = const Home();
          }
        } else {
          ret = const CustomLoading();
        }
        return ret;
      },
    ));
  }
}
