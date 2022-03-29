import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:fdottedline/fdottedline.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';


class ImportFile extends StatefulWidget {
  final bool newUser;
  const ImportFile({ Key? key, this.newUser = true}) : super(key: key);

  @override
  State<ImportFile> createState() => _ImportFileState();
}

class _ImportFileState extends State<ImportFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 100,
            height: 128,
            width: 310,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color.fromARGB(94, 153, 0, 255),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: const Center(
                child: Text(
                  "Upload materials (PDF / doc) to generate questions. Please make sure there are only texts in uploaded content to get improved results.",
                  style: TextStyle(fontFamily: 'Heebo', fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white),
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
                getFile();
              },
            )
          )
        ],
      ),
    );  
  }
}

Future<bool> checkFileExists() async {
  return (await File(await getFilePath()).exists());
}

Future<String> getFilePath() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  String filePath = "$appDocPath/user.txt";

  return filePath;
}

void getFile() async {
  //First place a dummy file so that we can identify user already used the app (Applies for students)
  bool fileExists = await checkFileExists();

  if(!fileExists){
    File file = File(await getFilePath());
    file.writeAsString("1");
  }
  //////////////////////////////////////////////
  
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
  
  if(result != null){
    PDFDoc doc = await PDFDoc.fromPath(result.files.single.path.toString());
    String docText = await doc.text;

    debugPrint(docText);
  }
  else {
    return;
  }
}

