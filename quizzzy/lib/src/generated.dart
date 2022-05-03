import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/questionnaire.dart';
import 'package:quizzzy/src/service/db_model/question_set.dart';
import 'package:quizzzy/src/service/fs_database.dart';

class Generated extends StatefulWidget {
  final List<Object?> data;
  final String status;
  const Generated({Key? key, required this.data, required this.status})
      : super(key: key);

  @override
  State<Generated> createState() => _GeneratedState();
}

class _GeneratedState extends State<Generated> {
  late final questionSetBox;
  setBox() async {
    questionSetBox = await Hive.openBox((user?.displayName)!);
  }

  @override
  initState() {
    super.initState();
    setBox();
    if (widget.status == "Waiting") {
      snackBar(context, "Your last request is being processed.",
          (Colors.amber.shade400));
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuizzzyTemplate(
        body: ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (context, idx) {
        return QuizzzyCard(
            title: widget.data[idx].toString(),
            func: () async {
              // get from local if there is, or else fetch from net and store for future use
              var questionnaire = Hive.box((user?.displayName)!)
                  .get(widget.data[idx].toString())
                  .cast<QuestionSet>();
              if (questionnaire == null) {
                questionnaire =
                    (await getQuestionnaire(widget.data[idx].toString()))
                        .map((e) => (QuestionSet.fromJson(e)))
                        .toList();
                Hive.box((user?.displayName)!)
                    .put(widget.data[idx].toString(), questionnaire);
              }
              showDialog(
                  context: context,
                  builder: (BuildContext cntxt) {
                    return PopupModal(size: 150.0, wids: [
                      Text(
                        "Questionnaire: ${widget.data[idx].toString()}",
                        style: const TextStyle(
                          fontFamily: 'Heebo',
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      Text(
                        "Time: ${questionnaire.length} mins",
                        style: const TextStyle(
                          fontFamily: 'Heebo',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      QuizzzyNavigatorBtn(
                        text: "Start",
                        cont: context,
                        func: () {
                          Navigator.of(cntxt).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => Questionnaire(
                                      questionnaire: questionnaire))));
                        },
                      ),
                    ]);
                  });
            });
      },
    ));
  }
}
