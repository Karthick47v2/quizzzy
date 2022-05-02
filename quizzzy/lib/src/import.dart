import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:fdottedline/fdottedline.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/service/fs_database.dart';

class ImportFile extends StatefulWidget {
  final bool newUser;
  const ImportFile({Key? key, this.newUser = true}) : super(key: key);

  @override
  State<ImportFile> createState() => _ImportFileState();
}

class _ImportFileState extends State<ImportFile> {
  final fileNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(94, 153, 0, 255),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: const Center(
                  child: Text(
                    "Upload materials (PDF) to generate questions. Please make sure there are only texts in uploaded content to get improved results.",
                    style: TextStyle(
                        fontFamily: 'Heebo',
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Center(
                child: InkWell(
              child: FDottedLine(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: Image.asset(
                    'assets/images/upload.png',
                    scale: 2,
                    color: Colors.black45,
                  ),
                ),
                color: Colors.grey.shade700,
                strokeWidth: 2.0,
                dottedLength: 8.0,
                space: 3.0,
                corner: FDottedLineCorner.all(6.0),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext cntxt) {
                      return PopupModal(size: 200.0, wids: [
                        CustomTextInput(
                          text: "Questionnaire name",
                          controller: fileNameController,
                        ),
                        CustomNavigatorBtn(
                          text: "Confirm",
                          func: () => {
                            getFile(
                                context,
                                (fileNameController.text == "")
                                    ? "noname"
                                    : fileNameController.text),
                            setState(() {
                              fileNameController.text = "";
                            }),
                            Navigator.of(cntxt).pop()
                          },
                        )
                      ]);
                    });
              },
            ))
          ],
        ),
      ),
    );
  }
}

class QnA {
  final String question;
  final String crctAns;
  final List<String> allAns;
  QnA({required this.question, required this.crctAns, required this.allAns});
}

Future getQuestions(String cont, BuildContext context, String qName) async {
  var url = Uri.parse("https://mcq-gen-nzbm4e7jxa-el.a.run.app/get-questions");
  Map body = {'context': cont, 'uid': user?.uid, 'name': qName};

  var res = await http.post(url,
      headers: {"Content-Type": "application/json"}, body: json.encode(body));

  if (res.statusCode == 200) {
    await users.doc(user?.uid).set({
      'isWaiting': true,
    }, SetOptions(merge: true)).catchError(
        (err) => snackBar(context, err.toString(), (Colors.red.shade800)));
    // int noOfQues = decodedData['questions'].length;
    // List<QnA> qnaList = [];

    // for (int i = 0; i < noOfQues; i++) {
    //   List<String> ans = List.generate(4, (index) => 'null');
    //   for (int j = 0; j < 4; j++) {
    //     ans[j] = decodedData['all_answers'][i * 4 + j];
    //   }
    //   QnA qna = QnA(
    //       question: decodedData['questions'][i],
    //       crctAns: decodedData['crct_ans'][i],
    //       allAns: ans);
    //   qnaList.add(qna);
    // }
    // for (int i = 0; i < qnaList.length; i++) {
    //   print(qnaList[i].question);
    //   print(qnaList[i].crctAns);
    //   print(qnaList[i].allAns);
    // }
    // Navigator.pop(context);
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return NavigationBox(
    //         cont: context,
    //         text: "Questions are ready...!",
    //       );
    //     });
  } else {
    snackBar(context, res.body.toString(), (Colors.red.shade800));
  }
  snackBar(
      context,
      "Generating question may take a while. It will be available under 'Generated' once process is finished.",
      Colors.green.shade700);
}

void getFile(BuildContext context, String fileName) async {
  if (await getGeneratorStatus() != "Generated") {
    snackBar(context, "Please wait for previous document to get processed.",
        (Colors.amber.shade400));
    return;
  }

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  // check if name is already taken
  bool docExists = true;
  int i = 0;
  String tempName = fileName;
  while (docExists) {
    if ((await getUserDoc(tempName))!.exists) {
      tempName = fileName + "(" + (++i).toString() + ")";
    } else {
      docExists = false;
      fileName = tempName;
    }
  }

  if (result != null) {
    PDFDoc doc = await PDFDoc.fromPath(result.files.single.path.toString());
    String docText = await doc.text;
    getQuestions(docText, context, fileName);
  } else {
    return;
  }
}
