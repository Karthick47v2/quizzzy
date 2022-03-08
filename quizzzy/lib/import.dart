import 'package:flutter/material.dart';
import 'package:fdottedline/fdottedline.dart';

class ImportFile extends StatefulWidget {
  const ImportFile({ Key? key }) : super(key: key);

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
                    // width: 200,
                    // height: 300,
                    color: Colors.black45,
                  ),
                ),
                color: Colors.grey.shade700,
                strokeWidth: 2.0,
                dottedLength: 8.0,
                space: 3.0,
                corner: FDottedLineCorner.all(6.0),
              ),
              onTap: () {},
            )
          )
        ],
      ),
    );  
  }
}

