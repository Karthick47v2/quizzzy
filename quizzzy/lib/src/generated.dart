import 'package:flutter/material.dart';
import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/service/fs_database.dart';

class Generated extends StatefulWidget {
  const Generated({Key? key}) : super(key: key);

  @override
  State<Generated> createState() => _GeneratedState();
}

class _GeneratedState extends State<Generated> {
  @override
  void initState() {
    // users.doc(user!.uid).update({'isWaiting': false, 'isGenerated': false});
    ///////////////// DO IT ON SERVER
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromARGB(255, 37, 37, 37),
          body: FutureBuilder(
              future: getQuestionnaireNameList('users/${user!.uid}'),
              builder: (context, snapshot) {
                Widget ret = Container();
                if (snapshot.connectionState == ConnectionState.done) {
                  // if (snapshot.data == "Generated") {
                  //   ret = Text("Generated");
                  // } else if (snapshot.data == "Waiting") {
                  //   ret = Text("Waiting");
                  // } else {
                  //   ret = Text("None");
                  // }
                  // ret = Text(snapshot.data!.toString());
                  if (snapshot.hasData) {
                    List<Object?> data = snapshot.data as List<Object?>;
                    print(data[1]);
                    print("Hell yea");
                  }
                } else {
                  ret = const Loading();
                }
                return ret;
              }),
        ),
      ),
    );
  }
}
