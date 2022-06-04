import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/service/fs_database.dart';

class ImportFile extends StatefulWidget {
  const ImportFile({Key? key}) : super(key: key);

  @override
  State<ImportFile> createState() => _ImportFileState();
}

class _ImportFileState extends State<ImportFile> {
  final fileNameController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return QuizzzyTemplate(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
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
              child: Image.asset('assets/images/upload.png',
                  scale: 2, color: const Color.fromARGB(115, 155, 155, 155)),
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
                barrierDismissible: false,
                builder: (BuildContext cntxt) {
                  return StatefulBuilder(builder: (cntxt, setState) {
                    return PopupModal(size: 200.0, wids: [
                      isLoading
                          ? const Loading()
                          : Column(
                              children: [
                                QuizzzyTextInput(
                                  text: "Questionnaire name",
                                  controller: fileNameController,
                                ),
                                QuizzzyNavigatorBtn(
                                  text: "Confirm",
                                  onTap: () async {
                                    if (await Connectivity()
                                            .checkConnectivity() !=
                                        ConnectivityResult.none) {
                                      getFile(
                                          cntxt,
                                          (fileNameController.text == "")
                                              ? "noname"
                                              : fileNameController.text);
                                      setState(() {
                                        fileNameController.text = "";
                                        isLoading = true;
                                      });
                                    } else {
                                      snackBar(cntxt, "No network access",
                                          (Colors.red.shade800));
                                      Navigator.pop(cntxt);
                                    }
                                  },
                                )
                              ],
                            ),
                    ]);
                  });
                });
          },
        ))
      ],
    ));
  }

  Future getQuestions(String cont, BuildContext context, String qName) async {
    var url =
        Uri.parse("https://mcq-gen-nzbm4e7jxa-el.a.run.app/get-questions");
    Map body = {'context': cont, 'uid': fs.user!.uid, 'name': qName};

    var res = await http
        .post(url,
            headers: {"Content-Type": "application/json"},
            body: json.encode(body))
        .timeout(const Duration(seconds: 5), onTimeout: () {
      return http.Response(
          'Service unavailabe. Check your internet connection', 408);
    });

    if (res.statusCode == 200) {
      snackBar(
          context,
          "Generating question may take a while. It will be available under 'Question Bank' once process is finished.",
          Colors.green.shade700);
      if (!await fs.setWaiting(true)) {
        snackBar(context, "Connection error", (Colors.red.shade800));
      }
    } else {
      snackBar(context, res.body.toString(), (Colors.red.shade800));
    }
    Navigator.pop(context);
  }

  getFile(BuildContext context, String fileName) async {
    if (await fs.getGeneratorStatus() == "Waiting") {
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
      if ((await fs.getUserDoc(tempName))!.exists) {
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
}
