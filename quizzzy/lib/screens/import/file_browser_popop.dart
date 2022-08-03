import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:http/http.dart' as http;

import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_loading.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/custom_snackbar.dart';
import 'package:quizzzy/custom_widgets/custom_text_input.dart';
import 'package:quizzzy/service/fs_database.dart';
import 'package:quizzzy/theme/palette.dart';

class FileBrowserPopup extends StatefulWidget {
  const FileBrowserPopup({Key? key}) : super(key: key);

  @override
  State<FileBrowserPopup> createState() => _FileBrowserPopupState();
}

class _FileBrowserPopupState extends State<FileBrowserPopup> {
  final fileNameController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(_) {
    return CustomPopup(size: 200.0, wids: [
      isLoading
          ? const CustomLoading()
          : Column(
              children: [
                CustomTextInput(
                  text: "Questionnaire name",
                  controller: fileNameController,
                ),
                CustomButton(
                  text: "Confirm",
                  onTap: () async {
                    if (await Connectivity().checkConnectivity() !=
                        ConnectivityResult.none) {
                      getFile((fileNameController.text == "")
                          ? "noname"
                          : fileNameController.text);
                      setState(() {
                        fileNameController.text = "";
                        isLoading = true;
                      });
                    } else {
                      customSnackBar(
                          "Error", "No network access", Palette.error);
                    }
                    Get.back();
                  },
                )
              ],
            ),
    ]);
  }
}

/// Send extracted text ([cont]) to server along with [qName].
///
/// Throw error [customSnackBar] if anything goes wrong. Pop the [CustomPopup] at last.
Future getQuestions(String cont, String qName) async {
  var url = Uri.parse("https://mcq-gen-nzbm4e7jxa-el.a.run.app/get-questions");
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
    customSnackBar(
        "Success",
        "Generating question may take a while. It will be available under 'Question Bank' once process is finished.",
        Palette.sucess);
    if (!await FirestoreService().saveUser(false, state: true)) {
      customSnackBar("Error", "Connection error", Palette.error);
    }
  } else {
    customSnackBar("Error", res.body.toString(), Palette.error);
  }
}

/// Load and saved extracted text from user selected file into memory
///
/// Send [docText] to server if correct file format selected or else do nothing.
getFile(String fileName) async {
  if (await FirestoreService().getGeneratorStatus() == "Waiting") {
    customSnackBar("...", "Please wait for previous document to get processed.",
        Palette.warning);
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
    getQuestions(docText, fileName);
  } else {
    return;
  }
}
