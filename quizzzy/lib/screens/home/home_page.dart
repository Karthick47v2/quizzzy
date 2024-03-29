import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quizzzy/controllers/user_type_controller.dart';
import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_loading.dart';
import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/screens/home/home.dart';
import 'package:quizzzy/screens/home/user_details.dart';
import 'package:quizzzy/service/firestore_db.dart';

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
            ret = Builder(builder: (_) => const UserDetails());
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
