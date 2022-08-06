import 'package:flutter/material.dart';

import 'package:quizzzy/custom_widgets/custom_button.dart';
import 'package:quizzzy/custom_widgets/custom_popup.dart';
import 'package:quizzzy/custom_widgets/custom_template.dart';
import 'package:quizzzy/screens/import/file_browser_popop.dart';
import 'package:quizzzy/theme/font.dart';
import 'package:quizzzy/theme/palette.dart';

/// Renders [ImportFile] screen
///
/// Opens file browser with [CustomButton] pressed via [CustomPopup]
class ImportFile extends StatefulWidget {
  const ImportFile({Key? key}) : super(key: key);

  @override
  State<ImportFile> createState() => _ImportFileState();
}

class _ImportFileState extends State<ImportFile> {
  bool isLoading = false;

  Widget fileBrowser() {
    return SizedBox(
      width: double.infinity,
      child: IconButton(
        splashColor: Palette.transparent,
        constraints: const BoxConstraints(minHeight: 200.0),
        icon: Icon(
          Icons.upload_file_rounded,
          color: Palette.icon,
          size: 200.0,
        ),
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext cntxt) {
                return StatefulBuilder(builder: (cntxt, setState) {
                  return const FileBrowserPopup();
                });
              });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomTemplate(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Palette.txtFieldBg,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
              ),
              child: Center(
                child: Text(
                  '''Upload materials (PDF) to generate questions. Please make sure there are only
                  texts in uploaded content to get improved results.''',
                  style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 17,
                      fontWeight: Font.regular,
                      color: Palette.font),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          fileBrowser()
        ],
      ),
    );
  }
}
