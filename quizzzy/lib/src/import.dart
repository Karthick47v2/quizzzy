import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:http/http.dart' as http;

import 'package:quizzzy/libs/custom_widgets.dart';
import 'package:quizzzy/src/service/fs_database.dart';

/// Renders [ImportFile] screen
///
/// Opens file browser with [QuizzzyNavigatorBtn] pressed via [PopupModal]
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
                  '''Upload materials (PDF) to generate questions. Please make sure there are only
                  texts in uploaded content to get improved results.''',
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
          SizedBox(
            width: double.infinity,
            child: IconButton(
              splashColor: Colors.transparent,
              constraints: const BoxConstraints(minHeight: 200.0),
              icon: const Icon(
                Icons.upload_file_rounded,
                color: Color.fromARGB(115, 155, 155, 155),
                size: 200.0,
              ),
              onPressed: () {
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
                                          snackBar("Error", "No network access",
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
            ),
          )
        ],
      ),
    );
  }

  /// Send extracted text ([cont]) to server along with [qName].
  ///
  /// Throw error [SnackBar] if anything goes wrong. Pop the [PopupModal] at last.
  Future getQuestions(String cont, BuildContext context, String qName) async {
    var url =
        Uri.parse("https://mcq-gen-nzbm4e7jxa-el.a.run.app/get-questions");
    Map body = {
      'context': cont,
      'uid': FirestoreService().user!.uid,
      'name': qName
    };

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
          "Success",
          "Generating question may take a while. It will be available under 'Question Bank' once process is finished.",
          Colors.green.shade700);
      if (!await FirestoreService().saveUser(false, state: true)) {
        snackBar("Error", "Connection error", (Colors.red.shade800));
      }
    } else {
      snackBar("Error", res.body.toString(), (Colors.red.shade800));
    }
    Navigator.pop(context);
  }

  /// Load and saved extracted text from user selected file into memory
  ///
  /// Send [docText] to server if correct file format selected or else do nothing.
  getFile(BuildContext context, String fileName) async {
    if (await FirestoreService().getGeneratorStatus() == "Waiting") {
      snackBar("...", "Please wait for previous document to get processed.",
          (Colors.amber.shade400));
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    /// check if [fileName] is taken.
    bool docExists = true;
    int i = 0;
    String tempName = fileName;
    while (docExists) {
      if ((await FirestoreService().getUserDoc(tempName))!.exists) {
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
