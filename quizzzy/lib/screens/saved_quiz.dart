// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quizzzy/controllers/user_type_controller.dart';
// import 'package:quizzzy/custom_widgets/custom_button.dart';
// import 'package:quizzzy/custom_widgets/custom_card.dart';
// import 'package:quizzzy/custom_widgets/custom_loading.dart';
// import 'package:quizzzy/custom_widgets/custom_popup.dart';
// import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
// import 'package:quizzzy/custom_widgets/custom_template.dart';
// import 'package:quizzzy/custom_widgets/top_bar.dart';
// import 'package:quizzzy/screens/questionnaire.dart';
// import 'package:quizzzy/service/db_model/question_set.dart';
// import 'package:quizzzy/service/fs_database.dart';
// import 'package:quizzzy/service/local_database.dart';
// import 'package:quizzzy/theme/font.dart';
// import 'package:quizzzy/theme/palette.dart';
// import 'package:share_plus/share_plus.dart';

// class SavedQuiz extends StatefulWidget {
//   final List<String> data;
//   final String status;
//   SavedQuiz({Key? key, required objData, required this.status})
//       : data = objData.map((val) => val.toString()).toList().cast<String>(),
//         super(key: key);

//   @override
//   State<SavedQuiz> createState() => _SavedQuizState();
// }

// class _SavedQuizState extends State<SavedQuiz> {
//   late List<String>? popList;
//   late List<QuestionSet> qSet;

//   filterList() async {
//     popList = await UserSharedPreferences().getPoppedItems();
//     if (popList != null) {
//       List<String> newList = [];
//       for (int i = 0; i < popList!.length; i++) {
//         if (widget.data.contains(popList![i])) {
//           widget.data.remove(popList![i]);
//           newList.add(popList![i]);
//         }
//       }
//       popList = newList;
//       UserSharedPreferences().setPoppedItems(popList!);
//     } else {
//       popList = [];
//     }
//   }

//   Future<bool> getQuestions(int idx) async {
//     // var questionnaire = questionSetBox.get(widget.data[idx]);
//     var questionnaire = null;

//     // ignore: unnecessary_null_comparison
//     if (questionnaire == null) {
//       questionnaire =
//           (await FirestoreService().getQuestionnaire(widget.data[idx]))
//               .map((e) => (QuestionSet.fromJson(e)))
//               .toList();
//       questionSetBox.put(widget.data[idx], questionnaire);
//     } else {
//       questionnaire = questionnaire..cast<QuestionSet>();
//       // fake waiting for future builder to work without break
//       await Future.delayed(Duration.zero);
//     }
//     qSet = questionnaire;
//     return true;
//   }

//   @override
//   initState() {
//     super.initState();
//     setBox();
//     if (widget.status == "Waiting") {
//       customSnackBar(
//           "Wait", "Your last request is being processed.", Palette.warning);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomTemplate(
//         body: FutureBuilder(
//             future: filterList(),
//             builder: (context, snapshot) {
//               Widget ret = Container();
//               if (snapshot.connectionState == ConnectionState.done) {
//                 ret = Column(
//                   children: [
//                     const TopBar(txt: "Select Questionnaire"),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: widget.data.length,
//                         itemBuilder: (context, idx) {
//                           return CustomCard(
//                               title: widget.data[idx],
//                               onLongPress: () {
//                                 // dlt from local if... and also from cloud
//                                 showDialog(
//                                     context: context,
//                                     builder: (_) {
//                                       return CustomPopup(size: 150.0, wids: [
//                                         Text(
//                                           "Share quiz",
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: 19,
//                                             fontWeight: Font.regular,
//                                             color: Palette.font,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                         Text(
//                                           "Code: de2022628104234nlp_1",
//                                           style: TextStyle(
//                                             fontFamily: fontFamily,
//                                             fontSize: 19,
//                                             fontWeight: Font.regular,
//                                             color: Palette.font,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ]);
//                                     });
//                                 Share.share('de2022628104234nlp_1');
//                               },
//                               onTap: () async {
//                                 var res = getQuestions(idx);
//                                 showDialog(
//                                     context: context,
//                                     builder: (BuildContext cntxt) {
//                                       return FutureBuilder(
//                                           future: res,
//                                           builder: (_, snapshot) {
//                                             Widget ret = Container();
//                                             if (snapshot.connectionState ==
//                                                 ConnectionState.done) {
//                                               ret = CustomPopup(
//                                                   size: 150.0,
//                                                   wids: [
//                                                     Text(
//                                                       "Questionnaire: ${widget.data[idx]}",
//                                                       style: TextStyle(
//                                                         fontFamily: fontFamily,
//                                                         fontSize: 22,
//                                                         fontWeight: Font.medium,
//                                                         color: Palette.font,
//                                                       ),
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                     ),
//                                                     Text(
//                                                       Get.find<UserTypeController>()
//                                                                   .userType ==
//                                                               'Student'
//                                                           ? "Time: ${qSet.length} mins"
//                                                           : "Questions: ${qSet.length}",
//                                                       style: TextStyle(
//                                                         fontFamily: fontFamily,
//                                                         fontSize: 20,
//                                                         fontWeight:
//                                                             Font.regular,
//                                                         color: Palette.font,
//                                                       ),
//                                                     ),
//                                                     CustomButton(
//                                                       text: Get.find<UserTypeController>()
//                                                                   .userType ==
//                                                               'Student'
//                                                           ? "Start"
//                                                           : "View",
//                                                       onTap: () {
//                                                         Get.back();
//                                                         Get.to(() =>
//                                                             const Questionnaire());
//                                                       },
//                                                     ),
//                                                   ]);
//                                             } else {
//                                               ret = const CustomLoading();
//                                             }
//                                             return ret;
//                                           });
//                                     });
//                               });
//                         },
//                       ),
//                     )
//                   ],
//                 );
//               } else {
//                 ret = const CustomLoading();
//               }
//               return ret;
//             }));
//   }
// }
