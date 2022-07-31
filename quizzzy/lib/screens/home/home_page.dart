import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/user_type_controller.dart';
import 'package:quizzzy/controllers/utils_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_loading.dart';
import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/service/fs_database.dart';
import 'package:quizzzy/service/local_database.dart';
import 'package:quizzzy/service/local_notification_service.dart';
import 'package:quizzzy/screens/home/home.dart';
import 'package:quizzzy/screens/home/user_details.dart';

/////////////////////////// NEEEED TO PUT GETX BUILDER FOR FIRST TIME

/// Renders [HomePage] screen
/// If [firstTime] render user details form, or else show menu. Navigates to appropiate screens
/// repective to [CustomButton] click.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> userFuture;
  bool firstTime = Get.find<UtilsController>().firstTime;
  final nameController = TextEditingController();
  final codeController = TextEditingController();

  Future<void> pushToken() async {
    questionSetBox = await setBox();
    String? token = await fm.getToken();
    String? oldToken = await UserSharedPreferences().getToken();
    if (oldToken != token) {
      await UserSharedPreferences().setToken(token!);
      await FirestoreService().saveTokenToDatabase(token);
    }
    fm.onTokenRefresh.listen(FirestoreService().saveTokenToDatabase);
  }

  @override
  initState() {
    super.initState();
    pushToken();
    userFuture = FirestoreService().getUserType();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTemplate(body: GetBuilder<UtilsController>(
      builder: (controller) {
        return FutureBuilder(
          future: userFuture,
          builder: (context, snapshot) {
            Widget ret = Container();
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null && firstTime) {
                /////////////////////////////////////////
                ret = UserDetails(nameController: nameController);
              } else {
                Get.find<UserTypeController>()
                    .setUserType(snapshot.data as String);
                ret = Home(codeController: codeController);
              }
            } else {
              ret = const CustomLoading();
            }
            return ret;
          },
        );
      },
    ));
  }
}
