// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quizzzy/controllers/user_type_controller.dart';

// import 'package:quizzzy/libs/custom_widgets.dart';
// import 'package:quizzzy/src/home_page.dart';
// import 'package:quizzzy/src/score.dart';
// import 'package:quizzzy/src/service/db_model/question_set.dart';
// import 'package:quizzzy/src/service/fs_database.dart';
// import 'package:quizzzy/src/service/local_database.dart';

// class ReviewQuiz extends StatefulWidget {
//   const ReviewQuiz({Key? key}) : super(key: key);

//   @override
//   State<ReviewQuiz> createState() => _ReviewQuizState();
// }

// class _ReviewQuizState extends State<ReviewQuiz> {
//   int currentQ = 0, score = 0, time = 0;
//   late List<bool> qState = List.filled(4, false);
//   late List<QuestionSet> quesPrep;

//   @override
//   initState() {
//     super.initState();
//     if (Get.find<UserTypeController>().userType == 'Student') {
//       // widget.questionnaire.shuffle();
//       time = widget.questionnaire.length * 60;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return QuizzzyTemplate(
//         body: Column(
//       children: [
//         Expanded(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.fromLTRB(130, 30, 10, 50),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: const BoxDecoration(
//                     color: Color.fromARGB(94, 155, 155, 155),
//                     borderRadius: BorderRadius.all(Radius.circular(24)),
//                   ),
//                   child: Center(
//                     child: Text(
//                       widget.questionnaire[currentQ].question,
//                       style: const TextStyle(
//                           fontFamily: 'Heebo',
//                           fontSize: 22,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ),
//               for (var i in widget.questionnaire[currentQ].allAns)
//                 QuizzzyAns(
//                   ans: i,
//                   isPicked: i.toLowerCase() ==
//                       widget.questionnaire[currentQ].crctAns.toLowerCase(),
//                   onTap: () {},
//                 ),
//             ],
//           ),
//         ),
//         Container(
//           height: 100,
//           width: double.maxFinite,
//           alignment: Alignment.center,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "${currentQ + 1} / ${widget.questionnaire.length}",
//                 style: const TextStyle(
//                     fontFamily: 'Heebo',
//                     fontSize: 18,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.white),
//               ),
//               QuizzzyNavigatorBtn(
//                 text: "Next",
//                 onTap: () => updateQuestion(),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ));
//   }

//   updateQuestion({bool isRemove = false}) {
//     if (Get.find<UserTypeController>().userType == 'Student') {
//       // atleast 1 ans should be selected inorder to go to next question
//       if (qState.any((e) => e)) {
//         setState(() {
//           if (currentQ < widget.questionnaire.length - 1) {
//             if (checkAns()) {
//               score++;
//             }
//             refreshAns();
//             currentQ++;
//           } else {
//             if (checkAns()) {
//               score++;
//             }
//             // ignore: avoid_print
//             print(score);
//             showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (BuildContext cntxt) {
//                   return PopupModal(size: 150.0, wids: [
//                     Text(
//                       "You got ${100 * score / widget.questionnaire.length}",
//                       style: const TextStyle(
//                           fontFamily: 'Heebo',
//                           fontSize: 22,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                     const Text(
//                       "You can always review quizzes from main menu",
//                       style: TextStyle(
//                           fontFamily: 'Heebo',
//                           fontSize: 19,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         QuizzzyNavigatorBtn(
//                           text: "Continue",
//                           onTap: () async {
//                             Navigator.pop(cntxt); ///////////////////////
//                             Get.to(() => const HomePage());
//                           },
//                         )
//                       ],
//                     ),
//                   ]);
//                 });
//           }
//         });
//       }
//     } else {
//       setState(() {
//         if (currentQ < widget.questionnaire.length - 1) {
//           if (isRemove) {
//             widget.questionnaire.removeAt(currentQ);
//           } else {
//             currentQ++;
//           }
//         } else {
//           showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (BuildContext cntxt) {
//                 return PopupModal(size: 150.0, wids: [
//                   const Text(
//                     "Press continue to modify changes, cancel to revert",
//                     style: TextStyle(
//                         fontFamily: 'Heebo',
//                         fontSize: 22,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.white),
//                     textAlign: TextAlign.center,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       QuizzzyNavigatorBtn(
//                         text: "Cancel",
//                         onTap: () 
//                           Get.to(() => const HomePage())
//                         ,
//                       ),
//                       QuizzzyNavigatorBtn(
//                         text: "Continue",
//                         onTap: () async {
//                           // if (isRemove) {
//                           //   if (widget.questionnaire.length == 1) {
//                           //     // removeQuestionnaire();
//                           //   } else {
//                           //     modifyQuestionSet(
//                           //         widget.name, widget.questionnaire, true);
//                           //   }
//                           // } else {
//                           //   modifyQuestionSet(
//                           //       widget.name, widget.questionnaire, false);
//                           // }
//                           Navigator.pop(cntxt); ///////////////////////
//                           Get.to(() => const HomePage());
//                         },
//                       )
//                     ],
//                   ),
//                 ]);
//               });
//         }
//       });
//     }
//   }

//   modifyQuestionSet(String name, List<QuestionSet> q, bool removeLast) {
//     FirestoreService().saveModifiedQuiz(q);
//   }

//   removeQuestionnaire() async {
//     questionSetBox.delete(widget.name);
//     if (!await FirestoreService().deleteQuestionnaire(
//         'users/${FirestoreService().user!.uid}/${widget.name}')) {
//       snackBar(context, "Error: Please try again", Colors.red.shade800);
//     } else {
//       var popList = await UserSharedPreferences().getPoppedItems();
//       popList ??= [];
//       popList.add(widget.name);
//       UserSharedPreferences().setPoppedItems(popList);
//     }
//   }

//   bool checkAns() {
//     return widget.questionnaire[currentQ].allAns[qState.indexOf(true)]
//             .toLowerCase() ==
//         widget.questionnaire[currentQ].crctAns.toLowerCase();
//   }

//   refreshAns() {
//     qState.setAll(0, [false, false, false, false]);
//   }
// }
