import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:fdottedline/fdottedline.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


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

class QnA{
  final String question;
  final String crctAns;
  final List<String> allAns;
  QnA({required this.question, required this.crctAns, required this.allAns});
}

Future getQuestions(String context) async {
  var url = Uri.parse("https://mcq-gen-nzbm4e7jxa-ue.a.run.app/get-questions");
  Map body = {
    'context' : context
  };

  var res = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(body));
  
  if(res.statusCode == 200){
    var decodedData = json.decode(res.body);
    int noOfQues = decodedData['questions'].length;
    List<QnA> qnaList = [];

    for(int i = 0; i < noOfQues; i++){
      List<String> ans = List.generate(4, (index) => 'null');
      for(int j = 0; j < 4; j++){
        ans[j] = decodedData['all_answers'][i * 4 + j];
      }
      QnA qna = QnA(
        question: decodedData['questions'][i], 
        crctAns: decodedData['crct_ans'][i],
        allAns: ans
        );
        qnaList.add(qna);
    }
    for(int i = 0; i < qnaList.length; i++){
      print(qnaList[i].question);
      print(qnaList[i].crctAns);
      print(qnaList[i].allAns);
    }
  }
  else{
    print("Np");
    //////////////////////////////////////
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

    // debugPrint(docText);
    print("sending to Cloud");
    getQuestions(docText);
  }
  else {
    return;
  }
}

